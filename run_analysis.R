# loading train data
X_train <- read.table("./input/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./input/UCI HAR Dataset/train/y_train.txt",col.names = c("label"))
subject_train <- read.table("./input/UCI HAR Dataset/train/subject_train.txt",col.names = c("subject"))

# loading test data
X_test <- read.table("./input/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./input/UCI HAR Dataset/test/y_test.txt",col.names = c("label"))
subject_test <- read.table("./input/UCI HAR Dataset/test/subject_test.txt",col.names = c("subject"))

# loading feature names
feature_name <- read.table("./input/UCI HAR Dataset/features.txt", header = FALSE, sep = " ", col.names = c("id","name"))

# merging train and test data
X <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

# assign feature names to feature data (X)
names(X) = feature_name$name

# extracts only the measurements on the mean and standard deviation for each measurement
selected_cols <- grep("mean|std",names(X))
X <- X[ ,selected_cols]

# adding 'subject' and 'y' as column in X (Order : subject,feature1, feature2, ...,label)
tidy_data <- cbind(subject,X,y)

# reading activity labels
activity_label <- read.table("./input/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ", col.names = c("label","name"))


# import dplyr package for mutate
library(dplyr)
tidy_data <- mutate( tidy_data, activity = activity_label$name[label]) # assign activity label to each row according to label column
tidy_data <- select(tidy_data, -label)


# From the tidy data set , creating a second, 
#independent tidy data set with the average of 
#each variable for each activity and each subject.
mean_data<- tidy_data %>%
  group_by(activity,subject) %>%
  summarise_all(mean)

write.csv(tidy_data,"tidy_data.csv",row.names = FALSE)
write.csv(mean_data,"tidy_data_with_mean.csv",row.names = FALSE)
