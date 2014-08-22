# File names
trainingSetFileName <- 'train/X_train.txt'
trainingLabelsFileName <- 'train/y_train.txt'
testingSetFileName <- 'test/X_test.txt'
testingLabelsFileName <- 'test/y_test.txt'
columnNameFileName <- 'features.txt'
labelNameFileName <- 'activity_labels.txt'
trainingSubjectFileName <- 'train/subject_train.txt'
testingSubjectFileName <- 'test/subject_test.txt'

# Read data
trainingSet <- read.table(trainingSetFileName)
columnNames <- read.table(columnNameFileName)
testingSet <- read.table(testingSetFileName)

trainingLabels <- read.table(trainingLabelsFileName)
colnames(trainingLabels) <- c('activityCode')

testingLabels <- read.table(testingLabelsFileName)
colnames(testingLabels) <- c('activityCode')

labelNames <- read.table(labelNameFileName)
colnames(labelNames) <- c('activityCode', 'activityName')

trainingSubjectSet <- read.table(trainingSubjectFileName)
testingSubjectSet <- read.table(testingSubjectFileName)

# Combine testing and training sets
combinedSubjects <- rbind(trainingSubjectSet, testingSubjectSet)
colnames(combinedSubjects) <- c('subject')

columnNames <- columnNames$V2
colnames(trainingSet) <- columnNames
colnames(testingSet) <- columnNames

combinedSet <- rbind(trainingSet, testingSet)

meanColumns <- grep("mean\\(\\)", columnNames)
stdColumns <- grep("std()", columnNames)

selectedColumns <- c(meanColumns, stdColumns)
selectedColumnNames <- colnames(combinedSet)[selectedColumns]
resultSet <- combinedSet[, selectedColumns]

# Beautify column names
selectedColumnNames <- gsub("-mean\\(\\)-", "Mean", selectedColumnNames)
selectedColumnNames <- gsub("-mean\\(\\)", "Mean", selectedColumnNames)
selectedColumnNames <- gsub("-std\\(\\)-", "StdDev", selectedColumnNames)
selectedColumnNames <- gsub("-std\\(\\)", "StdDev", selectedColumnNames)
colnames(resultSet) <- selectedColumnNames

#Add activity labels
combinedLabels <- rbind(trainingLabels, testingLabels)
resultLabels <- merge(combinedLabels, labelNames)

# Create result data set with activity labels and subject info
resultSet <- cbind(resultLabels, combinedSubjects, resultSet)
head(resultSet)
write.table(resultSet, "./result.txt")

# Now, create the second data set with average info grouped by activity and subject

#newSet <- combinedSet # without labels and activities to avoid aggregation warnings
newSet <- resultSet[, 4:length(resultSet)]
aggregatedSet <- aggregate(newSet, list(combinedLabels$activityCode, combinedSubjects$subject), mean)
colnames(aggregatedSet)[1] <- 'activityCode'
colnames(aggregatedSet)[2] <- 'subject'
aggregatedSet <- merge(labelNames, aggregatedSet)

#Print results
head(aggregatedSet[,1:10 ])

# Check for NA
any(is.na(aggregatedSet))

write.table(aggregatedSet, "./aggregatedDataSet.txt")
write.table(selectedColumnNames, "./colnames.txt", row.names=FALSE, col.names=FALSE) #Save for use in .md file
