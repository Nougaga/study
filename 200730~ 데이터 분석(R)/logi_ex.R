### 예제

## 1. 종속변수의 범주가 2개로 하기 위해 iris 데이터의 일부분만 이용
## --> 종속변수는 setosa, versicolor 2개로 이항분류 적용, 독립변수는 sepal.length만 이용


# 1) 데이터 로딩 및 서브셋
data(iris)
head(iris);str(iris);dim(iris)

data <- iris[iris$Species != "virginica",]

# 1.
# data$Species_l <- factor(data$Species, levels=c("setosa","versicolor"), labels = c(1,2))

# 2.
# data$Species <- as.integer(data$Species)
# data$Species <- as.factor(data$Species)

# 3.
data$Species_l[data$Species=="setosa"] <- 1
data$Species_l[data$Species=="versicolor"] <- 2

table(data$Species_l)
data <- data[,c(1,6)]


# 2) factor 변경
data$Species_l <- as.factor(data$Species_l)


# 3) glm 함수로 모델 생성(family = binomial)
model1 <- glm(Species_l~Sepal.Length, data=data, family='binomial')


# 4) 적합된 모델 요약 정보 보기
summary(model1)
# Call:
#   glm(formula = Species_l ~ Sepal.Length, family = "binomial", 
#       data = data)
# 
# Deviance Residuals: 
#     Min        1Q    Median        3Q       Max  
# -2.05501  -0.47395  -0.02829   0.39788   2.32915  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
#   (Intercept)   -27.831      5.434  -5.122 3.02e-07 ***
#   Sepal.Length    5.140      1.007   5.107 3.28e-07 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 138.629  on 99  degrees of freedom
# Residual deviance:  64.211  on 98  degrees of freedom
# AIC: 68.211
# 
# Number of Fisher Scoring iterations: 6

# 5) 적합결과 보기
options(scipen = 100)
fitted(model1)[c(1:100)]
# 훈련된 데이터에서 추출되었기 때문에 적합도가 높음


# 6) predict 위해 편의상 모형 구축에 사용된 데이터, 1,50,51,100 사용
test1 <- data[c(1,50,51,100),]


# 7) predic()로 예측 실시
pred1 <- predict(model1, newdata=test1, type="response")
pred1; summary(pred1)


# 8) 0.5보다 작으면 1(setosa), 아니면 2(versicolor)로 리코딩
result_pred1 <- ifelse(pred1 < 0.5, 1, 2)


# 9) 예측결과와 테스트데이터 caret 패키지의 confusionMatrix()로 비교
# install.packages("caret")
library(caret)
# install.packages("e1071")

(pred1_tbl <- table(result_pred1, test1$Species_l))
# result_pred1 1 2
# 1 2 0
# 2 0 2

confusionMatrix(pred1_tbl)
# Confusion Matrix and Statistics
# 
# 
# result_pred1 1 2
# 1 2 0
# 2 0 2
# 
# Accuracy : 1          
# 95% CI : (0.3976, 1)
# No Information Rate : 0.5        
# P-Value [Acc > NIR] : 0.0625     
# 
# Kappa : 1          
# 
# Mcnemar's Test P-Value : NA         
#                                      
#             Sensitivity : 1.0        
#             Specificity : 1.0        
#          Pos Pred Value : 1.0        
#          Neg Pred Value : 1.0        
#              Prevalence : 0.5        
#          Detection Rate : 0.5        
#    Detection Prevalence : 0.5        
#       Balanced Accuracy : 1.0        
#                                      
#        'Positive' Class : 1 


# 10) 7:3 분할하여 모델 적합 및 예측 재실시

# idx <- sample(1:nrow(data), nrow(data)*0.7)

# 층화랜덤추출 이용: 비율을 고려하여 추출
idx <- createDataPartition(data$Species, p=0.7, list=F)
train <- data[idx,]
test2 <- data[-idx,]
table(train$Species_l)

# 11) 모델 적합하기
model2 <- glm(Species_l~Sepal.Length, data=train, family='binomial')
summary(model2)
# Call:
#   glm(formula = Species_l ~ Sepal.Length, family = "binomial", 
#       data = train)
# 
# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -1.8227  -0.5897  -0.1435   0.4146   2.2385  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   -23.495      5.443  -4.316 1.59e-05 ***
#   Sepal.Length    4.301      1.006   4.274 1.92e-05 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 96.526  on 69  degrees of freedom
# Residual deviance: 49.984  on 68  degrees of freedom
# AIC: 53.984
# 
# Number of Fisher Scoring iterations: 6


# 12) 테스트 데이터 이용 예측
pred2 <- predict(model2, newdata=test2, type="response")
pred2; summary(pred2)
# 8           9          12          13          20          24          27          29          30          37          38 
# 0.097507418 0.005604042 0.038802181 0.038802181 0.150204743 0.150204743 0.097507418 0.224303682 0.024081394 0.558714713 0.061950450 
# 41          42          49          52          54          56          58          59          60          64          65 
# 0.097507418 0.009135486 0.321142921 0.990678536 0.558714713 0.772137310 0.061950450 0.996496706 0.224303682 0.960432010 0.674406484 
# 67          68          76          77          80          88          96          98 
# 0.674406484 0.847180343 0.996496706 0.998688163 0.772137310 0.984840234 0.772137310 0.975435905 
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# 0.005604 0.097507 0.439929 0.471197 0.828420 0.998688 


# 13) 0.5보다 작으면 1(setosa), 아니면 2(versicolor)로 리코딩
result_pred2 <- ifelse(pred2 < 0.5, 1, 2)


# 14) 정확도 비교
(pred2_tbl <- table(result_pred2, test2$Species_l))
# result_pred2  1  2
# 1 12  1
# 2  0 17

confusionMatrix(pred2_tbl)
# Confusion Matrix and Statistics
# 
# 
# result_pred2  1  2
# 1 12  1
# 2  0 17
# 
# Accuracy : 0.9667          
# 95% CI : (0.8278, 0.9992)
# No Information Rate : 0.6             
# P-Value [Acc > NIR] : 4.643e-06       
# 
# Kappa : 0.9315          
# 
# Mcnemar's Test P-Value : 1               
#                                           
#             Sensitivity : 1.0000          
#             Specificity : 0.9444          
#          Pos Pred Value : 0.9231          
#          Neg Pred Value : 1.0000          
#              Prevalence : 0.4000          
#          Detection Rate : 0.4000          
#    Detection Prevalence : 0.4333          
#       Balanced Accuracy : 0.9722          
#                                           
#        'Positive' Class : 1 

