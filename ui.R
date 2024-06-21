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
library(bsicons)

# Custom CSS for Accordion Styling
custom_css <- "
.accordion .accordion-header {
  background-color: #f7f7f7;
  color: #333;
  font-size: 18px;
  padding: 10px;
  cursor: pointer;
  border: 1px solid #ddd;
  border-bottom: none;
}
.accordion .accordion-body {
  border: 1px solid #ddd;
  padding: 10px;
  font-size: 16px;
  background-color: #fff;
}
.accordion .accordion-body p {
  margin: 0;
}
.accordion-container {
  margin: 0 auto;
  width: 70%;
}
"

# UI --------------------------
ui <- navbarPage(
  theme = bs_theme(bootswatch = "flatly"),
  "Get Real",
  
  tabPanel("Get Real",
           fluidPage(
             useShinyjs(),  # Initialize shinyjs
             tags$style(HTML(custom_css)),  # Include custom CSS
             fluidRow(
               column(6, offset = 3,
                      div(class = "well",
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
                          div(style = "text-align: center;",
                              actionBttn(inputId = "adjust", label = "Calculate Real Value", style = "unite", color = "primary")
                          ),
                          br(),br(),
                          htmlOutput("adjusted_value"),
                          br(), br(),
                          div(id = "additional_buttons", style = "text-align: center; display: none;",
                              actionBttn(inputId = "interpret", label = "Interpretation", style = "unite", color = "warning"),
                              actionBttn(inputId = "download_report", label = "Download Report", style = "unite", color = "primary"),
                              actionBttn(inputId = "download_csv", label = "Download CSV", style = "unite", color = "success")
                          ),
                          br(), br(),
                          h5("Specialist Options"),
                          div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                              prettyRadioButtons(inputId = "year_type", label = " ", choices = c("Calendar years" = "cy", "Financial years" = "fy"),
                                                 inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"),
                              tags$span(
                                id = "year_type_tooltip",
                                class = "glyphicon glyphicon-info-sign",
                                title = "For Financial Year, the input year corresponds to the start of the FY. E.g., 2022 means FY 2022/23"
                              )),
                          div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                              prettyRadioButtons(inputId = "value_type", label = " ", choices = c("Standard social value" = "other", "Wellbeing-year value (WELLBYs)" = "wellbeing"),
                                                 inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"),
                              tags$span(
                                id = "value_type_tooltip",
                                class = "glyphicon glyphicon-info-sign",
                                title = "Subjective wellbeing values, measured in wellbeing-years (WELLBYs), are adjusted slightly differently (see technical guidance)."
                              ))
                      )
               )
             ),
             br(), br(),
             div(class = "accordion-container",
                 accordion(
                   accordion_panel(
                     "Why does this matter?",
                     icon = icon("info-circle"),
                     p("This section explains why adjusting social values to real terms is important.")
                   ),
                   accordion_panel(
                     "Non-technical explainer",
                     icon = icon("question-circle"),
                     p("This section provides a non-technical explanation of the calculations.")
                   ),
                   accordion_panel(
                     "Technical guidance",
                     icon = icon("cogs"),
                     p("This section provides technical guidance on the calculations and methodology.")
                   ),
                   accordion_panel(
                     "Version control",
                     icon = icon("code-branch"),
                     p("This section provides information on version control and updates.")
                   )
                 )
             )
           )
  )
)
