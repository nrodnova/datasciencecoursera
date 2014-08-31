selectedData <- read.table("household_power_consumption_2days.txt", header=TRUE, sep=";", colClasses=c("Date", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "character"), na.strings="?")
selectedData$DateTime <- strptime(selectedData$DateTime, format="%Y-%m-%d %H:%M:%S")

plot(x=selectedData$DateTime, y=selectedData$Global_active_power, type="l", ylab="Gobal Active Power (kilowatts)", xlab="")
dev.copy(png, file = "plot2.png")
dev.off()