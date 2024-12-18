library(dplyr)
library(rstudioapi)

# get directory of current source file
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# import labels and names
features<-read.csv("./features.txt", header=FALSE, sep=" ")
features<-features[2]
subject_ID<-read.csv("./test/subject_test.txt", header=FALSE)
subject_ID2<-read.csv("./train/subject_train.txt", header=FALSE)

# Regex to preprocess x_test file
x_test<-readLines("./test/X_test.txt")
# make the sep uniformly one space
x_test<-gsub("\\s+"," ", x_test)
# get rid of space before new line
x_test<-gsub("^\\s+","", x_test)
# write to new clean txt file
writeLines(x_test,"./test/clean_xtest.txt")
x_test<-read.csv("./test/clean_xtest.txt", header=FALSE, sep=" ")

# Read in y labels
y_test<-read.csv("./test/y_test.txt", header=FALSE)

# column names
names(subject_ID)<-c("Participant_ID")
names(x_test)<-features[[1]]
names(y_test)<-c("Activity")

# only get mean or std type variables
x_test<-select(x_test,matches("mean()")|matches("std()"))
# remove the measurements calculating angle between means
x_test<-select(x_test,-(matches("angle\\(")))

# Regex to preprocess x_train file
x_train<-readLines("./train/X_train.txt")
# make the sep uniformly one space
x_train<-gsub("\\s+"," ", x_train)
# get rid of space before new line
x_train<-gsub("^\\s+","", x_train)
# write to new clean txt file
writeLines(x_train,"./train/clean_xtrain.txt")
x_train<-read.csv("./train/clean_xtrain.txt", header=FALSE, sep=" ")

# read in y labels
y_train<-read.csv("./train/y_train.txt", header=FALSE)

# column names
names(subject_ID2)<-c("Participant_ID")
names(x_train)<-features[[1]]
names(y_train)<-c("Activity")

# only get mean or std type variables
x_train<-select(x_train,matches("mean()")|matches("std()"))
# remove the measurements calculating angle between means
x_train<-select(x_train,-(matches("angle\\(")))


# merge
x_merge<-bind_rows(x_test,x_train)
y_merge<-bind_rows(y_test,y_train)
ID_merge<-bind_rows(subject_ID,subject_ID2)
df<-cbind(ID_merge,y_merge,x_merge)

# find average of each variable for each activity and subject
# as specified in the assignment directions
for (i in 1:max(df$Participant_ID)){
  for (j in 1:6) {
    test<-filter(df,Participant_ID == i & Activity == j)
    test<-summarise(test,across(everything(),mean))
    names(test)[-c(1,2)] <- paste("AverageOf_",names(test)[-c(1,2)], sep="")
    
    if (i == 1 & j == 1) {
      result <- test
    } else {result<-rbind(result,test[1,])}
  }
}

# put activity names instead of numbers
result<-mutate(result,Activity=recode(Activity,
                              `1` = "Walking",
                              `2` = "Walking Upstairs",
                              `3` = "Walking Downstairs",
                              `4` = "Sitting",
                              `5` = "Standing",
                              `6` = "Laying"))

# write to table for submission
write.table(result, file = "tidytable.txt",row.names=FALSE)