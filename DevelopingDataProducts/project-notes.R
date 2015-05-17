data(mtcars)
library(ggplot2)

cars <- mtcars[!(rownames(mtcars) %in% c("Mazda RX4 Wag", "Toyota Corona")),]
cars$model <- rownames(cars)
rownames(cars) <- NULL

ggplot(cars, aes(x=model, y=mpg)) +
  geom_point() +
  geom_text(aes(label=model), vjust=-0.4) 

  

variables <- c('cyl', 'wt', 'disp')

formulaText <- paste('mpg ~ ', paste(variables, sep="", collapse= " + "), sep="", collapse=NULL)

summary(lm(formula, cars))


# Deploying
devtools::install_github('rstudio/shinyapps')
library(shinyapps)
shinyapps::setAccountInfo(name='natalia-r', token='0D65B96211E941A04C533CEE60E3ED63', secret='Sq0A9k5+/W0Yt9W6q58INk+3LmCpyaDCJ/zvMd0Z')
setwd("~/Projects/DataScienceCourse/DevelopingDataProducts/CourseProjectApp")
deployApp()


# https://natalia-r.shinyapps.io/CourseProjectApp/