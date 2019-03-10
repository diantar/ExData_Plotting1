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

## making plot
png(file = "plot2.png")
with(df, plot(Datetime, Global_active_power, pch = 5, cex = 0, ylab="Global active power (kilowatts)"))
with(df, lines(Datetime, Global_active_power))
dev.off()
