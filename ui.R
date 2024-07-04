# LIBRARIES --------------------------------------------------------------------
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
library(shinydashboard)
library(bs4Dash)
library(shinyalert)

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
    .specialist-value {font-size: 14px !important;}
    .conditional-alert {position: fixed;top: 100px;  /* Adjust this value to move the panel below the header bar */
      left: 80%; transform: translateX(-50%); width: 300px; padding: 10px; background-color: #d9edf7; border: 1px solid #bce8f1;
      border-radius: 4px; color: #31708f; z-index: 9999;}
    .custom-formula {font-size: 0.9em; overflow-x: auto;  /* Allow horizontal scrolling if necessary */
      display: block; white-space: nowrap;}
"

# CUSTOM BS-THEME ---------------------------------------------------------------------------------------------------------------------
my_theme <- bs_theme(bootswatch = "flatly") |> bs_add_rules("
                .custom-info-icon {
                  display: inline-flex; align-items: center; justify-content: center;
                  width: 20px; height: 20px; border-radius: 50%;
                  border: 1px solid #3498db; color: white; background-color: #3498db;
                  margin-left: 5px; cursor: pointer; transition: all 0.3s ease;}
                .custom-info-icon:hover {background-color: transparent; color: #3498db;}")

# UI SET UP -------------------------------------------------------------------------------------------------------------------------
ui <- navbarPage(
  theme = my_theme,
  "Get Real",
  
  # REAL VALUES PANEL --------------------------------------------------------------------------------------------------------------
  tabPanel("Real Values",
           fluidPage(
             useShinyjs(),  # Initialize shinyjs
             useShinyalert(), # Initialize shinyalert
             tags$head(tags$script(src = "https://polyfill.io/v3/polyfill.min.js?features=es6")),
             tags$head(tags$script(src = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js")),
             tags$style(HTML(custom_css)),  # Include custom CSS
             tags$script(HTML("$(function() {$('.draggable-card').draggable();});")), # Include jQuery UI for draggable function
             conditionalPanel(
               condition = "output.showAlert == true",
               div(class = "conditional-alert", "Does your social value occur in the future? Consider using our Present Value calculator.")
             ),
             
             # Calculator Fluid Row -------------------------------------------------------------------------------------------------
             fluidRow(column(6, offset = 3, div(class = "well",
                                                # Inputs ----------
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                                                    span(style = "padding-right: 5px;", "Our social value is £"),
                                                    numericInput("nominal_value", "", value = 10, min = 0, step = 0.01, width = '100px'),
                                                    span(style = "padding: 0 5px;", "in"),
                                                    numericInput("price_year", "", value = 2020, min = 2000, max = 2028, width = '100px'),
                                                    span(style = "padding: 0 5px;", "prices.")), br(),
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                                                    span(style = "padding-right: 5px;", "What's the real value, based on"),
                                                    numericInput("adjusted_year", "", value = 2023, min = 2000, max = 2028, width = '100px'),
                                                    span(style = "padding-left: 5px;", "prices?")), br(),
                                                div(style = "text-align: center;",
                                                    actionBttn(inputId = "adjust", label = "Calculate Real Value", style = "unite", color = "primary")), br(),br(),
                                                
                                                # Output -----------
                                                htmlOutput("adjusted_value"), br(), br(),
                                                # Additional buttons -----
                                                div(id = "additional_buttons", style = "text-align: center; display: none;",
                                                    downloadBttn(outputId = "download_report", label = "Download Report", style = "unite", color = "primary",  
                                                                 size = "sm", block = FALSE, no_outline = TRUE, icon = shiny::icon("file-download")),
                                                    downloadBttn(outputId = "download_csv", label = "Download CSV", style = "unite", color = "success",  
                                                                 size = "sm", block = FALSE, no_outline = TRUE, icon = shiny::icon("file-csv"))), br(), br(),
                                                # Specialist options --------
                                                h5("Specialist Options", class = "specialist-value"),
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 14px;",
                                                    prettyRadioButtons(inputId = "year_type", label = " ", choices = c("Calendar years" = "cy", "Financial years" = "fy"),
                                                                       inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"),
                                                    bslib::tooltip(
                                                      tags$span(id = "year_type_tooltip", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                                                      "The Treasury provides GDP deflators for both calendar years (CY) and financial years (FY), and their values differ slightly. It's important to check whether your unadjusted social values are in CY or FY. Additionally, when preparing an investment case, verify if decision makers have set a preferred base year in CY or FY.",
                                                      placement = "top", options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class"))),
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 14px;",
                                                    prettyRadioButtons(inputId = "value_type", label = " ", choices = c("Standard value" = "standard", "Wellbeing value" = "wellbeing"),
                                                                       inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"),
                                                    bslib::tooltip(
                                                      tags$span(id = "value_type_tooltip", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                                                      "Most social costs and benefits can be adjusted using the standard GDP deflator series. If you’re using wellbeing-years (WELLBYs), inflation adjustments are more complex. We need to consider that as society's wealth increases, the additional happiness gained from a bit more money decreases. See the technical guidance for details.",
                                                      placement = "top", options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class")))
                                                # End Fluid Row -------
             ))), br(), br(),
             
             # Accordion -------------------------------------------------------------------------------------------------
             # Container -------
             div(class = "accordion-container", tags$div(class = "accordion", id = "accordionExample",
                   # Item 1: Why do we need to Get Real? -------------
                                                         div(class = "accordion-item",
                                                             h2(class = "accordion-header", id = "headingOne",
                                                                tags$button(class = "accordion-button", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseOne", 
                                                                            `aria-expanded` = "true", `aria-controls` = "collapseOne", "Why do we need to Get Real?")),
                                                             div(id = "collapseOne", class = "accordion-collapse collapse show", `aria-labelledby` = "headingOne", `data-bs-parent` = "#accordionExample",
                                                                 div(class = "accordion-body", HTML("<p>Proper adjustment of social values is crucial for:</p>
                    <ul>
                      <li><strong>Accurate comparison:</strong> Compare your social benefits to investment costs in 'real terms', essential for calculating Social Return on Investment (SROI).</li>
                      <li><strong>Credibility:</strong> Maintain credibility with central and local government and other key funders.</li>
                      <li><strong>Avoiding undervaluation:</strong> Recent high inflation rates mean you could be significantly undervaluing your social impacts. For example, values from five years ago could make your SROI about 20% higher than currently claimed.</li>
                    </ul>")))),
                   # Item 2: Non-Technical? -------------
                    div(class = "accordion-item", h2(class = "accordion-header", id = "headingTwo",
                                                     tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseTwo", 
                                                                 `aria-expanded` = "false", `aria-controls` = "collapseTwo", "Non-technical explainer")),
                        div(id = "collapseTwo", class = "accordion-collapse collapse", `aria-labelledby` = "headingTwo", `data-bs-parent` = "#accordionExample",
                            div(class = "accordion-body", HTML("<p><strong>Inflation:</strong></p>
                   <ul>     
                     <li>Prices typically increase over time. The rate of this increase is called inflation.</li> 
                     <li>When we talk about changes in 'real terms,' we're accounting for inflation to make better 
                         comparisons of the actual value of goods and services over time.</li>
                     <li>The Treasury recommends using their 'GDP deflator' to adjust for inflation in social values. 
                         While you may have heard of the Consumer Price Index (CPI), the GDP deflator is the preferred measure for this purpose.</li>
                   </ul>")))),
                   # Item 3: Technical? -------------
                   # Item 3: Technical? -------------
                   div(class = "accordion-item", h2(class = "accordion-header", id = "headingThree",
                                                    tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseThree", 
                                                                `aria-expanded` = "false", `aria-controls` = "collapseThree", "Technical guidance")),
                       div(id = "collapseThree", class = "accordion-collapse collapse", `aria-labelledby` = "headingThree", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body", HTML("
          <p><strong>Inflation Adjustment:</strong></p>
          <ul>
            <li>Use 'real' base year prices for costs and benefits in social value appraisal.</li>
            <li>For short time horizons, use the GDP deflator from the latest Office for Budget Responsibility (OBR) forecasts.</li>
            <li>For longer horizons, refer to the OBR Fiscal Sustainability Report or extrapolate using the final year's growth rate.</li>
            <li>Relative price effects can be used with historical evidence and future expectations, but must be justified and agreed upon.</li>
            <li>We use the formula:
              <div class='custom-formula'>\\[ \\text{Real Value} = \\text{Nominal Value} \\times \\frac{\\text{GDP Deflator (Real Year)}}{\\text{GDP Deflator (Nominal Year)}} \\]</div>
            </li>
            <li>For wellbeing adjustments, the formula takes into account the changing marginal utility of income:
              <div class='custom-formula'>\\[ \\text{Real Value (Wellbeing)} = \\text{Nominal Value} \\times \\frac{\\text{GDP Deflator (Real Year)}}{\\text{GDP Deflator (Nominal Year)}} \\times \\left( \\frac{\\text{GDP per Capita (Real Year)}}{\\text{GDP per Capita (Nominal Year)}} \\right)^{1.3} \\]</div>
            </li>
            <li>The wellbeing adjustment differs because it accounts for the fact that as society's wealth increases, the additional happiness (utility) gained from an increase in income decreases. This is why we apply a power of 1.3 to the ratio of GDP per capita.</li>
          </ul>
        ")))),
        
                   # Item 4: Version Control -------------
                   div(class = "accordion-item", h2(class = "accordion-header", id = "headingFour",
                                                    tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFour", 
                                                                `aria-expanded` = "false", `aria-controls` = "collapseFour", "Version control")),
                       div(id = "collapseFour", class = "accordion-collapse collapse", `aria-labelledby` = "headingFour", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body", HTML(paste0("<p><strong>Get Real App Version:</strong> ", format(Sys.Date(), "%d %B %Y"), "</p>
                     <p><strong>GDP Deflators:</strong> Market prices, and money GDP. 
                       Outturn data are as at the Quarterly National Accounts from ONS - updated 28 March 2024. 
                       Forecast data are consistent with OBR EFO data as at Budget 6 March 2024.</p>
                     <p><strong>GVA per head used in WELLBY estimation:</strong> 
                       Gross domestic product (Average) per head at market prices - released 10 May 2024</p>")))))
                   # End Accordion --------------
             ))
             # End Get Real Tab ----
           )),
  
# PRESENT VALUES PANEL --------------------------------------------------------------------------------------------------------------
  tabPanel("Present Values",
           fluidPage(
             useShinyjs(),
             useShinyalert(), # Initialize shinyalert
             tags$head(tags$script(src = "https://polyfill.io/v3/polyfill.min.js?features=es6")),
             tags$head(tags$script(src = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js")),
             tags$style(HTML(custom_css)),  # Include custom CSS
        # Calculator Fluid Row ---------------------               
             fluidRow(column(6, offset = 3, div(class = "well",
             # Inputs -------------
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                                                    span(style = "padding-right: 5px;", "We estimate a real social value of £"),
                                                    numericInput("pv_real_value", "", value = 10, min = 0, step = 0.01, width = '100px'),
                                                    span(style = "padding: 0 5px;", "in the year"),
                                                    numericInput("pv_future_year", "", value = 2030, min = 2024, max = 2149, width = '100px')), br(),
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 18px;",
                                                    span(style = "padding-right: 5px;", "What is the present value, discounted to the year"),
                                                    numericInput("pv_present_year", "", value = 2024, min = 2024, max = 2149, width = '100px'),
                                                    span(style = "padding-left: 5px;", "?"),
                                                    bslib::tooltip(
                                                      tags$span(id = "pv_present_year_tooltip", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                                                      "The present year is typically the current year or the base year for your analysis. All future values will be discounted back to this year.",
                                                      placement = "top", options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class")
                                                    )), br(),
                                                div(style = "text-align: center;",
                                                    actionBttn(inputId = "calculate_pv", label = "Calculate Present Value", style = "unite", color = "success")), br(), br(),
             # Outputs -------------
                                                htmlOutput("present_value_output"), br(), br(),
                                                
             # Additional buttons ----------
                                                div(id = "pv_additional_buttons", style = "text-align: center; display: none;",
                                                    downloadBttn(outputId = "pv_download_report", label = "Download Report", style = "unite", color = "primary",  
                                                                 size = "sm", block = FALSE, no_outline = TRUE, icon = shiny::icon("file-download")),
                                                    downloadBttn(outputId = "pv_download_csv", label = "Download CSV", style = "unite", color = "success",  
                                                                 size = "sm", block = FALSE, no_outline = TRUE, icon = shiny::icon("file-csv"))), br(), br(),
                                                
             # Specialist options --------
                                                h5("Specialist Options", class = "specialist-value"),
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 14px;",
                                                    prettyRadioButtons(inputId = "pv_discount_type", label = " ", 
                                                                       choices = c("Standard" = "standard", "Health" = "health"),
                                                                       inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly")),
                                                div(style = "display: flex; align-items: center; flex-wrap: wrap; font-size: 14px;",
                                                    prettyRadioButtons(inputId = "pv_rate_type", label = " ", 
                                                                       choices = c("Standard STPR" = "standard_stpr", "Reduced Rate" = "reduced_rate"),
                                                                       inline = TRUE, icon = icon("check"), bigger = TRUE, status = "info", animation = "jelly"))
             # End Fluid Row -------
             ))), br(), br(),
             
             # Accordion -------------------------------------------------------------------------------------------------
             div(class = "accordion-container", tags$div(class = "accordion", id = "accordionExamplePV",
                # Item 1: Why discount to present value? -------------
                                                         div(class = "accordion-item",
                                                             h2(class = "accordion-header", id = "headingOnePV",
                                                                tags$button(class = "accordion-button", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseOnePV", 
                                                                            `aria-expanded` = "true", `aria-controls` = "collapseOnePV", "Why discount to present value?")),
                                                             div(id = "collapseOnePV", class = "accordion-collapse collapse show", `aria-labelledby` = "headingOnePV", `data-bs-parent` = "#accordionExamplePV",
                                                                 div(class = "accordion-body", HTML("<p>Discounting future values to present value is crucial for:</p>
                      <ul>
                        <li><strong>Comparing projects:</strong> Enabling a fair comparison of projects with different timelines and cash flows.</li>
                        <li><strong>Comparing costs with benefits:</strong> For example, to compare the social value of upfront costs and downstream benefits.</li>
                        <li><strong>Credibility:</strong> Government and other funders will expect your Social Return on Investment to be in present values.</li>
                      </ul>")))),
                # Item 2: Non-Technical Explainer -------------
                      div(class = "accordion-item", h2(class = "accordion-header", id = "headingTwo",
                                                       tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseTwo", 
                                                                   `aria-expanded` = "false", `aria-controls` = "collapseTwo", "Non-technical explainer")),
                          div(id = "collapseTwo", class = "accordion-collapse collapse", `aria-labelledby` = "headingTwo", `data-bs-parent` = "#accordionExample",
                              div(class = "accordion-body", HTML("
                  <p><strong>Present Values:</strong></p>
                   <ul>     
                     <li>People generally prefer benefits now rather than later. If your social costs and benefits occur in the future you'll
                        need to account for society's time preferences, to estimate your Social Return on Investment (SROI) </li> 
                     <li>Discounting helps us determine the 'present value' of social impacts when they're given in monetary terms.</li>
                     <li>Discounting is a completely separate concept to inflation.</li> 
                     <li>Apply Treasury discount rates to your 'real' social value (after first removing inflation effects) to estimate the 
                         'present value' of future social costs and benefits.</li>
                     <li>Note that the discoutn rate reduces over time - that's built into our calculator. There are also different rates 
                         applied for standard vs health/wellbeing values, and based on time preferences. You might need advice from trained
                         social value pracitioners to applly these.</li>
                   </ul>")))),
                # Item 3: Technical Guidance -------------
                div(class = "accordion-item", h2(class = "accordion-header", id = "headingThreePV",
                                                 tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseThreePV", 
                                                             `aria-expanded` = "false", `aria-controls` = "collapseThreePV", "Technical guidance")),
                    div(id = "collapseThreePV", class = "accordion-collapse collapse", `aria-labelledby` = "headingThreePV", `data-bs-parent` = "#accordionExamplePV",
                        div(class = "accordion-body", HTML("
          <p><strong>Discounting Procedure:</strong></p>
          <ul>
            <li>First, ensure all future values are in real terms (adjusted for inflation).</li>
            <li>Apply the appropriate discount rate based on the project type (standard or health) and time horizon.</li>
            <li>Use the formula:
              <div class='custom-formula'>\\( \\text{Present Value} = \\frac{\\text{Future Value}}{(1 + r)^t} \\)</div>
              where \\( r \\) is the discount rate and \\( t \\) is the number of years.
            </li>
            <li>For streams of benefits or costs, calculate the present value for each year and sum them.</li>
          </ul>
          <p><strong>Discount Rates:</strong></p>
          <ul>
            <li>Standard rate: 3.5% for years 0-30, 3% for years 31-75, and 2.5% for years 76-125.</li>
            <li>Health rate: 1.5% for years 0-30, 1.29% for years 31-75, and 1.07% for years 76-125.</li>
            <li>Reduced rates are available when the pure time preference rate is assumed to be 0%.</li>
            <li>Always refer to the latest Green Book guidance for the most up-to-date rates.</li>
          </ul>
        "))))
        ,
                # Item 4: Version Control -------------
                 div(class = "accordion-item", h2(class = "accordion-header", id = "headingFourPV",
                                                  tags$button(class = "accordion-button collapsed", type = "button", `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFourPV", 
                                                              `aria-expanded` = "false", `aria-controls` = "collapseFourPV", "Version control")),
                     div(id = "collapseFourPV", class = "accordion-collapse collapse", `aria-labelledby` = "headingFourPV", `data-bs-parent` = "#accordionExamplePV",
                         div(class = "accordion-body", HTML(paste0("<p><strong>Get Real App Version:</strong> ", format(Sys.Date(), "%d %B %Y"), "</p>
                 <p><strong>Discount Rates:</strong> Based on the latest HM Treasury Green Book guidance (2023 update).</p>
                 <p><strong>Calculation Method:</strong> Follows the standard present value calculation methodology as outlined in the Green Book.</p>")))))
                # End Accordion --------------
             ))
           )
  )
  
  # End UI -----
)
