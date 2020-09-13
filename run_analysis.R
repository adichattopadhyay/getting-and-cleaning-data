library(data.table)
library(dplyr)

setwd("D:/R/getting-analyzing-data")


#url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#if(!file.exists("data")){
#  dir.create("data")
#}
#download.file(url, destfile = "./data/data.zip")

#unzip(zipfile="./data/data.zip", exdir="./data")

features = read.table('./data/UCI HAR Dataset//features.txt')
features = as.character(features[,2])

xTest = read.table('./data/UCI HAR Dataset/test/X_test.txt')
yTest = read.table('./data/UCI HAR Dataset/test/y_test.txt')
subTest  = read.table('./data/UCI HAR Dataset/test/subject_test.txt')
test =  data.frame(subTest, yTest, xTest)
names(test) = c(c('subject', 'activity'), features)

xTrain = read.table('./data/UCI HAR Dataset/train/X_train.txt')
yTrain = read.table('./data/UCI HAR Dataset/train/y_train.txt')
subTrain = read.table('./data/UCI HAR Dataset/train/subject_train.txt')
train =  data.frame(xTrain, yTrain, subTrain)
names(train) = c(c('subject', 'activity'), features)

#Merges the training and the test sets to create one data set.
data = rbind(train, test)

#Extracts only the measurements on the mean and standard deviation for each measurement.
meanSTD = grep('mean|std', features)
sub = data[,c(1,2,meanSTD + 2)]

#Uses descriptive activity names to name the activities in the data set
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt', header = FALSE)
activityLabels = as.character(activityLabels[,2])
sub$activity = activityLabels[sub$activity]

#Appropriately labels the data set with descriptive variable names.
newName = names(sub)
newName = gsub("[(][)]", "", newName)
newName = gsub("^t", "_TimeDomain_", newName)
newName = gsub("^f", "_FrequencyDomain_", newName)
newName = gsub("Acc", "_Accelerometer_", newName)
newName = gsub("Gyro", "_Gyroscope_", newName)
newName = gsub("Mag", "_Magnitude_", newName)
newName = gsub("-mean-", "_Mean_", newName)
newName = gsub("-std-", "_StandardDeviation_", newName)
newName <- gsub("-", "_", newName)

names(sub) = newName

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData = aggregate(sub[,3:81], by = list(activity = sub$activity, subject = sub$subject),FUN = mean)
write.table(x = tidyData, file = "tidyData.txt", row.names = FALSE)
