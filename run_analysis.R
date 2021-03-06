#GETTING AND CLEANING DATA COURSE PROJECT

#Install and load requisite libraries
library(data.table)
library(dplyr)

#Remove already stored, existing variables current environment
rm(list=ls())

# set working directory
setwd("~/Desktop")
if(!file.exists ("Project_Merge")){dir.create("Project_Merge") } else{ print(" The dir exists already. No new director made")}
setwd("~/Desktop/Project_Merge")

#Download and Unzip data to local folder
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile= "Data.zip", method = "curl")
DateDownloaded<-date()
DateDownloaded
unzip("Data.zip",  exdir = "./")

#Read Data
setwd("~/Desktop/Project_Merge/UCI HAR Dataset")
Title_X<-fread("features.txt", header = FALSE)
X_train<-fread("./train/X_train.txt", header = FALSE)
X_test<-fread("./test/X_test.txt", header = FALSE)
features<-fread("features.txt", header = FALSE)
Subj_train<-fread("./train/subject_train.txt", header = FALSE)
Subj_test<-fread("./test/subject_test.txt", header = FALSE)
activity_labels<-fread("activity_labels.txt", header = FALSE)

#1. Merges the training and the test sets to create one data set.

X_train_test<-rbind(X_train, X_test)
names(X_train_test)<-Title_X$V2

Subj_train_test<-rbind(Subj_train, Subj_test)
names(Subj_train_test)<- "Subject"

y_train<-fread("./train/y_train.txt", header = FALSE)
y_test<-fread("./test/y_test.txt", header = FALSE)

y_train_test<-rbind(y_train, y_test)
names(y_train_test)<- "Activity"

Compl_Data<-cbind(Subj_train_test,y_train_test, X_train_test)
write.table(Compl_Data, file = "Merged_Training_Test_Dataset.csv", row.names = FALSE)
print("Please find the merged datasets in .csv format at: ~/Desktop/Project_Merge/UCI HAR Dataset/Merged_Training_Test_Dataset.csv")


#2. Extract only the measurements on the mean and standard deviation for each measurement.
Compl2<-Compl_Data
Mean<- grep("mean()", names(Compl2))
Stdev<-grep("std()", names(Compl2))
Mean_Stdev<-select(Compl2, c(1:2, Mean, Stdev))
write.table(Mean_Stdev, file = "Mean_Stdev_Extracted_Dataset.csv", row.names = FALSE)
print("Please find extracted measurements on the mean and standard deviation for each measurement at : ~/Desktop/Project_Merge/UCI HAR Dataset/Mean_Stdev_Extracted_Dataset.csv.csv")



#3. Use descriptive activity names to name the activities in the data set "activity_labels.txt"
Compl3<-Compl2
Compl3$Activity<-as.character(Compl3$Activity)
for(i in 1:6) {
        Compl3$Activity[Compl3$Activity ==i]<- as.character(activity_labels[i,V2])
        }
write.table(Compl3, file = "Dataset_DescActivity.csv", row.names = FALSE)
print("Please find dataset with description of activity at : ~/Desktop/Project_Merge/UCI HAR Dataset/Dataset_DescActivity.csv")


#4. Appropriately labels the data set with descriptive variable names.
Compl4<-Compl3
names(Compl3)<-gsub("^t", "Time", names(Compl4))
names(Compl3)<-gsub("^f", "Frequency", names(Compl4))
names(Compl3)<-gsub("Acc", "Accelerometer", names(Compl4))
names(Compl4)<-gsub("Gyro", "Gyroscope", names(Compl4))
names(Compl4)<-gsub("Mag", "Magnitude", names(Compl4))
names(Compl4)<-gsub("BodyBody", "Body", names(Compl4))
names(Compl4)<-gsub("tBody", "TimeBody", names(Compl4))
names(Compl4)<-gsub("mean()", "Mean", names(Compl4))
names(Compl4)<-gsub("std", "STD", names(Compl4))
names(Compl4)<-gsub("freq", "Frequency", names(Compl4))
names(Compl4)<-gsub("angle", "Angle", names(Compl4))
names(Compl4)<-gsub("gravity", "Gravity", names(Compl4))
write.table(Compl4, file = "Labelled_dataset.csv", row.names = FALSE)
print("Please find the labelled datasets at : ~/Desktop/Project_Merge/UCI HAR Dataset/Labelled_dataset.csv")

#5. From the data set in step 4, creates a second, independent tidy data set with 
#   the average of each variable for each activity and each subject.
Avr_Var<-aggregate(. ~Subject+Activity,Compl4, mean)
Avr_Var<-Avr_Var[order(Avr_Var$Subject, Avr_Var$Activity),]
write.table(Avr_Var, file = "TidyDataSet.txt", row.names = FALSE)
print("Please find the tidy dataset at : ~/Desktop/Project_Merge/UCI HAR Dataset/TidyDataSet.txt")
