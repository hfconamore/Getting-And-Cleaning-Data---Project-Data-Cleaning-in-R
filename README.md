# Getting and Cleaning Data — Project


The run_analysis.R file contains 6 parts.

In Q0, the zip file is downloaded and unzipped to the local working directory. 

Q1. Merge the training and the test sets to create one data set
It starts with loading the 6 relevant data sets into R, including subject_test.txt, X_test.txt, y_test.txt, subject_train.txt, X_train.txt, and y_train.txt.
The 3 training data sets are combined together to create a 7352 * 563 train_set while the 3 test data sets to a 2947 * 563 test_set. So now both data sets have the same variables, namely subject, activity, and V1~V561, in which V1~V561 are the features calculated in this experiment.
The test_set is then appended to the train_set to create the 10299 * 564 whole_set with all the data. A group identifier is added in order to differentiate between subjects from the training group and from the test group.

Q2. Extract only the measurements on the mean and standard deviation for each measurement
The features.txt is loaded into R so that the names of the 561 features can be displayed. Regular expression is used to find out feature names that have the key word “mean()” or “std()”. (Note that meanFreq is a totally different stat from mean and therefore it's not included in the list of measurements to be extracted.)
There are 66 eligible feature variables to be extracted from the whole_set. Please see the resulting data set extracted_features (10299 * 69) for reference. The assigned descriptive column names for the measurements are all straight from the file features.txt. 

Q3. Use descriptive activity names to name the activities in the data set
activity names are given in the file activity_labels.txt. Load it into R and use it to label the variable “activity” in extracted_features data set accordingly.

Q4. Appropriately label the data set with descriptive variable names
This run_analysis.R assumes that the “data set” here refers to the extracted_features data set, which only contains the measurements that are either mean or SD. The variable names are already appropriately label in Q2 when the data set was created.
But just in case the reader wants to see the descriptive variable names for the whole data set, the pertinent command for this is also included in the Rscript.

Q5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Step 1: The extracted_features data are transformed to a long data set (679734 * 5). The id variables are: subject, activity and group. All the names of the measurements are put in one column and their values in another.
Step 2: The transformed data set is then grouped by the 3 id variables. Each of the 180 groups (180 = 30 subjects * 6 activities) identifies a particular subject with a particular activity. The mean values of the measurements are then calculated for each group. 2 types of tidy data set (wide/long) are created for different types of subsequent analysis.




