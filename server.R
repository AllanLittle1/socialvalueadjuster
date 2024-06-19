library(shiny)
library(bslib)

# Load the deflators data -----------
deflators <- read_excel("socialvalueadjuster_deflators.xlsx", sheet = "deflators_cy")

# Define Server
server <- function(input, output, session) {
  observeEvent(input$adjust, {
    req(input$nominal_value, input$price_year, input$adjusted_year)  # Ensure inputs are available
    
    # Ensure inputs are numeric
    nominal_value <- as.numeric(input$nominal_value)
    price_year <- as.numeric(input$price_year)
    adjusted_year <- as.numeric(input$adjusted_year)
    
    if (is.na(nominal_value) || is.na(price_year) || is.na(adjusted_year)) {
      output$adjusted_value <- renderText("Please enter valid numeric values.")
    } else {
      # Find the deflators for the specified years
      deflator_start <- deflators$deflator_cy[deflators$year == price_year]
      deflator_end <- deflators$deflator_cy[deflators$year == adjusted_year]
      
      # Check if deflators are available
      if (length(deflator_start) == 0 || length(deflator_end) == 0) {
        output$adjusted_value <- renderText("Deflators for the selected years are not available.")
      } else {
        # Adjust the nominal value using the deflators
        adjusted_value <- nominal_value * (deflator_end / deflator_start)
        
        output$adjusted_value <- renderText({
          paste("£", round(adjusted_value, 2))
        })
      }
    }
  })
}

