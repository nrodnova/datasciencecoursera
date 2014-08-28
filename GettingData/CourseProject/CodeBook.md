Data transformation for "Getting and Cleaning Data" project assignment
=========================================================================


In the attached script run_analysis.R, the data transformation, described in the project assignment, was performed.

The following files ware read from the data directory:

* test/X_test.txt 
* test/y_test.txt
* test/subject_test.txt
* train/X_train.txt
* train/y_train.txt
* train/subject_train.txt
* ./features.txt
* ./activity_labels.txt

All files are in space-separated text format, and they were read using

```r
read.table()
```
X_%.txt files contain actual observations

y_%.txt files contain activity codes for each row in the observation file

subject_*.txt files contain subject code for each row in the observation file

features.txt contains comprehensive names for columns in the observation files

activity_labels.txt has comprehensive names corresponsing to activity codes used in y%.txt files

When data is in memory, the following transformations were performed:

1. training and testing sets were concatenated in one
2. also, activity codes and subject codes were concatenated
3. activity codes were merged with activity label info based on the activity code
4. desctiptive column names were added to the data set
4. new data frame was created with column names containing only mean() and std()
5. all data was put in one data frame
6. data set was aggregated by activity code and subject code and saved in the output file

### Data description
The following columns of `numeric` type were selected from the original dataset (with -mean() and -std() replaced by Mean and StdDev for better readability):

```html
tBodyAccMeanX
tBodyAccMeanY
tBodyAccMeanZ
tGravityAccMeanX
tGravityAccMeanY
tGravityAccMeanZ
tBodyAccJerkMeanX
tBodyAccJerkMeanY
tBodyAccJerkMeanZ
tBodyGyroMeanX
tBodyGyroMeanY
tBodyGyroMeanZ
tBodyGyroJerkMeanX
tBodyGyroJerkMeanY
tBodyGyroJerkMeanZ
tBodyAccMagMean
tGravityAccMagMean
tBodyAccJerkMagMean
tBodyGyroMagMean
tBodyGyroJerkMagMean
fBodyAccMeanX
fBodyAccMeanY
fBodyAccMeanZ
fBodyAccJerkMeanX
fBodyAccJerkMeanY
fBodyAccJerkMeanZ
fBodyGyroMeanX
fBodyGyroMeanY
fBodyGyroMeanZ
fBodyAccMagMean
fBodyBodyAccJerkMagMean
fBodyBodyGyroMagMean
fBodyBodyGyroJerkMagMean
tBodyAccStdDevX
tBodyAccStdDevY
tBodyAccStdDevZ
tGravityAccStdDevX
tGravityAccStdDevY
tGravityAccStdDevZ
tBodyAccJerkStdDevX
tBodyAccJerkStdDevY
tBodyAccJerkStdDevZ
tBodyGyroStdDevX
tBodyGyroStdDevY
tBodyGyroStdDevZ
tBodyGyroJerkStdDevX
tBodyGyroJerkStdDevY
tBodyGyroJerkStdDevZ
tBodyAccMagStdDev
tGravityAccMagStdDev
tBodyAccJerkMagStdDev
tBodyGyroMagStdDev
tBodyGyroJerkMagStdDev
fBodyAccStdDevX
fBodyAccStdDevY
fBodyAccStdDevZ
fBodyAccJerkStdDevX
fBodyAccJerkStdDevY
fBodyAccJerkStdDevZ
fBodyGyroStdDevX
fBodyGyroStdDevY
fBodyGyroStdDevZ
fBodyAccMagStdDev
fBodyBodyAccJerkMagStdDev
fBodyBodyGyroMagStdDev
fBodyBodyGyroJerkMagStdDev
```
the following columns were added to the beginning of the data set:
```html
activityCode - numeric
activityName - string
subject - numeric
```

The final output dataset contains the same fields as above, but the values are means of the observations grouped by activity and subject.