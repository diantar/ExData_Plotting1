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

## proposed strptime is terribly slow, therefore we need to subset data frame first
df <- subset (df, df$Date >= "2007-02-01" & df$Date <= "2007-02-02")

## and finally I decided to use lubridate parsing
df$Time <- parse_date_time(df$Time, orders = "HMS")

## making histogram
png(file = "plot1.png")
hist(df$Global_active_power, col = "red", xlab = "Global active power (kilowatts)", main = "Global Active Power")
dev.off()
