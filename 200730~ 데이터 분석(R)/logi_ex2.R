########## 예제 mtcars ##########
# mtcars 데이터셋 이용 아래와 같이 작성해보세요 :)

# 1) 데이터 준비
data(mtcars)
data <- mtcars
head(data);str(data);dim(data)

table(data$vs)
data$vs <- as.factor(data$vs)
str(data)

# 2) 8:2 데이터 나누기
idx <- sample(1:nrow(data), nrow(data)*0.8)
train <- data[idx,]
test <- data[-idx,]
head(train);head(test)


# 3) 종속변수 vs, 독립변수 mpg + am로 모형 적합
model <- glm(vs~mpg+am, data=train, family=binomial)
summary(model)
# 
# Call:
#   glm(formula = vs ~ mpg + am, family = binomial, data = train)
# 
# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -2.0105  -0.5470  -0.1424   0.3483   1.5416  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)  
# (Intercept) -10.6280     4.4167  -2.406   0.0161 *
#   mpg           0.5877     0.2489   2.361   0.0182 *
#   am           -2.7742     1.7710  -1.566   0.1172  
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 34.617  on 24  degrees of freedom
# Residual deviance: 16.819  on 22  degrees of freedom
# AIC: 22.819
# 
# Number of Fisher Scoring iterations: 6
# 


# 4) 예측
pred <- predict(model, newdata=test, type="response")
pred; summary(pred)
# Mazda RX4 Hornet 4 Drive        Valiant     Duster 360       Merc 280    Honda Civic  Porsche 914-2 
# 0.431706197    0.937954957    0.185557811    0.001815245    0.479808269    0.999991492    0.997719630 
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# 0.001815 0.308632 0.479808 0.576365 0.967837 0.999992 


# 5) 변수 선택
step <- step(model)


# 6) 결과 비교
result_pred <- ifelse(pred < 0.5, 0, 1)
pred_tbl <- table(result_pred, test$vs)
library(caret)
confusionMatrix(pred_tbl)
