# read data. "data.table" package shuld be installed
require(data.table)
dt = fread("household_power_consumption.txt", 
           sep = ";", 
           header = T, 
           na.strings = "?", 
           data.table = T)

# set key to DT in order to subset 
# (do type conversions later, on a smaller subset)
setkey(dt, "Date")
dt = dt[.(c("1/2/2007","2/2/2007"))]

# Date & Time type conversions
dt$Date = as.Date(dt$Date, format = "%d/%m/%Y")
dt$Time = as.ITime(dt$Time)

# make "datetime" column in DT
dt[, datetime:=lapply(1:dt[,.N], FUN = function(i) {
        paste(dt$Date[i],dt$Time[i],sep = " ")})]
dt$datetime = as.POSIXct(as.character(dt$datetime), 
                         format = "%Y-%m-%d %H:%M:%S")

# create plots and save to .png
png(filename = "plot4.png")

par(mfcol=c(2,2))

plot(x = dt$datetime, 
     y = dt$Global_active_power, 
     type = "l",
     ylab = "Global Active Power", 
     xlab = "")

plot(x = dt$datetime, 
     y = dt$Sub_metering_1, 
     type = "l",
     ylab = "Energy sub metering", 
     xlab = "")
lines(x = dt$datetime, y = dt$Sub_metering_2, col = "red")
lines(x = dt$datetime, y = dt$Sub_metering_3, col = "blue")
legend(1170335000,40, legend = colnames(dt)[7:9], 
       lty = c(1,1), 
       lwd=c(2.5,2.5),
       col=c("black", "red", "blue"),
       bty = "n")

plot(x = dt$datetime, 
     y = dt$Voltage, 
     type = "l",
     ylab = "Voltage", 
     xlab = "datetime")

plot(x = dt$datetime, 
     y = dt$Global_reactive_power, 
     type = "l",
     ylab = "Global_reactive_power", 
     xlab = "datetime")

dev.off()

