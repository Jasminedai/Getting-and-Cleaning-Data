# Clean Data Project
library(reshape2)
library(reshape)
## download file from server
filename <- "getdata_dataset.zip"
## Download data from website and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


## Read activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
dim(activityLabels)
str(activityLabels)
is.character(activityLabels)

### Convert to character variable
activityLabels[,2] <- as.character(activityLabels[,2])

## Read features files
features <- read.table("UCI HAR Dataset/features.txt")
dim(features)
str(features)
is.character(features)
### Convert to character variable
features[,2] <- as.character(features[,2])
is.character(features[, 2])


# Obtain a new set of data from festures only including mean and standard deviation
featuresChoosen <- grep(".*mean.*|.*std.*", features[,2])
str(featuresChoosen)
featuresChoosen.names <- features[featuresChoosen,2]
featuresChoosen.names
featuresChoosen.names = gsub('-mean', 'Mean', featuresChoosen.names)
featuresChoosen.names = gsub('-std', 'Std', featuresChoosen.names)
featuresChoosen.names <- gsub('[-()]', '', featuresChoosen.names)
featuresChoosen.names 

# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresChoosen]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)
head(train)
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresChoosen]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)
head(test)
## merge two datasets 

train_test <- rbind(train, test)
head(train_test)
### Add labels
colnames(train_test) <- c("subject", "activity", featuresChoosen.names)
head(train_test)
# turn activities & subjects into factors
train_test$activity <- factor(train_test$activity, levels = activityLabels[,1], labels = activityLabels[,2])
train_test$subject <- as.factor(train_test$subject)
is.factor(train_test$activity)
is.factor(train_test$subject)

## Melt data together
train_test.melted <- melt(train_test, id = c("subject", "activity"))
head(train_test.melted)
train_test.mean <- dcast(train_test.melted, subject + activity ~ variable, mean)
## It is ready for further analysis
write.table(train_test.mean, "train_test_tidy.txt", row.names = FALSE, quote = FALSE)
##Check the text file
head(train_test.mean)
