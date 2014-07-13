######################################################################
## Coursera   : Exploratory Data Analysis
## Date       : July 2014
## Project    : 1
## Plot       : 4
## Due        : 13/JUL/2014
## Function   : Produce "plot4" as per Assignment Notes
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
#      (b)  There are 4 graphs in the 2*2 plot
#           - (i)    Mostly same as plot 2
#           - (ii)   Simple line graph 
#           - (iii)  Mostly same as plot 3
#           - (iv) 
#===================================================================
library(datasets)
png(filename = "plot4.png", width = 480, height = 480, units = "px")

par(mfrow = c(2,2))     # 2*2 grid of graphs

#  Graph1 
#  - Similar to plot2 with minor variations, change of ylab
with(DT_SubSet, plot(datetime, Global_active_power, type = "l" ,
                     xlab = "" ,
                     ylab = "Global Active Power" ))

# Graph 2
# - Simple line graph, mostly with defaults
with(DT_SubSet, plot(datetime, Voltage , type = "l" ))

# Graph 3 
# - Mostly the same as plot3. 
#          - Code copy/pasted from plot3.R
#          - Removed legend box
#          - Altered scaling of legend
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
       bty="n",                      # Legend box type, turn off
       cex=0.90,                     # Reduce legend font fize to 90%
       lwd=c(1.0,1.0,1.0),           # Legend line width
       col=c("black", "red","blue")) # Legend line colour

# Graph 4
# - Simple line graph, mostly with defaults
with(DT_SubSet, plot(datetime, Global_reactive_power , type = "l" ))

dev.off()
#####End of Code ######################################################################
