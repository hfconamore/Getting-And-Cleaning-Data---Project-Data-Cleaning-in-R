


########### Q0. ###########
# Download the file and unzip.

setwd("/Users/Feng/Documents/LearningR/coursera_R/GettingAndCleaningData/GettingAndCleaningData_HW_Quiz/GetCleanData_PeerGradedAssignment")

zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = zip_url, destfile = "DataFile.zip")
unzip("DataFile.zip")

# Find out the name of the unzipped file.
list.files()
# [10] "UCI HAR Dataset"  
list.files(path = "./UCI HAR Dataset", recursive = T)



########### Q1. ###########
# Merge the training and the test sets to create one data set.

# (1) Load the relevant data sets into R.
test_values <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt",
                          col.names = "activity",
                          colClasses = "factor")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                           col.names = "subject")

train_values <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt",
                           col.names = "activity",
                           colClasses = "factor")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                            col.names = "subject")

# (2) Generate the training data set and test data set.
train_set <- cbind(train_subjects, train_labels, train_values)
test_set <- cbind(test_subjects, test_labels, test_values)

# (3) Combine the 2 data sets together and add a group identifier.
combined <- rbind(train_set, test_set)
combined$group <- factor(c(rep(1, 7352), rep(0, 2947)), labels = c("test", "train"))
whole_set <- combined[ , c(1, 2, 564, 3:563)]
#' The whole data set has the 564 columns: "subject", "activity", "group", "V1", 
#' "V2", "V3"... "V*" variables are features.



########### Q2. ###########
# Extract only the measurements on the mean and SD for each measurement.

# (1) Load the feature name data into R.
features <- read.table("./UCI HAR Dataset/features.txt",  
                       col.names = c("index", "feature"),
                       colClasses = c("integer", "character"))

# (2) Find the features that contain either mean or SD info.
eligible_index <- grep(".*(mean|std)\\(\\).*", features$feature) + 3
eligible_feature_names <- grep(".*(mean|std)\\(\\).*", features$feature, value = T)
extracted_features <- whole_set[, c(1:3, eligible_index)]

names(extracted_features)[4: ncol(extracted_features)] <- eligible_feature_names
#' Now the column names of the extracted_features data set show the name of each mean 
#' or sd feature.



########### Q3. ###########
# Use descriptive activity names to name the activities in the data set.

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",
                              col.names = c("code", "activity"))

levels(extracted_features$activity)
# [1] "1" "2" "3" "4" "5" "6"

levels(extracted_features$activity) <- activity_labels$activity
levels(extracted_features$activity)
# [1] "WALKING"            "WALKING_UPSTAIRS"  
# [3] "WALKING_DOWNSTAIRS" "SITTING"           
# [5] "STANDING"           "LAYING" 




########### Q4. ###########
# Appropriately label the data set with descriptive variable names.

#' For the whole data set with all the measurements, the following command assigns
#' names to the columns.
colnames(whole_set)[4:ncol(whole_set)] <- features$feature

#' For the data set with only the mean and sd features, the variable names have been
#' labeled with the feature names in the last step of Q2.


########### Q5. ###########
#' From the data set in step 4, creates a second, independent tidy data set 
#' with the average of each variable for each activity and each subject.  
#' Upload your data set as a txt file created with write.table() using 
#' row.name=FALSE.

#' For this question, the extracted_features rather than the whole_set data set 
#' would be used.

# (1) If the result is preferred to be a wide table, then:
library(reshape2)
library(dplyr)

molten <- melt(extracted_features, id = c("activity", "subject", "group"))
molten <- arrange(molten, activity, subject)
avg_features_wide <- dcast(molten, activity + subject + group ~ variable, mean)

for (i in 4:ncol(avg_features_wide)) {
    names(avg_features_wide)[i] <- paste0("avg_", names(avg_features_wide)[i])
}

write.table(avg_features_wide, file = "avg_features_wide.txt", row.names = F)

# (2) If the result is preferred to be a long table, then:
library(tidyr)
library(plyr)

gathered <- gather(extracted_features, key = measurement, value = value, 
                   -activity, -subject, -group)
avg_features_long <- ddply(gathered, .(activity, subject, group, measurement), 
                           plyr::summarize, avg = mean(value))

for (i in 1:nrow(avg_features_long)) {
    avg_features_long$measurement[i] <- paste0("avg_", avg_features_long$measurement[i])
}

write.table(avg_features_long, file = "avg_features_long.txt", row.names = F)


