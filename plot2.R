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

#create plot2
plot(Power_subset1$DTG,as.numeric(Power_subset1$Global_active_power), type="l",
     main="Daily Global Active Power-(February 01-02 2007)",xlab="Time",ylab = "Global Active Power (kilowatts)")

#save and store plot2
dev.copy(png, file="plot2.png", width= 480, height=480)
dev.off()