# SERVER SET UP -------------------------------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # INITIALISE TOOLTIP -----------------------------------------------------------------------------------------------------
  shinyjs::runjs("$('.custom-tooltip').tooltip({container: 'body', placement: 'top', html: true});")
  
  # LOAD DATA (inside server) -----------------------------------------------------------------------------------------------
  deflators <- read_excel("socialvalueadjuster_deflators.xlsx", sheet = "deflators")
  
  # REACTIVE VALUE TO STORE ADJUSTED VALUE AND CALCULATION STATUS -----------------------------------------------------------
  rv <- reactiveValues(adjusted_value = NULL, calculated = FALSE, cumulative_inflation = NULL, avg_inflation = NULL)
  
  # RESET CALCULATION STATUS AND UI WHEN INPUTS CHANGE -----------------------------------------------------------------------
        observe({
          input$nominal_value
          input$price_year
          input$adjusted_year
          input$year_type
          input$value_type
          
          rv$calculated <- FALSE
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
          
          }}) #End Calculator
  

  # DATA FRAME ----------------------------------------------------------------------------------------------------------------------- 
  deflators_df <- data.frame(year = deflators$year, deflator_cy = deflators$deflator_cy, deflator_fy = deflators$deflator_fy,
                             label_fy = deflators$label_fy, gdp_per_capita = deflators$gdp_per_capita, stringsAsFactors = FALSE)
  
  # CSV -----------------------------------------------------------------------------------------------------------------------------
  output$download_csv <- downloadHandler(
    filename = function() {paste("deflators_data", Sys.Date(), ".csv", sep = "")},
    content = function(file) {write.csv(deflators_df, file, row.names = FALSE)})
  
  # REPORT -----------------------------------------------------------------------------------------------------------------------------
      output$download_report <- downloadHandler(
        filename = function() {paste("My Get Real Report", Sys.Date(), ".docx", sep = "")},
        content = function(file) {
          req(input$nominal_value, input$price_year, input$adjusted_year, rv$adjusted_value, rv$cumulative_inflation, rv$avg_inflation)
          params <- list(
            nominal_value = round(input$nominal_value, 2),
            price_year = input$price_year,
            adjusted_year = input$adjusted_year,
            adjusted_value = round(rv$adjusted_value, 2),
            cumulative_inflation = round(rv$cumulative_inflation, 2),
            avg_inflation = round(rv$avg_inflation, 2),
            year_type = input$year_type,
            value_type = input$value_type,
            deflators_df = deflators_df)
          
          rmarkdown::render("report_template_officedown.Rmd", 
                            output_file = file, params = params, envir = new.env(parent = globalenv()))})
  
  # END SERVER ------------------------------------------------------------------------------------------------------------------------
    }

