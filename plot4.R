setwd("~/datasciencecoursera/Exploratory Data Analysis")

#load the libraries required
library("dplyr")
library(lubridate)


#Pull the Data

#create a filename for us to store the file/zip
filename<-"Power_Consumption.zip"



#uses the course suggested if statment to see if you have the zip'file. Load if you don't/curl for https
if(!file.exists(filename)){
  fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL,filename, method="curl")
}

#unzips the files from the UCI Dataset folder into my Power Consumption folder
if(!file.exists("UCI Power Consumption Dataset")){
  unzip(filename)
}

#Create the Power consumption data frame
Powerdf<-read.table("household_power_consumption.txt", header = TRUE, sep = ";")
#take a look at the structure
str(Powerdf)

#convert using lubridate for dates and times
Powerdf$DTG<-paste(Powerdf$Date,Powerdf$Time)
Powerdf$Date<-dmy(Powerdf$Date)
Powerdf$Time<-hms(Powerdf$Time)
Powerdf$DTG<-dmy_hms(Powerdf$DTG)


# Subset the data frame for only FEB 01 and 02 2007
Power_subset1<-Powerdf %>% filter(Date=="2007-02-01" | Date=="2007-02-02") %>% 
  mutate(DWeek=wday(DTG,label=TRUE,abbr = TRUE))

#set the frame for the four plots
par(mfrow=c(2,2),mar=c(4,4,2,1),oma= c(0,0,2,0))

#create global active plot-top left
plot(Power_subset1$DTG,as.numeric(Power_subset1$Global_active_power), type="l",
     main="Daily Global Active Power-(February 01-02 2007)",xlab="Time",ylab = "Global Active Power (kilowatts)")

#create voltage plot-top right
plot(Power_subset1$DTG,as.numeric(Power_subset1$Voltage), type="l",
     xlab="Time",ylab = "Voltage")

#create plot3-sub metering-bottom left
plot(Power_subset1$DTG,as.numeric(Power_subset1$Sub_metering_1), type="l", col=1,
     xlab="Time",ylab = "Energy Sub Metering")
legend("topright", legend = c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"),
       #title = "Sub Metering Station",  # Title
       inset = 0,
       x.intersp = 0.5,
       y.intersp=0.5,
       text.font=2.0,
       xjust = 1,
       yjust=1,
       #box.lwd=0.5,
       bty = "n", # Removes the legend box
       lty=1,
       #text.width=.05,
       col=c(1,2,4),
       cex=0.5)
lines(Power_subset1$DTG,as.numeric(Power_subset1$Sub_metering_2), type="l",col=2)
lines(Power_subset1$DTG,as.numeric(Power_subset1$Sub_metering_3), type="l",col=4)

#create global reactive plot-bottom right
plot(Power_subset1$DTG,as.numeric(Power_subset1$Global_reactive_power), type="l",
     xlab="Time",ylab = "Global Reactive Power (kilowatts)")

#save and store plot4
dev.copy(png, file="plot4.png", width= 480, height=480)
dev.off()