data <- read.table("household_power_consumption.txt", header=TRUE, sep=";", colClasses=c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), na.strings="?")
data$Date = as.Date(data$Date, format("%d/%m/%Y"))
selectedData <- data[(data$Date == "2007-02-01") | (data$Date == "2007-02-02"),]
selectedData$DateTime <- paste(selectedData$Date, selectedData$Time, sep=" ")
selectedData$DateTime <- strptime(selectedData$DateTime, format="%Y-%m-%d %H:%M:%S")
write.table(selectedData, "household_power_consumption_2days.txt", sep=";", na="?", row.names=FALSE)
