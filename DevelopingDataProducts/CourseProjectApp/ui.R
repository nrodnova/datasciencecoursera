library(shiny)
library(ggplot2)


variables <- c("Number of cylinders" = "cyl",
  "Displacement (cu.in.)" = "disp",
  "Gross horsepower" = "hp",
  "Rear axle ratio" = "drat",
  "Weight (lb/1000)" = "wt",
  "1/4 mile time" = "qsec",
  "V/S" = "vs",
  "Transmission" = "am",
  "Number of forward gears" = "gear",
  "Number of carburetors" = "carb"
)

shinyUI(pageWithSidebar(
  headerPanel("Buiding regression model for MPG on MTCARS data set"),
  sidebarPanel(
    h4("Variables"),
    div(style="border:1px solid lightgray;padding-left:10px;margin-bottom:10px;",
      checkboxGroupInput("variables", "Select variables to include in regression model:",
                       variables, variables)),
    actionButton("selectAllButton", "Select All"),
    actionButton("resetButton", "Reset"),
    actionButton("unselectWorstButton", "Unselect Worst"),
    div( h4("Instructions"), style="border:1px solid lightgray;margin-top:10px;margin-left:10px;",
      p("This Shiny application builds regression to model miles-per-gallon (MPG) using data in mtcars set.", style="margin-left:10px;"),
      p("Select variables above to be included in the model", style="margin-left:10px;"),
      p("Tabs on the right show the following information:", style="margin-left:10px;"),
         tags$ul(
           tags$li("Regression page shows regression coefficients and regression quality"),
           tags$li("Plot MPG page plots miles-per-gallon variable against each of the selected variables"),
           tags$li("Residual diagnostics page plots residuals"),
           tags$li("Data Description page shows some basic information about the data set")
        )
      )
  ),
  mainPanel(
    h4(textOutput("formulaText")),
    navbarPage("", 
      
      tabPanel("Regression",
         p("This page allows to see how well linear regression models MPG using variables selected on the left"),
         p("One of the ways to select linear regression variables is to start with all variables (use 'Select all' button on the left). Then eliminate variables with the highest p-value one by one while standard error is decreasing and adjusted r-square increasing. Stop when standard error starts increasing and r-square decreases. 'Unselect Worst' button removes a variable with the highest p-value and re-runs regression."),
         h4('Fit Quality '),
         tableOutput("fitQuality"),
         h4(textOutput("max.p.value")),
         h4('Model Coefficients'),
         tableOutput("coefficients")
      ),
      tabPanel("Plot MPG",
               p("The plot below shows how each variable (selected on the left) affects MPG value"),
               p("If the plot doesn't show up, please click on other tabs - there seems to be a glitch on shinyapps.io - it runs fine locally."),
               plotOutput("mpgPlot")
      ),
      tabPanel("Residual Diagnostics",
         plotOutput("diagnosticsPlot")
      ),
      tabPanel("Data Description",
        includeHTML("./help.html")
      )
    )
  )
))

# shinyUI(pageWithSidebar(
#   headerPanel("Choosing variables to model MPG using mtcars data"),
#   sidebarPanel(
#     checkboxGroupInput("variables", "Select variables:",
#                        variables, variables),
#           actionButton("selectAllButton", "Select All"),
#           actionButton("resetButton", "Reset"),
#           actionButton("unselectWorstButton", "Unselect Worst"),
#     #hr(),
#     #h4('Fit Quality ', style = "margin-top:2em;padding-top:2em;"),
#     h4('Fit Quality '),
#     tableOutput("fitQuality"),
#     h4(textOutput("max.p.value")),
#     h4('Model Coefficients'),
#     tableOutput("coefficients")
#   ),
#   mainPanel(
#     h3(textOutput("formulaText")),
#     plotOutput("mpgPlot"),
#     plotOutput("diagnosticsPlot")
#   )
# ))

# shinyUI(pageWithSidebar(
#   headerPanel("Example plot"),
#   sidebarPanel(
#     sliderInput('mu', 'Guess at the mu',value = 70, min = 60, max = 80, step = 0.05,)
#   ),
#   mainPanel(
#     plotOutput('newHist')
#   )
# ))


# library(shiny)
# shinyUI(pageWithSidebar(
#   headerPanel("Example plot"),
#   sidebarPanel(
#     sliderInput('mu', 'Guess at the mean',value = 70, min = 62, max = 74, step = 0.05,)
#   ),
#   mainPanel(
#     plotOutput('newHist')
#   )
# ))