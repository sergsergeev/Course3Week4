setwd("C:/Users/SS/Desktop/Coursera/Course3/Week4")

# Script to read the trainings tables - using the naming convention for files
# to name the variables
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Script for the Testing Tables
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# features variable will contain the feature text file
features <- read.table('./UCI HAR Dataset/features.txt')

# reading activity labels into activity_labels variable
activity_labels = read.table('./UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activity_Id"
colnames(subject_train) <- "subject_Id"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_Id"
colnames(subject_test) <- "subject_Id"

colnames(activity_labels) <- c('activity_Id','activity_type')

#using cbind to merge the tables
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
allMerged <- rbind(merge_train, merge_test)

#summary of column names
col_names <- colnames(allMerged)

#usign grepl to create a vector for mean and standard deviation
mean_and_sd <- (grepl("activity_Id" , col_names) | grepl("subject_Id" , col_names) | 
                     grepl("mean.." , col_names) | grepl("std.." , col_names) 
)

summary_mean_and_sd <- allMerged[ , mean_and_sd == TRUE]

summary_activity_names <- merge(summary_mean_and_sd, activity_labels,
                              by='activity_Id', all.x=TRUE)

#creating a clean set
second_clean_set <- aggregate(. ~subject_Id + activity_Id, summary_activity_names, mean)
second_clean_set <- second_clean_set[order(second_clean_set$subject_Id, second_clean_set$activity_Id),]

#a new text file with clean set 
write.table(second_clean_set, "SecCleanSet.txt", row.name=FALSE)
