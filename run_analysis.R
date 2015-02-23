#find file names
files1 <- as.character(list.files(path="[file path]"))
readLines(files[1])
files2 <- as.character(list.files(path="[file path]"))
readLines(files[1])
dataset1<-read.csv(files1, header = TRUE, sep = ",", quote = "\"",
                   dec = ".", fill = TRUE, comment.char = "", ...)
dataset2<-read.csv(files2, header = TRUE, sep = ",", quote = "\"",
                   dec = ".", fill = TRUE, comment.char = "", ...)


thelabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
findfeatures <- read.table("./UCI HAR Dataset/features.txt")[,2]
pullfeatures <- grepl("mean|std", features)

Xtestdata <- read.table("./UCI HAR Dataset/test/Xtestdata.txt")
Ytestdata <- read.table("./UCI HAR Dataset/test/Ytestdata.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(Xtestdata) = findfeatures

Xtestdata = Xtestdata[,extract_features]
Ytestdata[,2] = activity_labels[Ytestdata[,1]]

names(Ytestdata) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

test_data <- cbind(as.data.table(subject_test), Ytestdata, Xtestdata)

Xtraindata <- read.table("./UCI HAR Dataset/train/Xtraindata.txt")
Ytraindata <- read.table("./UCI HAR Dataset/train/Ytraindata.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(Xtraindata) = features
Xtraindata = Xtraindata[,pullfeatures]
Ytraindata[,2] = thelabels[Ytraindata[,1]]

names(Ytraindata) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
# merges the data sets
intermediate_merge <- merge(dataset1, dataset2, by=c("subject", "Activity_ID", "Activity_Label"), all.x=TRUE)
final_merge <- merge(dataset3, intermediate_merge, by=c("subject", "Activity_ID", "Activity_Label"), all.y=TRUE)
dataset3<-final_merge

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
coupledata = melt(data, id = id_labels, measure.vars = data_labels)
tidy_data = dcast(coupledata, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
