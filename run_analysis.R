## The purpose of this script is to clean and organize the data collected from the
## accelerometers of a Samsung Galaxy S smartphone.

## Use the read.table() function to read each relevant file in the UCI HAR data set folder
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

## Merge the subject files, y files, and x files and give them variable names
subject_data <- rbind(subject_test, subject_train)
names(subject_data) <- c("Subject")
y_data <- rbind(y_test, y_train)
names(y_data) <- c("Activity")
x_data <- rbind(x_test, x_train)
names(x_data) <- features$V2
merged_data <- cbind(subject_data, y_data, x_data)

## Extract the mean and std measurements from our merged data set by using the grep() function
mean_std_subset <- grep(".*mean.*|.*std.*", names(merged_data), ignore.case = TRUE)
selected_col <- c(1,2,mean_std_subset)
mean_std_data <- subset(merged_data, select = selected_col)

## Give descriptive activity names to the Activity column by using the activity_labels data
mean_std_data$Activity <- as.character(mean_std_data$Activity)
for (i in 1:6) {
  mean_std_data$Activity[mean_std_data$Activity == i] <- as.character(activity_labels[i,2])
}

## Appropriately labels the data set with descriptive variable names.
names(mean_std_data) <- gsub("^t", "Time", names(mean_std_data))
names(mean_std_data) <- gsub("Acc", "Accelerometer", names(mean_std_data))
names(mean_std_data) <- gsub("gravity", "Gravity", names(mean_std_data))
names(mean_std_data) <- gsub("Mag", "Magnitude", names(mean_std_data))
names(mean_std_data) <- gsub("^f", "Freq", names(mean_std_data))
names(mean_std_data) <- gsub("-mean()", "Mean", names(mean_std_data))
names(mean_std_data) <- gsub("-std()", "STD", names(mean_std_data))
names(mean_std_data) <- gsub("-freq()", "Freq", names(mean_std_data))
names(mean_std_data) <- gsub("tBody", "TimeBody", names(mean_std_data))

## From the mean_std_data, create a new tidy data set which organizes and groups by Subject and Activity
## and finds the average of each variable for each activity and each subject. Write the data to a file. 
tidy_data <- aggregate(. ~Subject + Activity, mean_std_data, mean)
tidy_data <- tidy_data[order(tidy_data$Subject, tidy_data$Activity), ]
write.table(tidy_data, file = "Tidy.txt", row.names = FALSE)


