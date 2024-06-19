# LOAD LIBRARIES --------------
library(shiny)
library(readxl)

# Define Server
server <- function(input, output, session) {
  # Load the deflators data inside the server function
  deflators <- read_excel("socialvalueadjuster_deflators.xlsx", sheet = "deflators")
  
  observeEvent(input$adjust, {
    req(input$nominal_value, input$price_year, input$adjusted_year)  # Ensure inputs are available
    
    nominal_value <- as.numeric(input$nominal_value)
    price_year <- as.numeric(input$price_year)
    adjusted_year <- as.numeric(input$adjusted_year)
    
    if (input$year_type == "fy") {
      # Financial Year
      deflator_start <- deflators$deflator_fy[deflators$year == price_year]
      deflator_end <- deflators$deflator_fy[deflators$year == adjusted_year]
    } else {
      # Calendar Year
      deflator_start <- deflators$deflator_cy[deflators$year == price_year]
      deflator_end <- deflators$deflator_cy[deflators$year == adjusted_year]
    }
    
    if (is.na(nominal_value) || is.na(deflator_start) || is.na(deflator_end)) {
      output$adjusted_value <- renderText("Please enter valid numeric values.")
    } else {
      # Adjust the nominal value using the deflators
      adjusted_value <- nominal_value * (deflator_end / deflator_start)
      
      output$adjusted_value <- renderUI({
        HTML(paste0("<div style='text-align: center; font-size: 18px;'>Your value in real terms is <b style='color: #337ab7;'>£", round(adjusted_value, 2), "</b>.</div>"))
      })
    }
  })
}
