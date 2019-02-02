# Importing the dataset

train=read.csv("train_tweets.csv")
test=read.csv("test-tweets.csv")
dataset=train
dataset$label=NULL
dataset1=rbind(dataset,test)



# Cleaning the texts
#install.packages('tm')
#install.packages('SnowballC')
library(tm)
library(SnowballC)
corpus = VCorpus(VectorSource(dataset1$tweet))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)



# Creating the Bag of Words model
dtm = DocumentTermMatrix(corpus)
dtm = removeSparseTerms(dtm, 0.999)
dataset_main = as.data.frame(as.matrix(dtm))


#Splitting of data
train_data=dataset_main[1:31962,]
test_data=dataset_main[31963:49159,]
train_data$Label=train$label


# Fitting Random Forest Classification to the Training set
# install.packages('randomForest')
library(randomForest)
classifier = randomForest(x = train_data[-1124],
                          y = train_data$Label,
                          ntree = 10)


# Predicting the Test set results
y_pred = predict(classifier, newdata = test_data)

y_prob=ifelse(y_pred>0,1,0)

result=as.data.frame(y_prob)
result$Id=test$id
result=result[,c(2,1)]

#Saving data locally
write.csv(result,"twitter_results.csv")
