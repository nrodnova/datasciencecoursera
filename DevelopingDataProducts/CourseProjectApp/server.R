library(shiny)
#library(HistData)
#data(Galton)
#galton <- Galton

library(stats)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(xtable)

cars <- mtcars[!(rownames(mtcars) %in% c("Mazda RX4 Wag", "Toyota Corona")),]
cars$model <- rownames(cars)
rownames(cars) <- NULL
counter <- 0

variable.names <- c("Number of cylinders" = "cyl",
                    "Displacement (cu.in.)" = "disp",
                    "Gross horsepower" = "hp",
                    "Rear axle ratio" = "drat",
                    "Weight (lb/1000)" = "wt",
                    "1/4 mile time" = "qsec",
                    "V/S" = "vs",
                    "Transmission" = "am",
                    "Number of forward gears" = "gear",
                    "Number of carburetors" = "carb",
                    "Intercept" = "(Intercept)")

shinyServer(
  function(input, output, session) {
   myReactiveValues <- reactiveValues(variables = c('am'), formulaText = 'mpg ~ am', fitQuality=data.frame(Model = c("Current", "Previous", "Best"), Std.Error = c(0, 0, 0), Adj.R.Sq = c(0, 0, 0), Formula=c("", "", "")), coefficients = data.frame(Var = c('', 'am'), Value = c(NA, NA), P.Value = c(NA, NA)), max.p.value.name = 'am', max.p.value = 0, max.p.value.variable = "am")

   observe({
      variables <- input$variables
      if (length(variables) == 0) {
        variables <- c('am')
        myReactiveValues$variables <- variables
        updateSelectInput(session, "variables", selected = variables)
      }
      myReactiveValues$variables <- variables
    })
    
    observe({
      formulaText <- paste('mpg ~ ', paste(myReactiveValues$variables, sep="", collapse= " + "), sep="", collapse=NULL)
      myReactiveValues$formulaText <- formulaText
    })
   
   observeEvent(input$selectAllButton, {
     if (input$selectAllButton > 0) {
       variables <- colnames(cars)
       variables <- variables[variables != "model"]
       #myReactiveValues$variables <- variables
       updateSelectInput(session, "variables", selected = variables)
     }
   })
   
   observeEvent(input$resetButton, {
     if (input$resetButton >0) {
       
       fit.quality <- isolate(myReactiveValues$fitQuality)
       fit.quality$Std.Error <- 0
       fit.quality$Adj.R.Sq <- 0
       fit.quality$Formula <- ""
       myReactiveValues$fitQuality <- fit.quality
       
       variables <- c("am")
       updateSelectInput(session, "variables", selected = variables)
     }
   })
   
   observeEvent(input$unselectWorstButton, {
     if (input$unselectWorstButton > 0) {
       selected <- input$variables
       if (length(selected) > 1)
       {
        variable <- myReactiveValues$max.p.value.variable
        selected <- input$variables
        selected <- unname(selected[selected != variable])
        updateSelectInput(session, "variables", selected = selected)
       }
     }
   })
    
    output$formulaText <- reactive({
      paste("Formula:", myReactiveValues$formulaText)
    })
   
   output$max.p.value <- reactive({
     #round(myReactiveValues$max.p.value, 5)
     sprintf("Worst P-Value: %0.5f (%s)", myReactiveValues$max.p.value, myReactiveValues$max.p.value.name)
   })
    
   observe({
     fit.current <- myReactiveValues$fit.current
     if (is.null(fit.current))
       return()
     std.error <- summary(fit.current)$sigma
     adj.r.squared <- summary(fit.current)$adj.r.squared
     fit.quality <- isolate(myReactiveValues$fitQuality)
     formulaText <- isolate(myReactiveValues$formulaText)
     
     fit.quality$Formula <- as.character(fit.quality$Formula)
     fit.quality$Std.Error[fit.quality$Model == "Previous"] <- fit.quality$Std.Error[fit.quality$Model == "Current"]
     fit.quality$Adj.R.Sq[fit.quality$Model == "Previous"] <- fit.quality$Adj.R.Sq[fit.quality$Model == "Current"]
     fit.quality$Formula[fit.quality$Model == "Previous"] <- fit.quality$Formula[fit.quality$Model == "Current"]
     
     
     if (fit.quality$Std.Error[fit.quality$Model == "Best"] == 0 | fit.quality$Std.Error[fit.quality$Model == "Best"] > std.error)
     {
       fit.quality$Std.Error[fit.quality$Model == "Best"] <- std.error
       fit.quality$Adj.R.Sq[fit.quality$Model == "Best"] <- adj.r.squared
       fit.quality$Formula[fit.quality$Model == "Best"] <- formulaText
       myReactiveValues$fitQuality <- fit.quality
     }
     
     fit.quality$Std.Error[fit.quality$Model == "Current"] <- std.error
     fit.quality$Adj.R.Sq[fit.quality$Model == "Current"] <- adj.r.squared
     fit.quality$Formula[fit.quality$Model == "Current"] <- formulaText
     myReactiveValues$fitQuality <- fit.quality
     
     
     variables <- rownames(summary(fit.current)$coeff)
     names <- names(variable.names)[match(variables, variable.names)]
     coefficients <- data.frame(Var = names, Value = summary(fit.current)$coeff[,1], P.Value = summary(fit.current)$coeff[,4])
     
              
     max.p.value <- max(coefficients$P.Value[2:nrow(coefficients)])
     myReactiveValues$max.p.value <- max.p.value
     myReactiveValues$max.p.value.name <- coefficients$Var [coefficients$P.Value == max.p.value]
     myReactiveValues$max.p.value.variable <- variables[coefficients$P.Value == max.p.value]
       
     coefficients <- coefficients[c(1, order(-coefficients$P.Value[2:nrow(coefficients)])+1),]
       
     rownames(coefficients) <- NULL
     myReactiveValues$coefficients <- coefficients
   })
   
   
   
    output$mpgPlot <- renderPlot({
      if (length(input$variables) > 0)
      {
        m <- melt(cars, id.vars=c('mpg'), measure.vars=myReactiveValues$variables)
        p <- ggplot(m, aes(x=value, y=mpg, group=variable)) + facet_wrap(~variable,ncol=2, scales="free_x") + geom_point() + geom_smooth(method="lm")
        print(p)
      }
      
    })

    observe({
      formulaText <- myReactiveValues$formulaText
      fit <- lm(formulaText, data=cars)
      myReactiveValues$fit.current <- fit
    })
    
    
    output$diagnosticsPlot <- renderPlot({
      
      fit <- myReactiveValues$fit.current
      
      r <- unname(resid(fit))
      x <- 1:length(r)
      df.residuals <- data.frame(x=x, y=r)
      df.residuals$positive <- df.residuals$y > 0
      
      # fill=positive
      
      
      
      p1 <- ggplot(df.residuals, aes(x=x, y=y)) + 
        geom_bar(stat="identity", position="identity") +
        guides(fill=F) +
        ggtitle("Model Residuals") +
        theme(plot.title=element_text(size=rel(1.1),vjust=1)) +
        xlab("Observation") +
        ylab("Residuals") +
        scale_y_continuous(limits = c(-10, 10))
      
      
       x1 <- qnorm(ppoints(r))
       probs <- c(0.25, 0.75)
       y.q <- quantile(r, probs)
       x.q <- qnorm(probs)
       slope <- unname(diff(y.q)/diff(x.q))
      int <- unname(y.q[1L] - slope * x.q[1L])
     
      df.qqplot <- data.frame(x=x1, y=sort(r))
      
      p2 <- ggplot(df.qqplot, aes(x=x,y=y)) + 
         geom_point(size=3) +
         geom_abline(intercept = int, slope=slope, size=1, colour="darkred") +
         xlab("Theoretical quantiles") +
         ylab("Sample Quantiles") +
         ggtitle("Normal Q-Q Plot") 
        scale_y_continuous(limits = c(-10, 10))
       
      grid.arrange(p1, p2, ncol=2, main="Residuals Diagnostics")      
      
    })

   
   output$fitQuality <- renderTable({
     x.table <- xtable(myReactiveValues$fitQuality, display=c('s', 's', 'f', 'f', 's'))
     colnames(x.table) <- c("Model", "Standard Error", "Adj. R-Squared", "Formula")
     x.table
     }, digits=c(0, 0, 2, 5, 0), include.rownames=FALSE)

    output$coefficients <- renderTable({
      x.table <- xtable(myReactiveValues$coefficients, display=c('s', 's', 'f', 'f'))
      colnames(x.table) <- c("Name", "Value", "P-Value")
      x.table
    }, digits=c(0, 0, 2, 6), include.rownames=FALSE)
  #})
   
   
#     observe({
#       variables <- input$variables
#       if (length(variables) == 0) {
#         updateSelectInput(session, "variables", selected = "am")
#       }
#     })
})


# library(shiny)
# library(HistData)
# data(Galton)
# galton <- Galton
# shinyServer(
#   function(input, output) {
#     output$newHist <- renderPlot({
#       hist(galton$child, xlab='child height', col='lightblue',main='Histogram')
#       mu <- input$mu
#       lines(c(mu, mu), c(0, 200),col="red",lwd=5)
#       mse <- mean((galton$child - mu)^2)
#       text(63, 150, paste("mu = ", mu))
#       text(63, 140, paste("MSE = ", round(mse, 2)))
#     })
#   }
# )

# library(UsingR)
# data(galton)
# 
# shinyServer(
#   function(input, output) {
#     output$newHist <- renderPlot({
#       hist(galton$child, xlab='child height', col='lightblue',main='Histogram')
#       mu <- input$mu
#       lines(c(mu, mu), c(0, 200),col="red",lwd=5)
#       mse <- mean((galton$child - mu)^2)
#       text(63, 150, paste("mu = ", mu))
#       text(63, 140, paste("MSE = ", round(mse, 2)))
#     })
#     
#   }
# )



