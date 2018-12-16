# gettingandcleaningdatacoursera
Coursera: Getting and Cleaning Data Course Project

This is a submission for Coursera: Getting and Cleaning Data Course Project by Tania Savitri.

By running the R script run_analysis.R file it will automatically install "data.table" "dplyr" and "knitr" packages and load it into your library. The script will also automatically download the data from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unzip it for you. 
The code is separated into 5 sections:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The tidy data set output is "finalData.txt"

The [codebook.Rmd] (Codebook.Rmd) lists all variables and classes in the "finalData.txt".
