######################################################################
## Coursera   : Exploratory Data Analysis
## Date       : July 2014
## Project    : 1
## Plot       : 1
## Due        : 13/JUL/2014
## Function   : Produce "plot1" as per Assignment Notes
## Due        : 13/JUL/2014
## Notes      : (1) The provided dataset "household_power_consumption.txt"
##                  is in the same directory as source code.
##                  See Pre-Requisites below.
##              (2) Only want rows for 1/2/2007 and 2/2/2007
##                  1/2/2007 - First Row 66638, Last 68077, 1440 rows
##                  2/2/2007 - First Row 68078, Last 69517, 1440 rows
##              (3) As provided, the source file is sorted by Date 
##                  (i.e. rows of interest are contiguous)
##
## Pre-Req   : (1) Source File
##                (a) Source file downloaded from
##                (b) Source file unzipped
##                (c) Source File is in same directory as source code
##
## Processing Overview   
## ===================
##  (10) Read CSV. Read first 69518 rows
##  (20) Create data.table
##  (25) Subset the data to 1/2/20087 and 2/2/2007
##  (30) Add attribute datetime
##  (40) Create plot
######################################################################

#  (10) Read csv file (HouseHold Data)
#      - Unable to read headers and skip rows at same time
#      - So read 69518 rows.  This includes other dates before and
#        after the ones of interest.
hhData <- read.csv("household_power_consumption.txt" , sep = ";" ,
             na.string="?" , as.is = TRUE, nrows = 69518 , stringsAsFactors=FALSE)

#===================================================================
# (20) Read to data.table
#===================================================================
library(data.table)
DT_AllRows <-  data.table(hhData)      # All rows

#===================================================================
# (25) Subset the data
#      - Only rows for 1/2/2007 and 2/2/2007
#===================================================================
DT_SubSet <- DT_AllRows[DT_AllRows$Date == "1/2/2007" | DT_AllRows$Date == "2/2/2007"]

#===================================================================
# (30) Add datetime attribute
#      (a) Concatenate date and time into character datetime field
#      (b) Convert datetime to posix datetime
#          NB: Use Y for year (4 digit year)
#===================================================================
DT_SubSet$datetime =  paste(DT_SubSet$Date, DT_SubSet$Time, sep = " ")
DT_SubSet$datetime <- as.POSIXct(strptime(DT_SubSet$datetime, "%d/%m/%Y %H:%M:%S"))

#===================================================================
# (40) Create the plot
#      (a)  PNG, 480*480 pixels
#      (b)  Graph is a red histogram with customised title
#           and x-axis label.
#      (c) y limit set to 1300 so that "1200" appears on chart
#===================================================================
library(datasets)
png(filename = "plot1.png", width = 480, height = 480, units = "px")
hist(DT_SubSet$Global_active_power, col = "red" , main = "Global Active Power" ,  
     xlab = "Global Active Power (kilowatts)" ,  ylim=c(0, 1300))
dev.off()
#####End of Code ######################################################################

