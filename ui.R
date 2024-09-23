# CUSTOM CSS -------------------------------------------------------------------------------------------------------------------------
custom_css <- "
.custom-accordion .accordion-header {background-color: #f7f7f7; color: #333; font-size: 18px; padding: 10px; cursor: pointer; border: 1px solid #ddd; border-bottom: none;}
.custom-accordion .accordion-body {border: 1px solid #ddd; padding: 10px; font-size: 16px; background-color: #fff;}
.accordion-container {margin: 0 auto; width: 70%;}
.accordion-button {display: flex; align-items: center; padding-left: 10px;}
.accordion-button .fa {margin-right: 10px;}
.accordion-button .icon-padding {margin-right: 10px;}
.btn-unite {background-color: #5cb85c !important; color: white !important; border: none !important; padding: 10px 20px !important; font-size: 18px !important; cursor: pointer !important; display: inline-block !important; text-align: center !important; margin: 5px !important;}
.btn-unite:hover {background-color: #4cae4c !important;}
.specialist-value {font-size: 14px !important;}
.conditional-alert {position: fixed; top: 100px; left: 80%; transform: translateX(-50%); width: 300px; padding: 10px; background-color: #d9edf7; border: 1px solid #bce8f1; border-radius: 4px; color: #31708f; z-index: 9999;}
.custom-formula {font-size: 0.9em; overflow-x: auto; display: block; white-space: nowrap;}
.chat-container {padding: 10px; background-color: #f7f7f7; border-radius: 10px; min-height: 100px; display: flex; flex-direction: column; justify-content: flex-end;}
.chat-message {margin-bottom: 10px; padding: 10px; border-radius: 5px; width: 100%; display: flex; align-items: center;}
.user-message {background-color: #d9edf7; text-align: right; align-self: flex-end;}
.assistant-message {background-color: #f5f5f5; align-self: flex-start;}
.spinner {border: 4px solid rgba(0, 0, 0, 0.1); width: 36px; height: 36px; border-radius: 50%; border-left-color: #09f; animation: spin 1s linear infinite;}
@keyframes spin {to { transform: rotate(360deg); }}
.avatar {border-radius: 50%; width: 36px; height: 36px; margin-right: 10px;}
.user-avatar {float: right;}
.ai-avatar {float: left;}
.timestamp {font-size: 0.8em; color: #888; margin-top: 5px;}
.animated-background {position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: -1; overflow: hidden;}
.animated-background img {position: absolute; opacity: 0.5; width: 300px; height: auto;}
.animated-background img:nth-child(1) {top: 20%; left: -10%; animation: float-1 10s linear 1 forwards;}
.animated-background img:nth-child(2) {bottom: 10%; right: -5%; animation: float-2 10s linear 1 forwards;}
@keyframes float-1 {0% { transform: translateX(0) rotate(0deg); } 100% { transform: translateX(120%) rotate(360deg); }}
@keyframes float-2 {0% { transform: translateX(0) rotate(0deg); } 100% { transform: translateX(-120%) rotate(-360deg); }}
.home-content {background-color: rgba(255, 255, 255, 0.8); padding: 20px; border-radius: 10px; margin-top: 20px;}
.svg-bullet {list-style: none; padding-left: 0;}
.svg-bullet li {padding-left: 40px; position: relative; margin-bottom: 15px;}
.svg-bullet li::before {content: ''; width: 30px; height: 30px; position: absolute; left: 0; top: 50%; transform: translateY(-50%); background-size: contain; background-repeat: no-repeat;}
.svg-bullet li:nth-child(odd)::before {background-image: url('arrow-blue.svg');}
.svg-bullet li:nth-child(even)::before {background-image: url('arrow-green.svg');}
.gradient-text {background: linear-gradient(45deg, #07a48e, #009cd6, #8b559d); background-size: 800%; -webkit-background-clip: text; -webkit-text-fill-color: transparent; animation: animated_text 30s ease-in-out infinite; -moz-animation: animated_text 30s ease-in-out infinite; -webkit-animation: animated_text 30s ease-in-out infinite;}
@keyframes animated_text {0% { background-position: 0px 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0px 50%; }}
@-moz-keyframes animated_text {0% { background-position: 0px 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0px 50%; }}
@-webkit-keyframes animated_text {0% { background-position: 0px 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0px 50%; }}
.navbar {
  background: linear-gradient(-45deg, #07a48e, #009cd6, #8b559d, #009cd6) !important;
  background-size: 400% 400% !important;
  animation: gradient 15s ease infinite !important;
}

@keyframes gradient {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
}
"

# CUSTOM BS-THEME ---------------------------------------------------------------------------------------------------------------------
# CUSTOM BS-THEME ---------------------------------------------------------------------------------------------------------------------
my_theme <- bs_theme(bootswatch = "flatly") %>%
  bs_theme_update(
    bg = "#ffffff",
    fg = "#333333",
    primary = "#009cd6",  # Middle color of the gradient
    "navbar-bg" = "transparent",  # Set to transparent to allow gradient to show
    "navbar-fg" = "#ffffff"
  ) %>%
  bs_add_rules("
    .navbar {
      background: linear-gradient(-45deg, #07a48e, #009cd6, #8b559d, #009cd6) !important;
      background-size: 400% 400% !important;
      animation: gradient 15s ease infinite !important;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 20px;
    }
    
    @keyframes gradient {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }
    
    .navbar-brand {
      display: flex;
      align-items: center;
      font-size: 24px;
      font-weight: bold;
      color: #ffffff !important;
    }
    
    .navbar-nav {
      display: flex;
      justify-content: center;
      flex-grow: 1;
    }
    
    .navbar-nav > li > a {
      padding: 15px 20px !important;
      color: #ffffff !important;
      font-size: 18px;
    }
    
    .navbar-nav > li > a:hover,
    .navbar-nav > li > a:focus {
      background-color: rgba(255,255,255,0.2) !important;
    }
    
    .custom-info-icon {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 20px;
      height: 20px;
      border-radius: 50%;
      border: 1px solid #009cd6;
      color: white;
      background-color: #009cd6;
      margin-left: 5px;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    
    .custom-info-icon:hover {
      background-color: transparent;
      color: #009cd6;
    }
    
    .dark-mode {
      background-color: #121212;
      color: #ffffff;
    }
    
    .dark-mode .chat-container {
      background-color: #1e1e1e;
    }
  ")

# UI SET UP -------------------------------------------------------------------------------------------------------------------------
ui <- navbarPage(
  title = div(
    class = "navbar-brand",
    img(src = "main-logo-white.png", height = "100px", style = "margin-right: 15px;"),
    span("Get Real", style = "color: #ffffff;")
  ),
  id = "navbarPage",
  theme = my_theme,
  
  # HOME ------------------------------------------------------------------------------------------------------------------
  tabPanel("Home",
           fluidPage(
             theme = my_theme,
             # Animated Background for Home tab
             div(class = "animated-background",
                 tags$img(src = "icon.png", alt = "Mission Economics Icon"),
                 tags$img(src = "icon.png", alt = "Mission Economics Icon")
             ),
             tags$head(
               tags$style(HTML("
          .navbar {background: url('backgrounds-06.jpg') cover; min-height: 30px; height: auto !important; padding-bottom: 10px;}
          .navbar-nav {float: none; text-align: center; margin-top: 50px;}
          .navbar-nav > li {float: none; display: inline-block;}
          .navbar-nav > li > a {color: white !important; font-size: 24px; padding: 10px 20px;text-shadow: 2px 2px 4px rgba(0,0,0,0.5);}
          .navbar-nav > li > a:hover, .navbar-nav > li > a:focus {background-color: rgba(255,255,255,0.2) !important;}
          @media (max-width: 768px) {
            .navbar { min-height: 100px; }
            .navbar-nav { margin-top: 20px; }
            .navbar-nav > li > a { font-size: 18px; padding: 5px 10px; }
          }
          @media (max-width: 480px) {
            .navbar-nav > li { display: block; }
            .navbar-nav > li > a { font-size: 16px; padding: 5px; }
          }
        "))
             ),
        
        # Home Content --------------
        div(class = "home-content",
            div(style = "display: flex; align-items: center; justify-content: center;",
                img(src = "icon.png", style = "height: 80px; width: auto; margin-right: 30px;"),
                h1(class = "gradient-text", 
                   style = "font-weight: bold; margin-right: 0px;", 
                   "Get Real"),
                img(src = "icon.png", style = "height: 80px; width: auto; margin-left: 30px;")
            ),
            h3("Adjust your social values for inflation and time preferences. Make your impact clear!", align = "center"),
            br(),
            fluidRow(
              column(1),
              column(5, 
                     div(style = "height: 400px; overflow-y: auto; padding: 20px; border: 0px solid #ddd; border-radius: 5px; background-color: rgba(255, 255, 255, 0.7);",
                         tags$ul(class = "svg-bullet", style = "font-size: 1.5em;",
                                 tags$li("Adjust social values for inflation using GDP deflators"),
                                 tags$li("Calculate present values with Treasury-approved discount rates"),
                                 tags$li("Handle both standard and health/wellbeing values"),
                                 tags$li("Generate comprehensive reports for your adjusted values"),
                                 tags$li("Make fair comparisons of costs and benefits over time"),
                                 tags$li("Built using Treasury Green Book guidance")))),
              
              column(5, 
                     div(style = "height: 400px; display: flex; align-items: center; justify-content: center; border: 0px solid #ddd; border-radius: 5px; background-color: rgba(255, 255, 255, 0.7);",
                         tags$video(src = "get_real_intro.mp4", controls = TRUE, width = "100%", height = "auto",
                                    style = "max-height: 100%; object-fit: contain;")
                     )
              ),
              column(1)
            ),
            # Add Get Started button
            div(style = "text-align: center; margin-top: 30px;",
                actionBttn(inputId = "get_started", label = "Get Started", style = "unite", color = "primary", size = "lg")
            )
        )
           ),
  
      # Accordion -------------------------------------------------------------------------------------------------
      div(class = "accordion-container",
          tags$div(class = "accordion custom-accordion", id = "accordionExample",
                   
                   div(class = "accordion-item",
                       h2(class = "accordion-header", id = "headingOneHome",
                          tags$button(class = "accordion-button collapsed", type = "button", 
                                      `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseOneHome", 
                                      `aria-expanded` = "false", `aria-controls` = "collapseOneHome", 
                                      span(class = "icon-padding", icon("comments")), "Chat with Get Real AI Assistant")),
                       div(id = "collapseOneHome", class = "accordion-collapse collapse", 
                           `aria-labelledby` = "headingOneHome", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body",
                               div(class = "card", 
                                   div(class = "card-body",
                                       uiOutput("chat_output_home"),
                                       textInput("user_input_home", " ", placeholder = "Enter your message"),
                                       actionBttn(inputId = "submit_home", label = "Send", style = "unite", 
                                                  size = "sm", color = "primary", icon = icon("paper-plane")),
                                       br(),
                                       div(class = "spinner", id = "loading-spinner-home", style = "display: none;"),
                                       HTML("<small class='text-muted'>Please note: Get Real AI Assistant is trained specifically to support you with 
                         inflation adjustments and present value calculations. It can make mistakes. Check important info in the tooltip.</small>"),
                         bslib::tooltip(
                           tags$span(id = "ai_tooltip_home", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                           "Get Real AI Assistant is trained specifically to support you with inflation adjustments and present value calculations",
                           placement = "top", 
                           options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class")
                         )
                                   )
                               )
                           )
                       )
                   ),
                   
                   # Item 2: Why Updating Your Social Value Matters -------------
                   div(class = "accordion-item",
                       h2(class = "accordion-header", id = "headingTwo",
                          tags$button(class = "accordion-button collapsed", type = "button", 
                                      `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseTwo", 
                                      `aria-expanded` = "false", `aria-controls` = "collapseTwo", 
                                      span(class = "icon-padding", icon("question-circle")), "Why Updating Your Social Value Matters")),
                       div(id = "collapseTwo", class = "accordion-collapse collapse", 
                           `aria-labelledby` = "headingTwo", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body", 
                               HTML("<p>Proper adjustment of social values is crucial for:</p>
                               <ul>
                                 <li><strong>Fair Comparisons:</strong> It lets you accurately compare your social benefits to current investment costs when calculating your Social Return on Investment (SROI).</li>
                                 <li><strong>Avoiding Underestimation:</strong> Recent high inflation means older values might be selling your impact short. For example, a value from five years ago could be about 20% higher today!</li>
                                 <li><strong>Trustworthiness:</strong> Government bodies and funders expect to see up-to-date values. It's important to show you're doing things by the book - the <a href='https://www.gov.uk/government/publications/the-green-book-appraisal-and-evaluation-in-central-government' target='_blank'>Treasury Green Book</a>.</li>
                               </ul>")
                           )
                       )
                   ),
                   
                   # Item 3: Inflation Explained Simply -------------
                   div(class = "accordion-item", 
                       h2(class = "accordion-header", id = "headingThree",
                          tags$button(class = "accordion-button collapsed", type = "button", 
                                      `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseThree", 
                                      `aria-expanded` = "false", `aria-controls` = "collapseThree", 
                                      span(class = "icon-padding", icon("book")), "Inflation Explained Simply")),
                       div(id = "collapseThree", class = "accordion-collapse collapse", 
                           `aria-labelledby` = "headingThree", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body", 
                               HTML("<p><strong>Inflation:</strong></p>
                               <p>Imagine you could buy a sandwich for £5 last year, but now it costs £5.50. That 50p increase is inflation in action. When we talk about 'real terms,' we're adjusting for these price changes to make fair comparisons over time.</p>")
                           )
                       )
                   ),
                   
                   # Item 4: How We Update Your Value -------------
                   div(class = "accordion-item", 
                       h2(class = "accordion-header", id = "headingFour",
                          tags$button(class = "accordion-button collapsed", type = "button", 
                                      `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFour", 
                                      `aria-expanded` = "false", `aria-controls` = "collapseFour", 
                                      span(class = "icon-padding", icon("cogs")), "How We Update Your Value")),
                       div(id = "collapseFour", class = "accordion-collapse collapse", 
                           `aria-labelledby` = "headingFour", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body", 
                               HTML("<p>We use something called the GDP deflator - it's the government's preferred way to measure overall price changes in the economy. While you might have heard of the Consumer Price Index (CPI), the GDP deflator is better for estimating the real value of things we don't typically buy, like public services.</p>")
                           )
                       )
                   ),
                   
                   # Item 5: For the Technically Curious -------------
                   div(class = "accordion-item", 
                       h2(class = "accordion-header", id = "headingFive",
                          tags$button(class = "accordion-button collapsed", type = "button", 
                                      `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFive", 
                                      `aria-expanded` = "false", `aria-controls` = "collapseFive", 
                                      span(class = "icon-padding", icon("code-branch")), "For the Technically Curious")),
                       div(id = "collapseFive", class = "accordion-collapse collapse", 
                           `aria-labelledby` = "headingFive", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body", 
                               HTML("<ul>
                                <li>Our app uses forecasts from the Office for Budget Responsibility (OBR) to estimate values up to 2028.</li>
                                <li>For longer-term projections, check out the OBR Fiscal Sustainability Report.</li>
                                <li>Sometimes, specific inflation rates (e.g., for construction projects) can be used, but this needs solid justification.</li>
                                <li>We use the formula:
                                  <div class='custom-formula'>\\[ \\text{Real Value} = \\text{Nominal Value} \\times \\frac{\\text{GDP Deflator (Real Year)}}{\\text{GDP Deflator (Nominal Year)}} \\]</div>
                                </li>
                                <li>For wellbeing adjustments, the formula takes into account the changing marginal utility of income:
                                  <div class='custom-formula'>\\[ \\text{Real Value (Wellbeing)} = \\text{Nominal Value} \\times \\frac{\\text{GDP Deflator (Real Year)}}{\\text{GDP Deflator (Nominal Year)}} \\times \\left( \\frac{\\text{GDP per Capita (Real Year)}}{\\text{GDP per Capita (Nominal Year)}} \\right)^{1.3} \\]</div>
                                </li>
                                <li>The wellbeing adjustment differs because it accounts for the fact that as society's wealth increases, the additional happiness (utility) gained from an increase in income decreases. This is why we apply a power of 1.3 to the ratio of GDP per capita.</li>
                              </ul>")
                           )
                       )
                   ),
                   
                   # Item 6: Data Sources -------------
                   div(class = "accordion-item", 
                       h2(class = "accordion-header", id = "headingSix",
                          tags$button(class = "accordion-button collapsed", type = "button", 
                                      `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseSix", 
                                      `aria-expanded` = "false", `aria-controls` = "collapseSix", 
                                      span(class = "icon-padding", icon("database")), "Data Sources")),
                       div(id = "collapseSix", class = "accordion-collapse collapse", 
                           `aria-labelledby` = "headingSix", `data-bs-parent` = "#accordionExample",
                           div(class = "accordion-body", 
                               HTML("<p><strong>Data Sources:</strong></p>
                              <ul>
                                <li><a href='https://www.gov.uk/government/publications/the-green-book-appraisal-and-evaluation-in-central-government' target='_blank'>Green Book</a></li>
                                <li><a href='https://www.gov.uk/government/publications/green-book-supplementary-guidance-wellbeing' target='_blank'>H.M. Treasury (2021) Wellbeing Guidance for Appraisal</a></li>
                                <li><a href='https://www.gov.uk/government/collections/gdp-deflators-at-market-prices-and-money-gdp' target='_blank'>H.M. Treasury GDP Deflators</a></li>
                                <li><a href='https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihxw/pn2' target='_blank'>Office for National Statistics GVA per head</a></li>
                              </ul>
                              <p>Need more details? Feel free to ask! <a href='mailto:allan@missioneconomics.org'>allan@missioneconomics.org</a></p>")
                           )
                       )
                   )
          )
      )),
      



    # REAL VALUES PANEL --------------------------------------------------------------------------------------------------------------
  tabPanel("Real Values",
           fluidPage(
             useShinyjs(),  # Initialize shinyjs
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
                                                    downloadBttn(outputId = "download_csv", label = "Download Deflators", style = "unite", color = "success",  
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
div(class = "accordion-container",
    tags$div(class = "accordion custom-accordion", id = "accordionExample",
             
             # Item 1: Chat with Mission Economics AI --------------
             div(class = "accordion-item",
                 h2(class = "accordion-header", id = "headingOne",
                    tags$button(class = "accordion-button collapsed", type = "button", 
                                `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseOne", 
                                `aria-expanded` = "false", `aria-controls` = "collapseOne", 
                                span(class = "icon-padding", icon("comments")), "Chat with Mission Economics AI")),
                 div(id = "collapseOne", class = "accordion-collapse collapse", 
                     `aria-labelledby` = "headingOne", `data-bs-parent` = "#accordionExample",
                     div(class = "accordion-body",
                         div(class = "card", 
                             div(class = "card-body",
                                 uiOutput("chat_output"),
                                 textInput("user_input", " ", placeholder = "Enter your message"),
                                 actionBttn(inputId = "submit", label = "Send", style = "unite", 
                                            size = "sm", color = "primary", icon = icon("paper-plane")),
                                 br(),
                                 div(class = "spinner", id = "loading-spinner", style = "display: none;"),
                                 HTML("<small class='text-muted'>Please note: Mission Economics AI is trained specifically to support you with 
                                      inflation and discounting. It can make mistakes. Check important info in the tooltip.</small>"),
                                 bslib::tooltip(
                                   tags$span(id = "ai_tooltip", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                                   "Mission Economics is an AI model trained specifically to support you with inflation and discounting",
                                   placement = "top", 
                                   options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class")
                                 )
                             )
                         )
                     )
                 )
             ),
             
             # Item 2: Why Updating Your Social Value Matters -------------
             div(class = "accordion-item",
                 h2(class = "accordion-header", id = "headingTwo",
                    tags$button(class = "accordion-button collapsed", type = "button", 
                                `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseTwo", 
                                `aria-expanded` = "false", `aria-controls` = "collapseTwo", 
                                span(class = "icon-padding", icon("question-circle")), "Why Updating Your Social Value Matters")),
                 div(id = "collapseTwo", class = "accordion-collapse collapse", 
                     `aria-labelledby` = "headingTwo", `data-bs-parent` = "#accordionExample",
                     div(class = "accordion-body", 
                         HTML("<p>Proper adjustment of social values is crucial for:</p>
                               <ul>
                                 <li><strong>Fair Comparisons:</strong> It lets you accurately compare your social benefits to current investment costs when calculating your Social Return on Investment (SROI).</li>
                                 <li><strong>Avoiding Underestimation:</strong> Recent high inflation means older values might be selling your impact short. For example, a value from five years ago could be about 20% higher today!</li>
                                 <li><strong>Trustworthiness:</strong> Government bodies and funders expect to see up-to-date values. It's important to show you're doing things by the book - the <a href='https://www.gov.uk/government/publications/the-green-book-appraisal-and-evaluation-in-central-government' target='_blank'>Treasury Green Book</a>.</li>
                               </ul>")
                     )
                 )
             ),
             
             # Item 3: Inflation Explained Simply -------------
             div(class = "accordion-item", 
                 h2(class = "accordion-header", id = "headingThree",
                    tags$button(class = "accordion-button collapsed", type = "button", 
                                `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseThree", 
                                `aria-expanded` = "false", `aria-controls` = "collapseThree", 
                                span(class = "icon-padding", icon("book")), "Inflation Explained Simply")),
                 div(id = "collapseThree", class = "accordion-collapse collapse", 
                     `aria-labelledby` = "headingThree", `data-bs-parent` = "#accordionExample",
                     div(class = "accordion-body", 
                         HTML("<p><strong>Inflation:</strong></p>
                               <p>Imagine you could buy a sandwich for £5 last year, but now it costs £5.50. That 50p increase is inflation in action. When we talk about 'real terms,' we're adjusting for these price changes to make fair comparisons over time.</p>")
                     )
                 )
             ),
             
             # Item 4: How We Update Your Value -------------
             div(class = "accordion-item", 
                 h2(class = "accordion-header", id = "headingFour",
                    tags$button(class = "accordion-button collapsed", type = "button", 
                                `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFour", 
                                `aria-expanded` = "false", `aria-controls` = "collapseFour", 
                                span(class = "icon-padding", icon("cogs")), "How We Update Your Value")),
                 div(id = "collapseFour", class = "accordion-collapse collapse", 
                     `aria-labelledby` = "headingFour", `data-bs-parent` = "#accordionExample",
                     div(class = "accordion-body", 
                         HTML("<p>We use something called the GDP deflator - it's the government's preferred way to measure overall price changes in the economy. While you might have heard of the Consumer Price Index (CPI), the GDP deflator is better for estimating the real value of things we don't typically buy, like public services.</p>")
                     )
                 )
             ),
             
             # Item 5: For the Technically Curious -------------
             div(class = "accordion-item", 
                 h2(class = "accordion-header", id = "headingFive",
                    tags$button(class = "accordion-button collapsed", type = "button", 
                                `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFive", 
                                `aria-expanded` = "false", `aria-controls` = "collapseFive", 
                                span(class = "icon-padding", icon("code-branch")), "For the Technically Curious")),
                 div(id = "collapseFive", class = "accordion-collapse collapse", 
                     `aria-labelledby` = "headingFive", `data-bs-parent` = "#accordionExample",
                     div(class = "accordion-body", 
                         HTML("<ul>
                                <li>Our app uses forecasts from the Office for Budget Responsibility (OBR) to estimate values up to 2028.</li>
                                <li>For longer-term projections, check out the OBR Fiscal Sustainability Report.</li>
                                <li>Sometimes, specific inflation rates (e.g., for construction projects) can be used, but this needs solid justification.</li>
                                <li>We use the formula:
                                  <div class='custom-formula'>\\[ \\text{Real Value} = \\text{Nominal Value} \\times \\frac{\\text{GDP Deflator (Real Year)}}{\\text{GDP Deflator (Nominal Year)}} \\]</div>
                                </li>
                                <li>For wellbeing adjustments, the formula takes into account the changing marginal utility of income:
                                  <div class='custom-formula'>\\[ \\text{Real Value (Wellbeing)} = \\text{Nominal Value} \\times \\frac{\\text{GDP Deflator (Real Year)}}{\\text{GDP Deflator (Nominal Year)}} \\times \\left( \\frac{\\text{GDP per Capita (Real Year)}}{\\text{GDP per Capita (Nominal Year)}} \\right)^{1.3} \\]</div>
                                </li>
                                <li>The wellbeing adjustment differs because it accounts for the fact that as society's wealth increases, the additional happiness (utility) gained from an increase in income decreases. This is why we apply a power of 1.3 to the ratio of GDP per capita.</li>
                              </ul>")
                     )
                 )
             ),
             
             # Item 6: Data Sources -------------
             div(class = "accordion-item", 
                 h2(class = "accordion-header", id = "headingSix",
                    tags$button(class = "accordion-button collapsed", type = "button", 
                                `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseSix", 
                                `aria-expanded` = "false", `aria-controls` = "collapseSix", 
                                span(class = "icon-padding", icon("database")), "Data Sources")),
                 div(id = "collapseSix", class = "accordion-collapse collapse", 
                     `aria-labelledby` = "headingSix", `data-bs-parent` = "#accordionExample",
                     div(class = "accordion-body", 
                         HTML("<p><strong>Data Sources:</strong></p>
                              <ul>
                                <li><a href='https://www.gov.uk/government/publications/the-green-book-appraisal-and-evaluation-in-central-government' target='_blank'>Green Book</a></li>
                                <li><a href='https://www.gov.uk/government/publications/green-book-supplementary-guidance-wellbeing' target='_blank'>H.M. Treasury (2021) Wellbeing Guidance for Appraisal</a></li>
                                <li><a href='https://www.gov.uk/government/collections/gdp-deflators-at-market-prices-and-money-gdp' target='_blank'>H.M. Treasury GDP Deflators</a></li>
                                <li><a href='https://www.ons.gov.uk/economy/grossdomesticproductgdp/timeseries/ihxw/pn2' target='_blank'>Office for National Statistics GVA per head</a></li>
                              </ul>
                              <p>Need more details? Feel free to ask! <a href='mailto:allan@missioneconomics.org'>allan@missioneconomics.org</a></p>")
                     )
                 )
             )
    )
)

             
             
             # End Real Value Tab -------------- 
           )),
  
# PRESENT VALUES PANEL --------------------------------------------------------------------------------------------------------------
tabPanel("Present Values",
         fluidPage(
           useShinyjs(),
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
                                                   downloadBttn(outputId = "pv_download_csv", label = "Download Discount Factors", style = "unite", color = "success",  
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
           div(class = "accordion-container", 
               tags$div(class = "accordion custom-accordion", id = "accordionExamplePV",
                        
                        # Item 1: Chat with Mission Economics AI --------------
                        div(class = "accordion-item",
                            h2(class = "accordion-header", id = "headingOnePV",
                               tags$button(class = "accordion-button collapsed", type = "button", 
                                           `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseOnePV", 
                                           `aria-expanded` = "false", `aria-controls` = "collapseOnePV", 
                                           span(class = "icon-padding", icon("comments")), "Chat with Mission Economics AI")),
                            div(id = "collapseOnePV", class = "accordion-collapse collapse", 
                                `aria-labelledby` = "headingOnePV", `data-bs-parent` = "#accordionExamplePV",
                                div(class = "accordion-body",
                                    div(class = "card", 
                                        div(class = "card-body",
                                            uiOutput("chat_output_pv"),
                                            textInput("user_input_pv", " ", placeholder = "Enter your message"),
                                            actionBttn(inputId = "submit_pv", label = "Send", style = "unite", 
                                                       size = "sm", color = "primary", icon = icon("paper-plane")),
                                            br(),
                                            div(class = "spinner", id = "loading-spinner-pv", style = "display: none;"),
                                            HTML("<small class='text-muted'>Please note: Mission Economics AI is trained specifically to support you with 
                                      inflation and discounting. It can make mistakes. Check important info in the tooltip.</small>"),
                                      bslib::tooltip(
                                        tags$span(id = "ai_tooltip_pv", class = "custom-info-icon", icon("circle-info", class = "fa-light")),
                                        "Mission Economics is an AI model trained specifically to support you with inflation and discounting",
                                        placement = "top", 
                                        options = list(container = "body", html = TRUE, customClass = "custom-tooltip-class")
                                      )
                                        )
                                    )
                                )
                            )
                        ),
                        
                        # Item 2: Why discount to present value? -------------
                        div(class = "accordion-item",
                            h2(class = "accordion-header", id = "headingTwoPV",
                               tags$button(class = "accordion-button collapsed", type = "button", 
                                           `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseTwoPV", 
                                           `aria-expanded` = "false", `aria-controls` = "collapseTwoPV", 
                                           span(class = "icon-padding", icon("question-circle")), "Why discount to present value?")),
                            div(id = "collapseTwoPV", class = "accordion-collapse collapse", 
                                `aria-labelledby` = "headingTwoPV", `data-bs-parent` = "#accordionExamplePV",
                                div(class = "accordion-body", 
                                    HTML("<p>Discounting future values to present value is crucial for:</p>
                               <ul>
                                 <li><strong>Comparing projects:</strong> Enabling a fair comparison of projects with different timelines and cash flows.</li>
                                 <li><strong>Comparing costs with benefits:</strong> For example, to compare the social value of upfront costs and downstream benefits.</li>
                                 <li><strong>Credibility:</strong> Government and other funders will expect your Social Return on Investment to be in present values.</li>
                               </ul>")
                                )
                            )
                        ),
                        
                        # Item 3: Present Values Explained Simply -------------
                        div(class = "accordion-item", 
                            h2(class = "accordion-header", id = "headingThreePV",
                               tags$button(class = "accordion-button collapsed", type = "button", 
                                           `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseThreePV", 
                                           `aria-expanded` = "false", `aria-controls` = "collapseThreePV", 
                                           span(class = "icon-padding", icon("book")), "Present Values Explained Simply")),
                            div(id = "collapseThreePV", class = "accordion-collapse collapse", 
                                `aria-labelledby` = "headingThreePV", `data-bs-parent` = "#accordionExamplePV",
                                div(class = "accordion-body", 
                                    HTML("<p><strong>Present Values:</strong></p>
                               <ul>     
                                 <li>People generally prefer benefits now rather than later. If your social costs and benefits occur in the future you'll need to account for society's time preferences, to estimate your Social Return on Investment (SROI).</li> 
                                 <li>Discounting helps us determine the 'present value' of social impacts when they're given in monetary terms.</li>
                                 <li>Discounting is a completely separate concept to inflation.</li> 
                                 <li>Apply Treasury discount rates to your 'real' social value (after first removing inflation effects) to estimate the 'present value' of future social costs and benefits.</li>
                                 <li>Note that the discount rate reduces over time - that's built into our calculator. There are also different rates applied for standard vs health/wellbeing values, and based on time preferences. You might need advice from trained social value practitioners to apply these.</li>
                               </ul>")
                                )
                            )
                        ),
                        
                        # Item 4: For the Technically Curious -------------
                        div(class = "accordion-item", 
                            h2(class = "accordion-header", id = "headingFourPV",
                               tags$button(class = "accordion-button collapsed", type = "button", 
                                           `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFourPV", 
                                           `aria-expanded` = "false", `aria-controls` = "collapseFourPV", 
                                           span(class = "icon-padding", icon("cogs")), "For the Technically Curious")),
                            div(id = "collapseFourPV", class = "accordion-collapse collapse", 
                                `aria-labelledby` = "headingFourPV", `data-bs-parent` = "#accordionExamplePV",
                                div(class = "accordion-body", 
                                    HTML("<p><strong>Discounting Procedure:</strong></p>
                               <ul>
                                 <li>First, ensure all future values are in real terms (adjusted for inflation).</li>
                                 <li>Apply the appropriate discount rate based on the project type (standard or health) and time horizon.</li>
                                 <li>Use the formula:
                                   <div class='custom-formula'>\\( \\text{Present Value} = \\frac{\\text{Future Value}}{(1 + r)^t} \\)</div>
                                   where \\( r \\) is the discount rate and \\( t \\) is the number of years.
                                 </li>
                                 <li>For streams of future benefits or costs, calculate the present value for each year and sum them.</li>
                               </ul>
                               <p><strong>Discount Rates:</strong></p>
                               <ul>
                                 <li>Standard rate: 3.5% for years 0-30, 3% for years 31-75, and 2.5% for years 76-125.</li>
                                 <li>Health rate: 1.5% for years 0-30, 1.29% for years 31-75, and 1.07% for years 76-125.</li>
                                 <li>Reduced rates are available when the pure time preference rate is assumed to be 0%.</li>
                                 <li>Always refer to the latest Green Book guidance for the most up-to-date rates.</li>
                               </ul>")
                                )
                            )
                        ),
                        
                        # Item 5: Our Data Sources -------------
                        div(class = "accordion-item", 
                            h2(class = "accordion-header", id = "headingFivePV",
                               tags$button(class = "accordion-button collapsed", type = "button", 
                                           `data-bs-toggle` = "collapse", `data-bs-target` = "#collapseFivePV", 
                                           `aria-expanded` = "false", `aria-controls` = "collapseFivePV", 
                                           span(class = "icon-padding", icon("database")), "Our Data Sources")),
                            div(id = "collapseFivePV", class = "accordion-collapse collapse", 
                                `aria-labelledby` = "headingFivePV", `data-bs-parent` = "#accordionExamplePV",
                                div(class = "accordion-body", 
                                    HTML("<p><strong>Our Data Sources:</strong></p>
                              <ul>
                                <li><a href='https://www.gov.uk/government/publications/the-green-book-appraisal-and-evaluation-in-central-government' target='_blank'>Green Book</a></li>
                                <li><a href='https://www.gov.uk/government/publications/green-book-supplementary-guidance-wellbeing' target='_blank'>H.M. Treasury (2021) Wellbeing Guidance for Appraisal</a></li>
                              </ul>
                              <p>Need more details? Feel free to ask! <a href='mailto:allan@missioneconomics.org'>allan@missioneconomics.org</a></p>")
                                )
                            )
                        )
               )
           ))),
           
# FOOTER ------------------------------------------------------------------------------------------------------------------
footer = div(
  style = "width: 100%; padding: 10px 0; display: flex; justify-content: space-between; align-items: center;",
  div(style = "margin-left: 20px;", 
      tags$a(href = "https://missioneconomics.org", target = "_blank",
             img(src = "main-logo.png", style = "height: 200px; width: auto;")
      )
  ),
  div(style = "margin-right: 20px;", 
      tags$a(href = "https://missioneconomics.org", target = "_blank",
             img(src = "main-logo.png", style = "height: 200px; width: auto;")
      )
  )
)
  
  # End UI -----
)
