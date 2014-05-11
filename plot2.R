## Code for plot # 2

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

# Generate plot

# tidy up data before plotting
power_subsetDT <- na.omit(power_subsetDT)

# create a full datetimestamp field 
dateTimeStamp <- strptime(paste(power_subsetDT$Date,power_subsetDT$Time,sep="T"),
                          format='%d/%m/%YT%H:%M:%S')

png(file="plot2.png",width=480,height=480)

plot(dateTimeStamp,power_subsetDT$Global_active_power,type="l",xlab="",ylab="Global Active Power")

dev.off()

