library(cluster)
library(caret)
library(ggplot2)
library(NbClust)

# 1. interview.csv 파일을 활용하여 계층적 군집을 다음의 조건에 맞게 수행해보세요
data <- read.csv("data\\interview.csv", stringsAsFactors = F)
head(data)


# - 데이터 첫번째 컬럼 삭제
data <- data[,-1]


# - 와드연결법 사용하여 수행
str(data)
summary(data)
data$합격여부;

d <- dist(data[,-8], method = "euclidean")
clustering.w <- hclust(d, method = "ward.D")
clustering.w
summary(clustering.w)

par(mfrow=c(1,2))
plot(clustering.w)
rect.hclust(clustering.w, k = 3, border = 'red')


# - 3개의 군집으로 덴드로그램 그리기
data.norm <- scale(data[,-8])

clustering.kms <- kmeans(data.norm, 3)
plot(data.norm, col=clustering.kms$cluster)
points(clustering.kms$centers, col=1:3, pch=9, cex=1.5)


# - 군집결과와 실제 데이터의 합격여부와 비교검토
df_ref <- data.frame(id=seq(1,15,1), group=data$합격여부);
df_ref$group <- ifelse(df_ref$group=="합격", 1, 0)
df_ref$group <- as.factor(df_ref$group)
df_ref

clustering.w.cut <- cutree(clustering.w, k=3)
df1 <- data.frame(id=clustering.w$order, group=clustering.w.cut)
df1 <- df1[order(df1$id),]
df1 <- data.frame(id=df1$id, group=df1$group)
df1
df11 <- data.frame(id=df1$id, group=ifelse(df1$group==1,1,0)); df11$group <- as.factor(df11$group)
df12 <- data.frame(id=df1$id, group=ifelse(df1$group==2,1,0)); df12$group <- as.factor(df12$group)
df13 <- data.frame(id=df1$id, group=ifelse(df1$group==3,1,0)); df13$group <- as.factor(df13$group)
confusionMatrix(df11$group, df_ref$group)
confusionMatrix(df12$group, df_ref$group)
confusionMatrix(df13$group, df_ref$group) # Accuracy : 0.7333(Best)


str(clustering.kms)
df2 <- data.frame(id=seq(1,15,1), group=clustering.kms$cluster)
df2
df21 <- data.frame(id=df2$id, group=ifelse(df2$group==1,1,0)); df21$group <- as.factor(df21$group)
df22 <- data.frame(id=df2$id, group=ifelse(df2$group==2,1,0)); df22$group <- as.factor(df22$group)
df23 <- data.frame(id=df2$id, group=ifelse(df2$group==3,1,0)); df23$group <- as.factor(df23$group)
confusionMatrix(df21$group, df_ref$group)
confusionMatrix(df22$group, df_ref$group) # Accuracy : 1(Best)
confusionMatrix(df23$group, df_ref$group)






# 2. ggplot2 diamonds 데이터셋 활용하여 다음의 조건에 맞게 비계층적 군집 수행

data("diamonds")
dia <- diamonds

# - price, carat, depth, table 4개의 컬럼 추출하여 dia1 생성 
str(dia)
dia1 <- data.frame(price=dia$price, carat=dia$carat, depth=dia$depth, table=dia$table)
head(dia1)


# - 위 작업 후 1000개의 데이터 랜덤샘플링하여 dia2 생성
idx <- sample(1:length(dia1$price), 1000, replace = T)
dia2 <- dia1[idx,]


# - dia2 데이터 정규화 진행
dia2.norm <- scale(dia2)


# - nbclust 이용 적정 k값 산정
nc2.kms <- NbClust::NbClust(dia2.norm, method="kmeans")
table(nc2.kms$Best.nc[1,]) # 3


# - 비계층적 군집실시
clustering2.kms <- kmeans(dia2.norm, 3)
str(clustering2.kms)


# - carat과 price에 대한 산포도 작성(plot() 의 컬러 인수에 군집결과$cluster를 할당하여 군집별 색상 구분)
plot(dia2.norm, col=clustering2.kms$cluster, pch=clustering2.kms$cluster)


