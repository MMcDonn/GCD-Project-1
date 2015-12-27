---
title: "README"
author: "Michael McDonnell"
date: "December 27, 2015"
output: html_document
---

The run_analysis.R is a script that reads in the Samsung Galaxy S smartphone
accelerometer data from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and combines the provided training and test data sets into a single data frame.
Each observation in the data frame is then assigned to its relevant activity
and also from which subject the measurement was obtained.

The final product and last output of the script is a dataframe with 
the mean and standard deviation for each measurement of each subject doing 
each activity.