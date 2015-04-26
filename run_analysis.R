##load library
library(dplyr)

##download file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip")
##unzip file
unzip("data.zip")

##load training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

##load test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

##load feature names
features <- read.table("UCI HAR DATASET/features.txt")

##load activity labels
activity_labels <- read.table("UCI HAR DATASET/activity_labels.txt")

##task 1
##combine data sets
x_all <- rbind(x_test, x_train)

##task 4 (task order is stupid)
##rename variables properly
names(x_all) <- features$V2
##delete duplicate variables
x_all <- x_all[,!duplicated(names(x_train))]

##task 2
##extract only mean and std
x_all <- select(x_all, contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE))

##task 3
##descriptive activity names
y_all <- rbind(y_test, y_train)
y_all <- merge(y_all, activity_labels, x.by = V1, y.by = V1)

##merge subjects from train and test
subject_all <- rbind(subject_test, subject_train)

##add variables to dataset
x_all$activity <- y_all$V2
x_all$userID <- subject_all$V1

##print result
head(x_all)
##create output
write.table(x_all, file = "merged_data.txt", row.names = FALSE)

##task 5
##group by userID and then activity
x_all_temp <- group_by(x_all, userID, activity)
##calculate means of subgroups
summary_table <- summarise_each(x_all_temp, funs(mean))

##print results
head(summary_table)

write.table(summary_table, file = "summary_table.txt", row.names = FALSE)
