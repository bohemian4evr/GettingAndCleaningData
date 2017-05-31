library(data.table)
#hardcoded the path
setwd("E:/Coursera/UCI HAR Dataset/test)
#saving the test data in a variables
	test10 <- read.table("subject_test.txt")
	test11 <- read.table("X_test.txt")
	test12 <- read.table("y_test.txt")

setwd("E:/Coursera/UCI HAR Dataset/train")
#Saving the train data in variables
 	train10 <- read.table("subject_train.txt")
	train11 <- read.table("X_train.txt")
 	train12 <- read.table("y_train.txt")

#1
#Creating data set

 DataSet<- rbind(test11,train11)

 DataSet_Subject<- rbind(test10,train10)
 colnames(DataSet_Subject)<- c("Subject_id")

 DataLebel <-  rbind(test12,train12)
 colnames(DataLebel)<- c("Activity")
 DataSet <- cbind(DataSet,DataSet_Subject,DataLebel)

#2

setwd("E:/Coursera/UCI HAR Dataset")
Features<-read.table("features.txt")
colnames(Features) <- c("Feature_id","FeatureName")
my_logical_features <- grep ("mean\\(\\)|std\\(\\)", dt_features$feature_name)
DataSet1<-DataSet[,paste("V",my_logical_features,sep="")]
DataSet<- cbind(DataSet1,DataSet_Subject,DataLebel)

#3

df_activity_labels<-as.data.frame(read.table("activity_labels.txt"))
colnames(df_activity_labels)<-c("Activity","ActivityName")
DataSet1<- merge(x=DataSet,y=df_activity_labels,by.x="activity_id",by.y="Activity")

#4

colnames(DataSet)[4:69]<-paste(Features$FeatureName[my_logical_features])

#5
#Creating a dummy data set for performing the operations
Dataset1<-DataSet
DataMean<-apply(DataSet1[,4:69],1,mean)
#creating a new column for grouping of the data
DataSet1$nc <- 10*DataSet1$Subject_id + DataSet$activity_id

#Grouping the data into different groups based on nc
df<-split(DataSet1,f=DataSet1$nc)
df2<-sapply(df,function(x){sapply(x[,4:69],mean)})

DataSet <-t(df2)
DataSet$Subject<-DataSet$nc%/%10
DataSet$Activity<-DataSet$nc%%10
#Deleting the nc column
DataSet$nc <- NULL
#creating the final dataset
DataSet<- merge(x=DataSet,y=df_activity_labels,by.x="Activity", by.y="Activity")

#writing the data set in a text file
write.table(DataSet1, file="tidyData.txt", row.name=FALSE, sep = "\t")








