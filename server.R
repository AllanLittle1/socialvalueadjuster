# LIBRARIES -------------------------------------------------------------------------------------------------------------------------
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinyBS)
library(readxl)
library(shinythemes)
library(DT)
library(dplyr)
library(httr)
library(plotly)
library(bslib)
library(bsicons)
library(shinyjqui)
library(openxlsx2)
library(httr)
library(jsonlite)
library(officer)
library(magrittr)
library(officedown)
library(rmarkdown)
library(ggplot2)

# SERVER SET UP -------------------------------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
  
  # INITIALISE TOOLTIP -----------------------------------------------------------------------------------------------------
  shinyjs::runjs("$('.custom-tooltip').tooltip({container: 'body', placement: 'top', html: true});")
  
  # LOAD DATA (inside server) -----------------------------------------------------------------------------------------------
  deflators <- read_excel("socialvalueadjuster_deflators.xlsx", sheet = "deflators")
  
  # REACTIVE VALUE TO STORE ADJUSTED VALUE ---------------------------------------------------------------------------------
  rv <- reactiveValues(adjusted_value = NULL)
  
  # CALCULATOR -----------------------------------------------------------------------------------------------
  observeEvent(input$adjust, {
    req(input$nominal_value, input$price_year, input$adjusted_year)  # Ensure inputs are available
    
    nominal_value <- as.numeric(input$nominal_value)
    price_year <- as.numeric(input$price_year)
    adjusted_year <- as.numeric(input$adjusted_year)
    
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
    
    if (is.na(nominal_value) || is.na(deflator_start) || is.na(deflator_end) || 
        (input$value_type == "wellbeing" && (is.na(gdp_per_capita_start) || is.na(gdp_per_capita_end)))) {
      output$adjusted_value <- renderUI({
        HTML("<div style='text-align: center; color: red;'>Please enter valid numeric values.</div>")
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
      
      output$adjusted_value <- renderUI({
        HTML(paste0("<div style='text-align: center; font-size: 18px;'>Your value in real terms is <b style='color: #337ab7;'>£", round(rv$adjusted_value, 2), "</b>.</div>"))
      })
      
      # Show additional buttons after calculation
      shinyjs::show("additional_buttons")
    }
  })
  
  # DATA FRAME ----------------------------------------------------------------------------------------------------------------------- 
  deflators_df <- data.frame(year = deflators$year, deflator_cy = deflators$deflator_cy, deflator_fy = deflators$deflator_fy,
                             label_fy = deflators$label_fy, gdp_per_capita = deflators$gdp_per_capita, stringsAsFactors = FALSE)
  
  # CSV -----------------------------------------------------------------------------------------------------------------------------
  output$download_csv <- downloadHandler(
    filename = function() {paste("deflators_data", Sys.Date(), ".csv", sep = "")},
    content = function(file) {write.csv(deflators_df, file, row.names = FALSE)})
  
  # WORD REPORT ----------------------------------------------------------------------------------------------------------------------
  output$download_report <- downloadHandler(
    filename = function() {paste("My Get Real Report_", Sys.Date(), ".docx", sep = "")},
    content = function(file) {
      req(input$nominal_value, input$price_year, input$adjusted_year, rv$adjusted_value)
      
      params <- list(
        nominal_value = input$nominal_value,
        price_year = input$price_year,
        adjusted_year = input$adjusted_year,
        adjusted_value = rv$adjusted_value
      )
      
      rmarkdown::render("report_template_officedown.Rmd", output_file = file, params = params, envir = new.env(parent = globalenv()))
    }
  )

  #END SERVER ----------------------------------------------------------------------------------------------------------------   
}

