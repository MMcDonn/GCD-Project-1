library(dplyr)
fileURL <- ("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
setwd("D:/Coursera - Data Science Track/Getting and Cleaning Data/Course Project 1/UCI Har Dataset")
if(!file.exists("data")){
        dir.create("data")
}
download.file(fileURL, destfile = "./data", mode = "wb")
unzip("./data")
setwd("./UCI HAR Dataset")

#Read in related data sets
train <- read.table("./train/X_train.txt", skip = 0, header = FALSE)
train_label <- read.table("./train/y_train.txt", header = FALSE)
test <- read.table("./test/X_test.txt", header = FALSE)
test_label <- read.table("./test/y_test.txt", header = FALSE)
features <- read.table("./features.txt", skip = 0, header = FALSE)
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")

#Combining train and test subject indicies into one dataframe
subject <- rbind(subject_train, subject_test)
#Giving names to the respective train/test dataframes from the features df
colnames(train) <- features[,2] 
colnames(test) <- features[,2]
#Creating single activity label df from separate train/test df 
activity <- rbind(train_label, test_label)
#Combining each data set (train,test) into one data set
totalDat <- rbind(train, test)
#Check for NAs
all(colSums(is.na(totalDat)) == 0)


#Before the use of grep() was known, a search for 'mean' was done in
# View(totalDat). A pattern emerged for the columns containing 'mean' to be in triples.
#Each number in the vector below represents a triple of mean values for each dimension, (x,y,z)
#For example, element 41 means that column 41,42,43 have values for means (x,y,z)
meanColIndexTriples <- c(1,41,81,121,161,266,294,345,373,424,452)
meanCols <- c()
for (i in meanColIndexTriples){
        newelts <- c(i,i+1,i+2)
        meanCols <- c(meanCols, newelts)
}


#Similar procedure conducted to that above for std() - again, before the use of 
# grep() was known. This time there were single columns to completement the triples.
#Do the same as above for the std() whatever and form a vector for applicable columns.
#reduce current data frame totalDat down to only mean/std dataframe
stdColIndexSingles <- c(202,215,228,241,254,504,517,530,543)
stdColIndexTriples <- c(4,44,84,124,164,269,348,427)
stdCols <- c()
newelts <- c()
for (i in stdColIndexTriples){
        newelts <- c(i,i+1,i+2)
        stdCols <- c(stdCols, newelts)
}
#Combining the vector of column indicies from singles and triples
stdCols <- append(stdCols, stdColIndexSingles)
stdCols <- sort(stdCols)

#Subsetting the totalDat df down to a df only concerned with mean and std.
subDat <- cbind(totalDat[,meanCols], totalDat[,stdCols])

#Inserts the activities and subjects as first two columns in dataframe
#and gives them column names
subDat <- cbind(activity, subDat)
subDat <- rename(subDat, activity = V1)
subDat <- cbind(subject, subDat)
subDat <- rename(subDat, subject = V1)


#Gives character names to the number indicies for activities
rename_fun <- function(x){
        if (x == 1){
                x = "WALKING"
        }
        else if (x == 2){
                x = "WALKING_UPSTAIRS"
        }
        else if (x == 3){
                x = "WALKING_DOWNSTAIRS"
        }
        else if (x == 4){
                x = "SITTING"
        }
        else if (x == 5){
                x = "STANDING"
        }
        else if (x == 6){
                x = "LAYING"
        }
}


#use the rename function to transform activity numbers to words
subDat$activity <- sapply(subDat$activity, rename_fun)

#Sorting subDat df by activity
subDat <- arrange(subDat, activity)

#Converting the activity and subject columns to factors for grouping
subDat$activity <- as.factor(subDat$activity)
subDat$subject <- as.factor(subDat$subject)

#creates new DF which considers the mean of each activity for each subject
Mean_of_subject_by_activity <- subDat %>% group_by(activity, subject) %>% 
        summarize_each(funs(mean))




