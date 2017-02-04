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

# create plot and save to .png
png(filename = "plot2.png")

plot(x = dt$datetime, 
     y = dt$Global_active_power, 
     type = "l",
     ylab = "Global Active Power (kilowatts)", 
     xlab = "")

dev.off()


