selectedData <- read.table("household_power_consumption_2days.txt", header=TRUE, sep=";", colClasses=c("Date", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "character"), na.strings="?")
selectedData$DateTime <- strptime(selectedData$DateTime, format="%Y-%m-%d %H:%M:%S")

par(mfrow=c(2,2))
plot(x=selectedData$DateTime, y=selectedData$Global_active_power, type="l", ylab="Gobal Active Power", xlab="")
plot(x=selectedData$DateTime, y=selectedData$Voltage, type="l", ylab="Voltage", xlab="datetime")
plot(x=selectedData$DateTime, y=selectedData$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(selectedData$DateTime, selectedData$Sub_metering_2, col="red")
lines(selectedData$DateTime, selectedData$Sub_metering_3, col="blue")
legend("topright",  y.intersp = 0.5, cex=0.5, lwd=3, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(x=selectedData$DateTime, y=selectedData$Global_reactive_power, type="l", ylab="Global_reactive_power", xlab="datetime")
dev.copy(png, file = "plot4.png")
dev.off()
