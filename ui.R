# LOAD LIBRARIES --------------
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

# Load the deflators data ---------

deflators <- read_excel("socialvalueadjuster_deflators.xlsx", sheet = "deflators_cy")

# Define UI -------

ui <- navbarPage(
  theme = bs_theme(bootswatch = "flatly"),  # Apply the darkly theme
  "Real Social Value App",
  
  tabPanel("Welcome",
           fluidPage(
             useShinyjs(),
             titlePanel("Welcome to the Real Social Value App"),
             mainPanel(
               h3("Introduction"),
               p("This tool helps you adjust your social value estimates into real prices and values 
                 - a crucial step in creating Treasury-compliant social impact analysis."),
               p("Use the 'Inflation Adjuster' tab to start adjusting values.")
             ))),
  
  tabPanel("Inflation Adjuster",
    fluidRow(
      column(6, offset = 3,
        div(class = "well",
          div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
            span(style = "padding-right: 5px;", "My social value is £"),
            numericInput("nominal_value", "", value = 10, min = 0, step = 0.01, width = '100px'),
            span(style = "padding: 0 5px;", "in"),
            numericInput("price_year", "", value = 2020, min = 2000, max = 2028, width = '100px'),
            span(style = "padding: 0 5px;", "prices.")),
          div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
            span(style = "padding-right: 5px;", "What would this be in real terms, based on"),
            numericInput("adjusted_year", "", value = 2023, min = 2000, max = 2028, width = '100px'),
            span(style = "padding-left: 5px;", "prices?")),
          br(),
          actionButton("adjust", "Show Amount"),
          h4("Value"),
          verbatimTextOutput("adjusted_value")
        ))))
  
)
