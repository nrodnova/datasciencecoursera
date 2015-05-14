---
title       : "Cache=FALSE bug demo"
subtitle    : 
author      : 
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Read-And-Delete



```r
library(knitr)
knitr::opts_chunk$set(warning=FALSE, echo=FALSE, message=FALSE)
library(ggplot2)
```

--- .class #id 

## Slide 2


```r
ggplot(mtcars, aes(x=drat, y=mpg)) +
  geom_point()
```

```
## Error in eval(expr, envir, enclos): could not find function "ggplot"
```



