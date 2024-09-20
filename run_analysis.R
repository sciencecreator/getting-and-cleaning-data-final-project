# Install necessary packages if not already installed
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

# Load dplyr
library(dplyr)

# Load the training and test datasets
# Training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Load features and activity labels
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Merge the training and test sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Get the indices of mean and standard deviation
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features[, 2])

# Subset the data
x_data <- x_data[, mean_std_indices]
colnames(x_data) <- features[mean_std_indices, 2]

# Rename activity data with descriptive activity names
y_data[, 1] <- activity_labels[y_data[, 1], 2]
colnames(y_data) <- "Activity"

colnames(subject_data) <- "Subject"
combined_data <- cbind(subject_data, y_data, x_data)

# Create a tidy data set with the average of each variable for each activity and each subject
tidy_data <- combined_data %>%
group_by(Subject, Activity) %>%
summarize(across(everything(), mean))

# Write the tidy dataset to a text file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
