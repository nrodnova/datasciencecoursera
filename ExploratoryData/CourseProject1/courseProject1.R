data <- read.table("household_power_consumption.txt", header=TRUE, sep=";", colClasses=c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), na.strings="?")
data$Date = as.Date(data$Date, format("%d/%m/%Y"))
selectedData <- data[(data$Date == "2007-02-01") | (data$Date == "2007-02-02"),]
selectedData$DateTime <- paste(selectedData$Date, selectedData$Time, sep=" ")
selectedData$DateTime <- strptime(selectedData$DateTime, format="%Y-%m-%d %H:%M:%S")
write.table(selectedData, "household_power_consumption_2days.txt", sep=";", na="?", row.names=FALSE)

selectedData <- read.table("household_power_consumption_2days.txt", header=TRUE, sep=";", colClasses=c("Date", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "character"), na.strings="?")
selectedData$DateTime <- strptime(selectedData$DateTime, format="%Y-%m-%d %H:%M:%S")
#head(selectedData)

par(mfrow=c(1,1))
hist(selectedData$Global_active_power, xlim=c(0,6), ylim=c(0,1200), col="red", main="Global Active Power", xlab="Gobal Active Power (kilowatts)")
dev.copy(png, file = "plot1.png")
dev.off()

#head(selectedData)$Date
#weekdays(head(selectedData)$Date)
#plot(x=selectedData$Date, y=selectedData$Global_active_power)





plot(x=selectedData$DateTime, y=selectedData$Global_active_power, type="l", ylab="Gobal Active Power (kilowatts)", xlab="")
dev.copy(png, file = "plot2.png")
dev.off()

plot(x=selectedData$DateTime, y=selectedData$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
lines(selectedData$DateTime, selectedData$Sub_metering_2, col="red")
lines(selectedData$DateTime, selectedData$Sub_metering_3, col="blue")
legend("topright",  y.intersp = 0.5, cex=0.5, lwd=3, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, file = "plot3.png")
dev.off()

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


