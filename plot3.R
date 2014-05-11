## Code for plot # 1 - Histogram ##

## Code for plot # 3

require(data.table)
# read large file into a data table
powerDT <- suppressWarnings(fread("household_power_consumption.txt"))
# get the data subset for relevant dates 
power_subsetDT <- subset(powerDT, !(powerDT$Date %in% c("?")) &
                                 as.Date(powerDT$Date,format='%d/%m/%Y') >= as.Date("2007-02-01",format='%Y-%m-%d') & 
                                 as.Date(powerDT$Date,format='%d/%m/%Y') <= as.Date("2007-02-02",format='%Y-%m-%d'))
# force all missing data to NA
power_subsetDT[power_subsetDT == "?"] = NA

# selectively convert columns to numeric data
power_subsetDT <- cbind(power_subsetDT[,1:2,with=FALSE],apply(power_subsetDT[,3:9,with=FALSE],2,as.numeric))

# Generate plot
# tidy up data before plotting
power_subsetDT <- na.omit(power_subsetDT)

# create a full datetimestamp field 
dateTimeStamp <- strptime(paste(power_subsetDT$Date,power_subsetDT$Time,sep="T"),
                          format='%d/%m/%YT%H:%M:%S')

png(file="plot3.png",width=500,height=500)

# plot the first graph
plot(dateTimeStamp,power_subsetDT$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering",col="black")
# add new data point to the same graph 
points(dateTimeStamp,power_subsetDT$Sub_metering_2,type="l", col="red")
# add new data point to the same graph 
points(dateTimeStamp,power_subsetDT$Sub_metering_3,type="l",col="blue")
# add legend
legend("topright",lty = c(1, 1, 1),
       legend=c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"),
       col= c("black","red","blue"), cex=0.9)

dev.off()