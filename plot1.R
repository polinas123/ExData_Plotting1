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

# create histogram and save to .png
png(filename = "plot1.png")
hist(dt$Global_active_power, 
     col = "red", 
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")
dev.off()


