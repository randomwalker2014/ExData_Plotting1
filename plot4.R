## Code for plot # 4

require(data.table)

# read large file into a data table
colclass <- c("character","character",rep("numeric",7))
powerDT <- suppressWarnings(fread("household_power_consumption.txt",sep=";",header=TRUE,colClasses=colclass))

# get the data subset for relevant dates 
power_subsetDT <- subset(powerDT, !(powerDT$Date %in% c("?")) &
                                 as.Date(powerDT$Date,format='%d/%m/%Y') >= as.Date("2007-02-01",format='%Y-%m-%d') & 
                                 as.Date(powerDT$Date,format='%d/%m/%Y') <= as.Date("2007-02-02",format='%Y-%m-%d'))
# force all missing data to NA
power_subsetDT[power_subsetDT == "?"] = NA

# selectively convert columns to numeric data
power_subsetDT <- cbind(power_subsetDT[,1:2,with=FALSE],apply(power_subsetDT[,3:9,with=FALSE],2,as.numeric))

# Generate plots

# tidy up data before plotting
power_subsetDT <- na.omit(power_subsetDT)

# create a full datetimestamp field 
dateTimeStamp <- strptime(paste(power_subsetDT$Date,power_subsetDT$Time,sep="T"),
                          format='%d/%m/%YT%H:%M:%S')

png(file="plot4.png",width=500,height=500)

par(mfcol=c(2,2))

#plot 1
plot(dateTimeStamp,power_subsetDT$Global_active_power,type="l",xlab="",ylab="Global Active Power")

#plot2
plot(dateTimeStamp,power_subsetDT$Sub_metering_1,type="l",xlab="",ylab="Energy sub metering",col="black")
lines(dateTimeStamp,power_subsetDT$Sub_metering_2,type="l", col="red")
lines(dateTimeStamp,power_subsetDT$Sub_metering_3,type="l",col="blue")
legend("topright",lty = c(1, 1, 1),
       legend=c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"),
       col= c("black","red","blue"), cex=0.85)
#plot3
plot(dateTimeStamp,power_subsetDT$Voltage,type="l",xlab="datetime",ylab="Voltage")

#plot4
plot(dateTimeStamp,power_subsetDT$Global_reactive_power,type="l",xlab="datetime",ylab="Global Reactive Power")


dev.off()
