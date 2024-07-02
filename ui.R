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

# CUSTOM CSS -------------------------------------------------------------------------------------------------------------------------

      custom_css <- "
      .accordion .accordion-header {background-color: #f7f7f7; color: #333; font-size: 18px; padding: 10px; cursor: pointer;
        border: 1px solid #ddd; border-bottom: none;}
      .accordion .accordion-body {border: 1px solid #ddd; padding: 10px; font-size: 16px; background-color: #fff;}
      .accordion .accordion-body p {margin: 0;}
      .accordion-container {margin: 0 auto; width: 70%;}
      .btn-unite {background-color: #5cb85c !important; color: white !important; border: none !important;
        padding: 10px 20px !important; font-size: 18px !important;cursor: pointer !important;
        display: inline-block !important; text-align: center !important; margin: 5px !important;}
      .btn-unite:hover {background-color: #4cae4c !important;}
      "
# CUSTOM BS-THEME ---------------------------------------------------------------------------------------------------------------------
my_theme <- bs_theme(bootswatch = "flatly") |> bs_add_rules("
    .custom-info-icon {
      display: inline-flex; align-items: center; justify-content: center;
      width: 20px; height: 20px; border-radius: 50%;
      border: 1px solid #3498db; color: white; background-color: #3498db;
      margin-left: 5px; cursor: pointer; transition: all 0.3s ease;
    }
    .custom-info-icon:hover {
      background-color: transparent; color: #3498db;
    }
")

# UI SET UP -------------------------------------------------------------------------------------------------------------------------
ui <- navbarPage(
  theme = my_theme,
  "Get Real",
  
  # GET REAL TAB SET UP--------------------------------------------------------------------------------------------------------------
  tabPanel("Get Real",
           fluidPage(
             useShinyjs(),  # Initialize shinyjs
             tags$style(HTML(custom_css)),  # Include custom CSS
             tags$script(HTML("$(function() {$('.draggable-card').draggable();});")), # Include jQuery UI for draggable function
             
             # Calculator Fluid Row -------------------------------------------------------------------------------------------------
             fluidRow(column(6, offset = 3,
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
                                     actionBttn(inputId = "interpret", label = "Interpretation", style = "unite", color = "warning",
                                                size = "sm", block = FALSE, no_outline = TRUE, icon = shiny::icon("search")),
                                     
                                     downloadBttn(outputId = "download_report", label = "Download Report", style = "unite", color = "primary",  
                                                  size = "sm", block = FALSE, no_outline = TRUE, icon = shiny::icon("file-download")),
                                     
                                     downloadBttn(outputId = "download_csv", label = "Download CSV", style = "unite", color = "success",  
                                                  #Colour options - default, primary, warning, danger, success, royal.
                                                  size = "sm", block = FALSE, no_outline = TRUE, icon = shiny::icon("file-csv"))
                                 ),
                                 br(), br(),
                                 h5("Specialist Options"),
                                 div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                                     prettyRadioButtons(inputId = "year_type", label = " ", choices = c("Calendar years" = "cy", "Financial years" = "fy"),
                                                        inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"),
                                     bslib::tooltip(
                                       tags$span(id = "year_type_tooltip", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                                       "The Treasury provides GDP deflators for both calendar years (CY) and financial years (FY), and their values differ slightly. It's important to check whether your unadjusted social values are in CY or FY. Additionally, when preparing an investment case, verify if decision makers have set a preferred base year in CY or FY.",
                                       placement = "top", options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class")
                                     )
                                 ),
                                 div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                                     prettyRadioButtons(inputId = "value_type", label = " ", choices = c("Standard value" = "standard", "Wellbeing value" = "wellbeing"),
                                                        inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"),
                                     bslib::tooltip(
                                       tags$span(id = "value_type_tooltip", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                                       "Most social costs and benefits can be adjusted using the standard GDP deflator series. If you’re using wellbeing-years (WELLBYs), inflation adjustments are more complex. We need to consider that as society's wealth increases, the additional happiness gained from a bit more money decreases. See the technical guidance for details.",
                                       placement = "top", options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class")
                                     )
                                 )
                             ))),
             br(), br(),
             
             # Accordian -------------------------------------------------------------------------------------------------
             div(class = "accordion-container",
                 accordion(
                   accordion_panel("Why do we need to Get Real?", icon = icon("info-circle"),
                                   HTML("<p>Proper adjustment of social values is crucial for:</p>
                  <ul>
                    <li><strong>Accurate comparison:</strong> Compare your social benefits to investment costs in 'real terms', essential for calculating Social Return on Investment (SROI).</li>
                    <li><strong>Credibility:</strong> Maintain credibility with central and local government and other key funders.</li>
                    <li><strong>Avoiding undervaluation:</strong> Recent high inflation rates mean you could be significantly undervaluing your social impacts. For example, values from five years ago could make your SROI about 20% higher than currently claimed.</li>
                  </ul>")),
                  accordion_panel("Non-technical explainer", icon = icon("question-circle"),
                                  HTML("<p><strong>Inflation:</strong></p>
                 <ul>     
                   <li>Prices typically increase over time. The rate of this increase is called inflation.</li> 
                   <li>When we talk about changes in 'real terms,' we're accounting for inflation to make better 
                       comparisons of the actual value of goods and services over time.</li>
                   <li>The Treasury recommends using their 'GDP deflator' to adjust for inflation in social values. 
                       While you may have heard of the Consumer Price Index (CPI), the GDP deflator is the preferred measure for this purpose.</li>
                 </ul> 
              <p><strong>Present Values:</strong></p>
                 <ul>     
                   <li>People generally prefer benefits now rather than later.</li> 
                   <li>Discounting helps us determine the present worth of future money.</li>
                   <li>Discounting is separate from inflation adjustment.</li> 
                   <li>We apply Treasury discount rates (after removing inflation effects) to estimate the 
                       present value of future social costs and benefits.</li>
                 </ul>")),
              accordion_panel("Technical guidance", icon = icon("cogs"),
                              HTML("<p><strong>Inflation Adjustment:</strong></p>
                   <ul>
                     <li>Use 'real' base year prices for costs and benefits in social value appraisal.</li>
                     <li>For short time horizons, use the GDP deflator from the latest Office for Budget Responsibility (OBR) forecasts.</li>
                     <li>For longer horizons, refer to the OBR Fiscal Sustainability Report or extrapolate using the final year's growth rate.</li>
                     <li>Relative price effects can be used with historical evidence and future expectations, but must be justified and agreed upon.</li>
                   </ul>
                   
                   <p><strong>Discounting:</strong></p>
                   <ul>
                     <li>Apply the Social Time Preference Rate (STPR) of 3.5% in real terms (1.5% for health and wellbeing values).</li>
                     <li>Convert to real prices first, then apply discounting.</li>
                     <li>Never apply discounting retrospectively.</li>
                     <li>Time horizon: typically 10 years, but up to 60 years for infrastructure projects.</li>
                   </ul>")),
              accordion_panel("Version control", icon = icon("code-branch"),
                              HTML(paste0("<p><strong>Get Real App Version:</strong> ", format(Sys.Date(), "%d %B %Y"), "</p>
                 <p><strong>GDP Deflators:</strong> Market prices, and money GDP. 
                   Outturn data are as at the Quarterly National Accounts from ONS - updated 28 March 2024. 
                   Forecast data are consistent with OBR EFO data as at Budget 6 March 2024.</p>
                 <p><strong>GVA per head used in WELLBY estimation:</strong> 
                   Gross domestic product (Average) per head at market prices - released 10 May 2024</p>")))
                 )
             )
           )
  )
)
