library("data.table")

#Reads in data from file then subsets data for specified dates
power <- data.table::fread(file.path(getwd(), "household_power_consumption.txt")
                             , na.strings="?")

# Prevents Scientific Notation
power[, active.power := lapply(.SD, as.numeric)
        , .SDcols = c("Global_active_power")]

# Making a POSIXct date capable of being filtered and graphed by time of day
power[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter Dates for 2007-02-01 and 2007-02-02
power <- power[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

# Plots
# ------------------------------------------------------------------------------

png("plot1.png", width=480, height=480)

## Plot 1
hist(power[, active.power], main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

dev.off()
# ------------------------------------------------------------------------------

png("plot2.png", width=480, height=480)

## Plot 2
plot(x = power[, dateTime], y = power[, active.power]
     , type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()

# ------------------------------------------------------------------------------

png("plot3.png", width=480, height=480)

# Plot 3
plot(power[, dateTime], power[, Sub_metering_1], type="l", xlab=""
     , ylab="Energy sub metering")
lines(power[, dateTime], power[, Sub_metering_2],col="red")
lines(power[, dateTime], power[, Sub_metering_3],col="blue")
legend("topright", col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       ,lty=c(1,1), lwd=c(1,1))

dev.off()

# ------------------------------------------------------------------------------

png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))

# Plot 4.1
plot(power[, dateTime], power[, active.power], type="l", xlab=""
     , ylab="Global Active Power")

# Plot 4.2
plot(power[, dateTime],power[, Voltage], type="l", xlab="datetime"
     , ylab="Voltage")

# Plot 4.3
plot(power[, dateTime], power[, Sub_metering_1], type="l", xlab=""
     , ylab="Energy sub metering")
lines(power[, dateTime], power[, Sub_metering_2], col="red")
lines(power[, dateTime], power[, Sub_metering_3],col="blue")
legend("topright", col=c("black","red","blue")
       , c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  ")
       , lty=c(1,1), bty="n", cex=.5)

# Plot 4.4
plot(power[, dateTime], power[,Global_reactive_power], type="l"
     , xlab="datetime", ylab="Global_reactive_power")

dev.off()
