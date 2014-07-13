######################################################################
## Coursera   : Exploratory Data Analysis
## Date       : July 2014
## Project    : 1
## Plot       : 3
## Due        : 13/JUL/2014
## Function   : Produce "plot3" as per Assignment Notes
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
##  (40) Create the plot
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
#      (b)  Graph is a line plot
#           - X-axis is datetime (automatically displays as
#             day of week.
#           - Y-axis is Global Active Power
#           - X-Axis label is removed
#           - Y-Axis label is customised
#===================================================================
library(datasets)
png(filename = "plot3.png", width = 480, height = 480, units = "px")
with(DT_SubSet, plot(datetime, Sub_metering_1, type = "l" ,
                     xlab = "" ,
                     ylab = "Energy sub metering") )

## Extra Lines
lines (x= DT_SubSet$datetime, y= DT_SubSet$Sub_metering_2, col ="red")
lines (x= DT_SubSet$datetime, y= DT_SubSet$Sub_metering_3, col ="blue")

## Add Legend 
legend("topright" ,                   # Legend to top right of plot
       c("Sub_metering_1 ","Sub_metering_2","Sub_metering_3"), # Legend Text
       lty=c(1,1,1),                 # Legend ine type are alls solid
       bty="o",                      # Legend box type, default= "o" (On)
       lwd=c(1.0,1.0,1.0),           # Legend line width
       col=c("black", "red","blue")) # Legend line colour

dev.off()
#####End of Code ######################################################################
