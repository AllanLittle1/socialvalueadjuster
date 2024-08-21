library(httr)

# Function to retrieve content from a text file
get_content_from_file <- function(file_path) {
  content <- readLines(file_path, warn = FALSE)
  return(paste(content, collapse = "\n"))
}

# Function to retrieve relevant sections from a text document based on the user query using grep
search_relevant_sections <- function(query, file_path) {
  # Load the text document (Green Book)
  text_content <- readLines(file_path, warn = FALSE)
  
  # Use grep to find relevant sections
  matched_lines <- grep(query, text_content, value = TRUE)
  
  return(paste(matched_lines, collapse = "\n"))
}

# Read the API key from the configuration file
config <- readLines("config.txt")
api_key <- gsub("OPENAI_API_KEY=", "", config[grep("OPENAI_API_KEY", config)])

openai_api_endpoint <- "https://api.openai.com/v1/chat/completions"

# Function to call the OpenAI API
openai_api_call <- function(prompt_text, conversation_history) {
  # Retrieve the system prompt
  system_prompt <- get_content_from_file("getreal_system_prompt.txt")
  
  # Initialize the conversation history with the initial system prompt if not already set
  if (length(conversation_history) == 0) {
    conversation_history <- list(list(role = "system", content = system_prompt))
  }
  
  # Retrieve relevant sections based on the user prompt using grep
  sections <- search_relevant_sections(prompt_text, "getreal_rag.txt")
  
  # Add the relevant sections to the conversation history
  conversation_history <- c(conversation_history, list(list(role = "system", content = sections)))
  
  # Add the user message to the conversation history
  conversation_history <- c(conversation_history, list(list(role = "user", content = prompt_text)))
  
  # API call
  response <- POST(openai_api_endpoint,
                   add_headers(Authorization = paste0("Bearer ", api_key)),
                   body = list(model = "gpt-4", messages = conversation_history),
                   encode = "json")
  
  # Parse the response
  parsed_response <- content(response, "parsed")
  assistant_message <- parsed_response$choices[[1]]$message$content
  
  # Add the assistant's message to the conversation history
  conversation_history <- c(conversation_history, list(list(role = "assistant", content = assistant_message)))
  
  # Return the assistant's message and the updated conversation history
  return(list(assistant_message, conversation_history))
}

# Initialize conversation history
conversation_history <- list()

# SERVER SET UP -------------------------------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # INITIALISE TOOLTIP -----------------------------------------------------------------------------------------------------
  shinyjs::runjs("$('.custom-tooltip').tooltip({container: 'body', placement: 'top', html: true});")
  
  # LOAD DATA (inside server) -----------------------------------------------------------------------------------------------
  deflators <- read_excel("socialvalueadjuster_deflators.xlsx", sheet = "deflators")
  discount_factors <- read_excel("socialvalueadjuster_deflators.xlsx", sheet = "discount")
  
  # Create discount_data based on discount_factors, assuming it has columns 'year', 'df_stpr_standard', etc.
  discount_data <- data.frame(
    year = discount_factors$year,
    df_stpr_standard = discount_factors$df_stpr_standard,
    df_stpr_reduced_rate_where_pure_stp_0 = discount_factors$df_stpr_reduced_rate_where_pure_stp_0,
    df_health = discount_factors$df_health,
    df_health_reduced_rate_where_pure_stp_0 = discount_factors$df_health_reduced_rate_where_pure_stp_0
  )
  
  # REACTIVE VALUE TO STORE ADJUSTED VALUE AND CALCULATION STATUS -----------------------------------------------------------
  rv <- reactiveValues(adjusted_value = NULL, calculated = FALSE, showAlert = FALSE, cumulative_inflation = NULL, avg_inflation = NULL)
  
  # RESET CALCULATION STATUS AND UI WHEN INPUTS CHANGE -----------------------------------------------------------------------
  observe({
    input$nominal_value
    input$price_year
    input$adjusted_year
    input$year_type
    input$value_type
    
    rv$calculated <- FALSE
    rv$showAlert <- FALSE
    output$adjusted_value <- renderUI({NULL})
  })
  
  # CALCULATOR ----------------------------------------------------------------------------------------------------------------------
  observeEvent(input$adjust, {
    # Ensure inputs available and as numeric ------
    req(input$nominal_value, input$price_year, input$adjusted_year)  
    nominal_value <- as.numeric(input$nominal_value)
    price_year <- as.numeric(input$price_year)
    adjusted_year <- as.numeric(input$adjusted_year)
    
    # Create deflator objects ------
    if (input$year_type == "fy") {
      # Financial Year
      deflator_start <- deflators$deflator_fy[deflators$year == price_year]
      deflator_end <- deflators$deflator_fy[deflators$year == adjusted_year]
      gdp_per_capita_start <- deflators$gdp_per_capita[deflators$year == price_year]
      gdp_per_capita_end <- deflators$gdp_per_capita[deflators$year == adjusted_year]
    } else {
      # Calendar Year
      deflator_start <- deflators$deflator_cy[deflators$year == price_year]
      deflator_end <- deflators$deflator_cy[deflators$year == adjusted_year]
      gdp_per_capita_start <- deflators$gdp_per_capita[deflators$year == price_year]
      gdp_per_capita_end <- deflators$gdp_per_capita[deflators$year == adjusted_year]
    }
    
    # Calculate real values ------
    if (is.na(nominal_value) || is.na(deflator_start) || is.na(deflator_end) || 
        (input$value_type == "wellbeing" && (is.na(gdp_per_capita_start) || is.na(gdp_per_capita_end)))) {
      output$adjusted_value <- renderUI({
        HTML("<div style='text-align: center; color: red;'>Please enter valid values. 
             Note that wellbeing values can only be calculated up to 2023 prices, 
             and standard social values up to 2028, given the availability of forecast data. 
             But in most cases your real values should be stated in a recent, historic year such as 2023.</div>")
      })
    } else {
      if (input$value_type == "wellbeing") {
        # Adjust the nominal value using the deflators and GDP per capita for wellbeing value
        rv$adjusted_value <- nominal_value * (deflator_end / deflator_start) * 
          (gdp_per_capita_end / gdp_per_capita_start) ^ 1.3
      } else {
        # Adjust the nominal value using the deflators for standard value
        rv$adjusted_value <- nominal_value * (deflator_end / deflator_start)
      }
      
      rv$calculated <- TRUE
      
      # Calculate cumulative and average inflation ----
      rv$cumulative_inflation <- (deflator_end / deflator_start - 1) * 100
      years_diff <- adjusted_year - price_year
      rv$avg_inflation <- ((deflator_end / deflator_start)^(1/years_diff) - 1) * 100
      
      # Render UI  ------          
      output$adjusted_value <- renderUI({
        req(input$nominal_value, input$price_year, input$adjusted_year)
        div(style = "text-align: center; position: relative;",
            HTML(paste0("<div style='text-align: center; font-size: 18px;'>",
                        "Your value in real terms is <b style='color: #337ab7;'>£", 
                        format(round(rv$adjusted_value, 2), big.mark = ","), "</b>.</div>")),
            br(),
            HTML(paste0("<div style='font-size: 14px; color: #666; text-align: center;'>",
                        "Cumulative inflation ", input$price_year, " to ", input$adjusted_year, ": ",
                        round(rv$cumulative_inflation, 1), "%<br>",
                        "Average inflation per year: ", round(rv$avg_inflation, 1), "%<br>","</div>")))})
      
      # Show additional buttons after calc ------
      shinyjs::show("additional_buttons")
      
      # Show alert panel
      rv$showAlert <- TRUE
      
    }
  }) #End Calculator
  
  # Reactive output for the conditional panel
  output$showAlert <- reactive({
    rv$showAlert
  })
  outputOptions(output, "showAlert", suspendWhenHidden = FALSE)
  
  # DATA FRAME ----------------------------------------------------------------------------------------------------------------------- 
  deflators_df <- data.frame(year = deflators$year, deflator_cy = deflators$deflator_cy, deflator_fy = deflators$deflator_fy,
                             label_fy = deflators$label_fy, gdp_per_capita = deflators$gdp_per_capita, stringsAsFactors = FALSE)
  
  # CSV REAL-----------------------------------------------------------------------------------------------------------------------------
  output$download_csv <- downloadHandler(
    filename = function() {paste("deflators_data", Sys.Date(), ".csv", sep = "")},
    content = function(file) {write.csv(deflators_df, file, row.names = FALSE)})
  
  # REPORT REAL-----------------------------------------------------------------------------------------------------------------------------
  output$download_report <- downloadHandler(
    filename = function() {paste("Get Real: Real Values Report ", Sys.Date(), ".docx", sep = "")},
    content = function(file) {
      req(input$nominal_value, input$price_year, input$adjusted_year, rv$adjusted_value, rv$cumulative_inflation, rv$avg_inflation)
      params <- list(
        nominal_value = format(round(as.numeric(input$nominal_value), 2), big.mark = ",", nsmall = 2),
        price_year = input$price_year,
        adjusted_year = input$adjusted_year,
        adjusted_value = format(round(rv$adjusted_value, 2), big.mark = ",", nsmall = 2),
        cumulative_inflation = round(rv$cumulative_inflation, 2),
        avg_inflation = round(rv$avg_inflation, 2),
        year_type = input$year_type,
        value_type = input$value_type,
        deflators_df = deflators_df)
      
      rmarkdown::render("report_real_values.Rmd", 
                        output_file = file, params = params, envir = new.env(parent = globalenv()))
    }
  )
  
  # PV CALCULATOR ------------------------------------------------------------------------------------------------------------- 
  # Reactive value for Present Value calculation -------------
  rv_pv <- reactiveValues(present_value = NULL, calculated = FALSE, discount_factor = NULL)
  
  # Reset calculation status when inputs change -------------
  observe({
    input$pv_real_value
    input$pv_future_year
    input$pv_present_year
    input$pv_discount_type
    input$pv_rate_type
    
    rv_pv$calculated <- FALSE
    output$present_value_output <- renderUI({NULL})
  })
  
  # Present Value calculation -------------------
  observeEvent(input$calculate_pv, {
    req(input$pv_real_value, input$pv_future_year, input$pv_present_year)
    
    real_value <- as.numeric(input$pv_real_value)
    future_year <- as.numeric(input$pv_future_year)
    present_year <- as.numeric(input$pv_present_year)
    
    # Determine which discount factor column to use
    discount_column <- case_when(
      input$pv_discount_type == "standard" && input$pv_rate_type == "standard_stpr" ~ "df_stpr_standard",
      input$pv_discount_type == "standard" && input$pv_rate_type == "reduced_rate" ~ "df_stpr_reduced_rate_where_pure_stp_0",
      input$pv_discount_type == "health" && input$pv_rate_type == "standard_stpr" ~ "df_health",
      input$pv_discount_type == "health" && input$pv_rate_type == "reduced_rate" ~ "df_health_reduced_rate_where_pure_stp_0"
    )
    
    # Calculate years difference and get appropriate discount factor
    years_diff <- future_year - present_year
    if(years_diff < 0 || years_diff > 125) {
      output$present_value_output <- renderUI({
        HTML("<div style='text-align: center; color: red;'>Invalid year range. Please ensure the future year is between the present year and 125 years from now.</div>")
      })
    } else {
      discount_factor <- discount_factors[[discount_column]][years_diff + 1]  # +1 because R is 1-indexed
      rv_pv$present_value <- real_value * discount_factor
      rv_pv$discount_factor <- discount_factor
      rv_pv$calculated <- TRUE
      
      output$present_value_output <- renderUI({
        req(input$pv_real_value, input$pv_future_year, input$pv_present_year)
        div(style = "text-align: center; position: relative;",
            HTML(paste0("<div style='text-align: center; font-size: 18px;'>",
                        "The present value is <b style='color: #337ab7;'>£", 
                        format(round(rv_pv$present_value, 2), big.mark = ","), "</b>.</div>")),
            br(),
            HTML(paste0("<div style='font-size: 14px; color: #666; text-align: center;'>",
                        "Discount factor: ", round(rv_pv$discount_factor, 4), "<br>",
                        "Years discounted: ", years_diff, "<br>","</div>")))
      })
      
      # Show additional buttons after calculation
      shinyjs::show("pv_additional_buttons")
    }
  })
  
  # CSV PV-----------------------------------------------------------------------------------------------------------------------------
  output$pv_download_csv <- downloadHandler(
    filename = function() {
      paste("discount_rates_and_factors", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(discount_data, file, row.names = FALSE)
    }
  )
  
  # REPORT FOR PV -----------------------------------------------------------------------------------------------------------------------------
  output$pv_download_report <- downloadHandler(
    filename = function() {paste("Get Real: Present Values Report ", Sys.Date(), ".docx", sep = "")},
    content = function(file) {
      req(input$pv_real_value, input$pv_future_year, input$pv_present_year, rv_pv$present_value, rv_pv$discount_factor)
      
      # Calculate years_diff here
      years_diff <- as.numeric(input$pv_future_year) - as.numeric(input$pv_present_year)
      
      params <- list(
        pv_real_value = format(round(as.numeric(input$pv_real_value), 2), big.mark = ",", nsmall = 2),
        pv_future_year = input$pv_future_year,
        pv_present_year = input$pv_present_year,
        present_value = format(round(rv_pv$present_value, 2), big.mark = ",", nsmall = 2),
        discount_factor = round(rv_pv$discount_factor, 4),
        years_diff = years_diff,
        pv_discount_type = input$pv_discount_type,
        pv_rate_type = input$pv_rate_type,
        discount_factors_df = discount_factors)
      
      rmarkdown::render("report_present_values.Rmd", 
                        output_file = file, params = params, envir = new.env(parent = globalenv()))
    }
  )
  
  # CHATWELLBY -------------------------------------------------------------------------------------------------------------
  
  conversation_history_rv <- reactiveVal(list())
  
  # Chat for Real Values tab
  output$chat_output <- renderUI({
    div(class = "chat-container empty-chat")
  })
  
  observeEvent(input$submit, {
    shinyjs::show("loading-spinner")  # Show spinner while processing
    user_message <- input$user_input
    current_conversation_history <- conversation_history_rv()
    
    result <- tryCatch({
      openai_api_call(user_message, current_conversation_history)
    }, error = function(e) {
      print(paste("Error in openai_api_call: ", e$message))
      return(NULL)
    })
    
    if (!is.null(result)) {
      assistant_message <- result[[1]]
      updated_history <- result[[2]]
      
      conversation_history_rv(updated_history)
      
      # Clear the user input message box
      updateTextInput(session, "user_input", value = "")
      
      # Update the chat output to show the conversation
      output$chat_output <- renderUI({
        chat_contents <- lapply(updated_history, function(msg) {
          # Skip system messages
          if (msg$role != "system") {
            if (msg$role == "user") {
              div(class = "chat-message user-message",
                  div(class = "message-content", msg$content)
              )
            } else {
              div(class = "chat-message assistant-message",
                  div(class = "message-content", msg$content)
              )
            }
          }
        })
        do.call(div, c(list(class = "chat-container"), chat_contents))
      })
      
    }
    shinyjs::hide("loading-spinner")  # Hide spinner after processing
  })
  
  # Chat for Present Values tab
  output$chat_output_pv <- renderUI({
    div(class = "chat-container empty-chat")
  })
  
  observeEvent(input$submit_pv, {
    shinyjs::show("loading-spinner-pv")  # Show spinner while processing
    user_message <- input$user_input_pv
    current_conversation_history <- conversation_history_rv()
    
    result <- tryCatch({
      openai_api_call(user_message, current_conversation_history)
    }, error = function(e) {
      print(paste("Error in openai_api_call: ", e$message))
      return(NULL)
    })
    
    if (!is.null(result)) {
      assistant_message <- result[[1]]
      updated_history <- result[[2]]
      
      conversation_history_rv(updated_history)
      
      # Clear the user input message box
      updateTextInput(session, "user_input_pv", value = "")
      
      # Update the chat output to show the conversation
      output$chat_output_pv <- renderUI({
        chat_contents <- lapply(updated_history, function(msg) {
          # Skip system messages
          if (msg$role != "system") {
            if (msg$role == "user") {
              div(class = "chat-message user-message",
                  div(class = "message-content", msg$content)
              )
            } else {
              div(class = "chat-message assistant-message",
                  div(class = "message-content", msg$content)
              )
            }
          }
        })
        do.call(div, c(list(class = "chat-container"), chat_contents))
      })
      
    }
    shinyjs::hide("loading-spinner-pv")  # Hide spinner after processing
  })
  
  # END SERVER ------------------------------------------------------------------------------------------------------------------------
}
