selectedData <- read.table("household_power_consumption_2days.txt", header=TRUE, sep=";", colClasses=c("Date", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "character"), na.strings="?")
selectedData$DateTime <- strptime(selectedData$DateTime, format="%Y-%m-%d %H:%M:%S")
#head(selectedData)

par(mfrow=c(1,1))
hist(selectedData$Global_active_power, xlim=c(0,6), ylim=c(0,1200), col="red", main="Global Active Power", xlab="Gobal Active Power (kilowatts)")
dev.copy(png, file = "plot1.png")
dev.off()