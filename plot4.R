## downloading data set

urln <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("exdata_data_household_power_consumption.zip")){
    download.file(urln, destfile = "exdata_data_household_power_consumption.zip")
    
}

if(!file.exists("household_power_consumption.txt")){
    unzip(zipfile = "exdata_data_household_power_consumption.zip")
    
}

## loading the data with fastest R package
library(data.table)
df <- fread("household_power_consumption.txt", na.strings = "?")

## fixing data and time columns, which are loaded as character
library(lubridate)
df$Date <- dmy(df$Date)

## file is huge therefore subsetting data frame first
df <- subset (df, df$Date >= "2007-02-01" & df$Date <= "2007-02-02")

## now we need to combine date and time into single variable and parse it
library(dplyr)
df <- df %>% mutate(Datetime = paste(Date, " ",Time))
df$Datetime <- ymd_hms(df$Datetime)

## making plots
png(file = "plot4.png")

par(mfrow=c(2,2))

## plot 1
with(df, plot(Datetime, Global_active_power, pch = 5, cex = 0, ylab = "Global Active Power"))
with(df, lines(Datetime, Global_active_power))


## plot 2
with(df, plot(Datetime, Voltage, pch = 5, cex = 0, ylab = "Voltage"))
with(df, lines(Datetime, Voltage))

## plot 3
with(df, plot(Datetime, Sub_metering_1, pch = 5, cex = 0, ylab="Energy sub metering"))
with(df, lines(Datetime, Sub_metering_1))
with(df, lines(Datetime, Sub_metering_2, col = "red"))
with(df, lines(Datetime, Sub_metering_3, col = "blue"))
legend("topright", col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, cex = 0.75, bty = "n")

##plot 4
with(df, plot(Datetime, Global_reactive_power, pch = 5, cex = 0))
with(df, lines(Datetime, Global_reactive_power))

dev.off()
