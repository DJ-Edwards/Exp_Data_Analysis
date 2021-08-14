setwd("~/datasciencecoursera/Exploratory Data Analysis")

#load the libraries. Lubridate is for dates
library("dplyr")
library("lubridate")


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

#create plot3-sub metering
plot(Power_subset1$DTG,as.numeric(Power_subset1$Sub_metering_1), type="l", col=1,
     xlab="Time",ylab = "Energy Sub Metering")
lines(Power_subset1$DTG,as.numeric(Power_subset1$Sub_metering_2), type="l",col=2)
lines(Power_subset1$DTG,as.numeric(Power_subset1$Sub_metering_3), type="l",col=4)
legend("topright", legend = c("Sub Metering 1","Sub Metering 2","Sub Metering 3"),
       #title = "Sub Metering Station",  # Title
       #inset = 0.25,
       text.font=2.0,
       lwd = 2,
       #bty = "n", # Removes the legend box
       lty=1,col=c(1,2,4),
       cex=0.75
)
#save and store plot3
dev.copy(png, file="plot3.png", width= 480, height=480)
dev.off()