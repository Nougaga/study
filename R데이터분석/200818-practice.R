
# ggplot2의 diamonds 데이터셋을 활용하여,
# decision tree와 앙상블 모형을 적용,
# 모델링을 수행하고 정확도를 비교해보세요 
# 
# (단, price 컬럼을 다음과 같이 명목형으로 변경하여 수행하세요)
# (3분위(75%)이상이면 S등급, 2분위(50%)이상이면 A, 
#   1분위수(25%)이상이면 B등급, 25%이하는 C등급)

library(ggplot2)
data(diamonds)
dia <- diamonds
str(dia)
summary(dia)
# factor 형을 level을 integer 삼아 변환
dia$cut <- as.integer(dia$cut)
dia$color <- as.integer(dia$color)
dia$clarity <- as.integer(dia$clarity)
# dia$price[dia$price >= 5324] <- 5324
# dia$price[dia$price < 5324 & dia$price >= 2401] <- 2401
# dia$price[dia$price < 2401 & dia$price >= 950] <- 950
# dia$price[dia$price < 950] <- 0
# dia$price <- factor(dia$price, levels=c(5324,2401,950,0), labels=c("S","A","B","C"))
dia$price <- ifelse(dia$price >= quantile(dia$price, 0.75), "S",
                    ifelse(dia$price >= quantile(dia$price, 0.5), "A",
                           ifelse(dia$price >= quantile(dia$price, 0.25), "B", "C"
                           )))
dia$price <- factor(dia$price, levels=c("S","A","B","C"))
dia <- as.data.frame(dia)
table(dia$price)

library(caret)  # caret::confusionMatrix()

# 1. Decision Tree : rpart::rpart()
library(rpart)
library(rpart.plot)

idx1 <- createDataPartition(dia$price, p=0.7, list=F)
train1 <- dia[idx1,]
test1 <- dia[-idx1,]

dia.rpart <- rpart(price~., data=train1)
dia.rpart
prp(dia.rpart, type=2, extra=2, digits=3)

dia.rpart.pr <- predict(dia.rpart, newdata=test1, type='class')
confusionMatrix(dia.rpart.pr, test1$price)  # Accuracy : 0.8417

# prunning
plotcp(dia.rpart)
dia.rpart.prn <- prune(dia.rpart, cp=dia.rpart$cptable[4])
prp(dia.rpart.prn, type=2, extra=2, digits=3)

dia.rpart.prn.pr <- predict(dia.rpart.prn, newdata=test1, type='class')
confusionMatrix(dia.rpart.prn.pr, test1$price)  # Accuracy : 0.7938


# 2. Decision Tree : party::ctree()
library(party)

idx2 <- createDataPartition(dia$price, p=0.7, list=F)
train2 <- dia[idx2,]
test2 <- dia[-idx2,]

dia.ctree <- ctree(price~., data=train2)
dia.ctree
# plot(dia.ctree)

dia.ctree.pr <- predict(dia.ctree, newdata=test2)
confusionMatrix(dia.ctree.pr, test2$price)  # Accuracy : 0.9227

con <- ctree_control(maxdepth = 3)
dia.ctree.prn <- ctree(price~., data=train2, controls=con)
plot(dia.ctree.prn)



# 3. Decision Tree : tree::tree()
library(tree)

idx3 <- createDataPartition(dia$price, p=0.7, list=F)
train3 <- dia[idx3,]
test3 <- dia[-idx3,]

dia.tree <- tree(price~., data=train3)
dia.tree
plot(dia.tree)
text(dia.tree)

dia.tree.pr <- predict(dia.tree, newdata=test3, type='class')
confusionMatrix(dia.tree.pr, test3$price)  # Accuracy : 0.8428



# 4. Ensemble : Bagging
library(adabag)

dia.bagging <- bagging(price~., data=dia, mfinal=100)
dia.bagging$importance

plot(dia.bagging$trees[[49]], margin=.1)
text(dia.bagging$trees[[49]])

dia.bagging.pr <- predict(dia.bagging, newdata=dia[,-7])
confusionMatrix(factor(dia.bagging.pr$class, levels=c("S","A","B","C")), 
                dia[,7]) # Accuracy : 0.8378

# # looking into model
# summary(dia.bagging)
# dia.bagging$votes
# dia.bagging$samples[,1]
# 
# # checking sample data
# bg_sample <- table(sort(dia.bagging$samples[,1]))
# bg_sample
# attributes(bg_sample1)$dimnames[[1]]


# 5. Ensemble : Boosting

# 6. Ensemble : Random Forest
library(randomForest)

idx6 <- createDataPartition(dia$price, p=0.7, list=F)
train6 <- dia[idx6,]
test6 <- dia[-idx6,]

set.seed(1984)
dia.rf <- randomForest(price~., data=train6,
                       ntree=40, mtry=floor(sqrt(length(dia)-1)), importance=T)
plot(dia.rf)

dia.rf.pr <- predict(dia.rf, newdata=test6[,-7])
confusionMatrix(dia.rf.pr, test6[,7]) # Accuracy : 0.9341

importance(dia.rf)
varImpPlot(dia.rf, main="varImpPlot of diamonds")

