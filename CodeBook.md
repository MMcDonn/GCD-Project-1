---
title: "CodeBook"
author: "Michael McDonnell"
date: "December 27, 2015"
output: html_document
---

The location
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
contains data used for the following analysis. The zip file contains a txt file
for a training and testing data set. In each of these is a set of observations for
the following form a samsung smartphone accelerometer

- the X axis acceleration signal
- the Y axis acceleration signal
- the Z axis acceleration signal

The data comes separated into a training txt file
and a testing text file. They were both read into R and merged into a single data frame,
with the training set composing the initial 7352 observations and the test
the latter 2947 observations. The is also a list of subject numbers and activity
numbers, for which subject performed which activity. There is also a key provided,
so that each activity number may be interchanged with the titles if one wishes.

This was done by 
```{r}
train <- read.table("./train/X_train.txt", skip = 0, header = FALSE)
train_label <- read.table("./train/y_train.txt", header = FALSE)
test <- read.table("./test/X_test.txt", header = FALSE)
test_label <- read.table("./test/y_test.txt", header = FALSE)
features <- read.table("./features.txt", skip = 0, header = FALSE)
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
```

```{r}
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
```

The dataframe was then searched for features with mean and standard deviation.
The energy results were disregarded. A similar process was done for the standard
deviation of the data frame, denoted std() in the columns. The relevant mean() and
std() columns were then subsetted from the data frame and a new data frame was
constructed from only these columns.
```{r}
stdColIndexSingles <- c(202,215,228,241,254,504,517,530,543)
stdColIndexTriples <- c(4,44,84,124,164,269,348,427)
stdCols <- c()
newelts <- c()
for (i in stdColIndexTriples){
        newelts <- c(i,i+1,i+2)
        stdCols <- c(stdCols, newelts)
}
stdCols <- append(stdCols, stdColIndexSingles)
stdCols <- sort(stdCols)
meanColIndexTriples <- c(1,41,81,121,161,266,294,345,373,424,452)
meanCols <- c()
for (i in meanColIndexTriples){
        newelts <- c(i,i+1,i+2)
        meanCols <- c(meanCols, newelts)
}
subDat <- cbind(totalDat[,meanCols], totalDat[,stdCols])
```

Since the activity column was still just a vector of numbers, it was changed to
a factor with the levels of the factors pertaining to the activity information 
in the provided data file. The following function was used
```{r}
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
```

The dplyr package was then imported and the data set was transformed into
a data frame with the mean of each activity for each subject. The final units
for each variable are standard gravity units 'g' for those variables concerning acceleration,
and radians/second for those variables concerning gyroscopic movements.
```{r}
Mean_of_subject_by_activity <- subDat %>% group_by(activity, subject) %>% summarize_each(funs(mean))
```
