# LOAD LIBRARIES --------------
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(readxl)
library(shinythemes)
library(DT)
library(dplyr)
library(httr)
library(plotly)
library(bslib)
library(bsicons)

# Define UI -------
ui <- navbarPage(
  theme = bs_theme(bootswatch = "flatly"),
  "Get Real",
  
  tabPanel("Welcome",
           fluidPage(
             useShinyjs(),
             titlePanel("Welcome to Get Real."),
             mainPanel(
               h3("Introduction"),
               p("This tool helps you adjust your social values into real prices and values 
                 - a crucial step to make your estimates into Treasury-compliant, Business Case ready analysis."),
               p("Get Real: adjusts for inflation to express your values in real terms. 
                  Get Present: to apply Treasury discount rates, expressing your estimates in Present Values
                  Get Ready: to access our Social Value checklist. Self-rate your analysis, download a report.
                  Get AI: xyz")
             ))),
  
  tabPanel("Get Real: Inflation Adjuster",
           fluidPage(
             fluidRow(
               column(6, offset = 3,
                      div(class = "well",
                          div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                              prettyRadioButtons(inputId = "year_type", label = " ", choices = c("Calendar years" = "cy", "Financial years" = "fy"),
                                                 inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"),
                              tooltip(bsicons::bs_icon("info-circle"), "For Financial Year, the input year corresponds to the start of the FY. E.g., 2022 means FY 2022/23", id = "year_type_tooltip")),
                          div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                              span(style = "padding-right: 5px;", "My social value is £"),
                              numericInput("nominal_value", "", value = 10, min = 0, step = 0.01, width = '100px'),
                              span(style = "padding: 0 5px;", "in"),
                              numericInput("price_year", "", value = 2020, min = 2000, max = 2028, width = '100px'),
                              span(style = "padding: 0 5px;", "prices.")),
                          br(),
                          div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                              span(style = "padding-right: 5px;", "What would this be in real terms, based on"),
                              numericInput("adjusted_year", "", value = 2023, min = 2000, max = 2028, width = '100px'),
                              span(style = "padding-left: 5px;", "prices?")),
                          br(),
                          actionBttn(inputId = "adjust", label = "Get Real", style = "unite", color = "primary"),
                          br(),br(),
                          htmlOutput("adjusted_value")
                      )
               )
             )
           )
  )
)
