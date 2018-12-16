install.packages(c("data.table", "dplyr", "knitr"))
library(data.table)
library(dplyr)
library(knitr)

path <- getwd()

# download  & unzip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "dataset.zip"
if(!file.exists(path)){dir.create(path)}
if(!file.exists("dataset.zip")){download.file(url, file.path(path, filename))}
if(!file.exists("UCI HAR Dataset")){unzip(filename)}

dtFeatures <- read.table(file.path(path,"features.txt"), col.names = c("featureNum", "featureName"))
dtActivityNames <- read.table(file.path(path,"activity_labels.txt"), col.names = c("featureNum", "featureName"))

# read subject files
subjectTrain <- read.table(file.path(path,"train","subject_train.txt"), col.names = "subject")
subjectTest <- read.table(file.path(path,"test","subject_test.txt"), col.names = "subject")

# read activity files
yTrain <- read.table(file.path(path,"train","y_train.txt"), col.names = "activityNum")
yTest <- read.table(file.path(path,"test","y_test.txt"), col.names = "activityNum")

# read data files
xTrain <- read.table(file.path(path,"train","X_train.txt"), col.names = dtFeatures$featureName)
xTest <- read.table(file.path(path,"test","X_test.txt"), col.names = dtFeatures$featureName)

# 1. Merges the training and the test sets to create one data set.
dt <- rbind(xTrain, xTest)
activity <- rbind(yTrain, yTest)
subject <- rbind(subjectTrain, subjectTest)
mergedData <- cbind(subject, activity, dt)
print("1. Merges the training and the test sets to create one data set. (OK)")
print("features.txt, activity_labels.txt, subject_train.txt, subject_test.txt, y_train.txt, y_test.txt, X_train.txt, X_test.txt merged into mergedData")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanData <- mergedData %>% 
  select(subject, activityNum, contains("mean"), contains("std"))
print("2. Extracts only the measurements on the mean and standard deviation for each measurement. (OK)")

# 3. Uses descriptive activity names to name the activities in the data set
meanData$activityNum <- dtActivityNames[meanData$activityNum, 2]
print("3. Uses descriptive activity names to name the activities in the data set (OK)")

# 4. Appropriately labels the data set with descriptive variable names.
names(meanData)[2] = "Activity"
names(meanData)<-gsub("Acc", "Accelerometer", names(meanData))
names(meanData)<-gsub("Gyro", "Gyroscope", names(meanData))
names(meanData)<-gsub("BodyBody", "Body", names(meanData))
names(meanData)<-gsub("Mag", "Magnitude", names(meanData))
names(meanData)<-gsub("^t", "Time", names(meanData))
names(meanData)<-gsub("^f", "Frequency", names(meanData))
names(meanData)<-gsub("tBody", "TimeBody", names(meanData))
names(meanData)<-gsub("-mean()", "Mean", names(meanData), ignore.case = TRUE)
names(meanData)<-gsub("-std()", "STD", names(meanData), ignore.case = TRUE)
names(meanData)<-gsub("-freq()", "Frequency", names(meanData), ignore.case = TRUE)
names(meanData)<-gsub("angle", "Angle", names(meanData))
names(meanData)<-gsub("gravity", "Gravity", names(meanData))
print("4. Appropriately labels the data set with descriptive variable names. (OK)")

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

finalData <- meanData %>%
  arrange(subject, Activity) %>%
  group_by(subject, Activity) %>%
  summarise_all(funs(mean))

print("5. Create tidy data set and write into table.")
  
write.table(finalData, "finalData.txt", row.names = FALSE)
print(finalData)

makeCodebook(finalData, file = "codebook.Rmd", output = "html", mode = c("summarize", "check"), codebook = TRUE, addCodebookTable = TRUE)