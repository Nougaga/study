# install.packages("mlbench")
library(mlbench)
data("BostonHousing")
head(BostonHousing)
housing <- lm(medv ~ crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+b+lstat,data = BostonHousing)
summary(housing)
# summary 결과 indus, age는 p-value 값이 매우 높아 유효하지 않은 변수로 판단되나,
# 변수를 그대로 유지한채, 소거법 적용
housing1 <- step(housing,direction = c("both"))
housing1
summary(housing1)
# 소거법 결과 : 3번째 스텝에서 indus와 age를 제외한 결과 확인 가능.
# housing2에 미리 indus와 age를 제외하고 회귀한 결과,
# 첫번째 스텝에서 종료되며, housing1의 결과와 일치한다.
housing2 <- lm(medv ~ crim+zn+chas+nox+rm+dis+rad+tax+ptratio+b+lstat,data = BostonHousing)
housing3 <- step(housing2,direction = c("both"))

### Multicollinearity
library(car)
vif(housing2) # rad와 tax의 vif 값이 5보다 크다.
## 상관관계의 확인
# chas의 데이터 구조가 범주형이므로, 이를 제외한 나머지 변수들간의 상관관계 확인
# 결과 : rad-tax의 상관관계가 0.91로 매우 높아, tax 변수를 제외하기로 결정
y1 <- BostonHousing[c(1:3)]
y2 <- BostonHousing[c(5:14)]
y3 <- data.frame(y1,y2)
cor(y3)
y3
housing4 <- BostonHousing[c(-3,-7,-10)] # 3,7,10번째 indus, age, tax 컬럼 제외
head(housing4) # 전체1개 변수 중, indus, age, tax가 제거 되었다.
head(housing3)
### 재회귀
housing5 <- lm(medv ~.,data = housing4)
housing5
summary(housing5)

#### 잔차도 확인

par(mfrow=c(2,2))
# 선형성(빨간 실선 이 0에 가까운 수평선) & 독립성(특정한 모여있는 패턴이 발견되지 않음)
plot(housing5, which =  1)
# 정규성(직선에 가깝게 잘 모여있음)
plot(housing5, which =  2)
# 등분산성 & 독립성(적절하게 퍼져 있음, 특정 패턴 없음)
plot(housing5, which =  3)
# 극단치
plot(housing5, which =  4)

## 자기상관성 확인

library(lmtest) # 자기상관 진단 패키지 설치 
dwtest(housing5)

summary(housing5)


length(housing5$residuals)

housing5$residuals[c(369,372,373)]

housing5$residuals[c(368,370,371,374)]

boston <- BostonHousing

boston[c(368:374),]

boston2 <- boston[-c(369,372,373),]

## remodelling

housing0 <- lm(medv ~ crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+b+lstat,data = boston2)
housing11 <- step(housing0,direction = c("both"))
housing22 <- lm(medv ~ crim+zn+chas+nox+rm+dis+rad+tax+ptratio+b+lstat,data = boston2)
housing33 <- step(housing22,direction = c("both"))
vif(housing22)

y11 <- boston2[c(1:3)]
y22 <- boston2[c(5:14)]
y33 <- data.frame(y11,y22)
cor(y33)
y33
housing44 <- boston2[c(-3,-7,-10)] # 3,7,10번째 indus, age, tax 컬럼 제외

housing55 <- lm(medv ~.,data = housing44)
housing55
summary(housing55)

dwtest(housing55)

#### 잔차도 확인

par(mfrow=c(2,2))
# 선형성(빨간 실선 이 0에 가까운 수평선) & 독립성(특정한 모여있는 패턴이 발견되지 않음)
plot(housing55, which =  1)
# 정규성(직선에 가깝게 잘 모여있음)
plot(housing55, which =  2)
# 등분산성 & 독립성(적절하게 퍼져 있음, 특정 패턴 없음)
plot(housing55, which =  3)
# 극단치
plot(housing55, which =  4)

boston[c(366,370,371),]

boston[c(365:372),]

library(Hmisc)
Hmisc::rcorr(as.matrix(boston2))

summary(housing55)

### 회귀식
# 학습데이터와 검정데이터 표본 추출
x <- sample(1:nrow(BostonHousing),0.7*nrow(BostonHousing))
length(names(BostonHousing))
training <- BostonHousing[x,]
testing <- BostonHousing[-x,]
training1 <- training[c(-3,-7,-10)]
testing1 <- testing[c(-3,-7,-10)]
reg_model <- lm(medv ~ .,data = training1)

### 예측치 생성
pred <- predict(reg_model,testing1[,-14])
length(pred);length(testing1[,14])
testing1

testing1
result_df <- data.frame(testing1[11], pred)
result_df$diff <- result_df$pred-result_df$medv

plot(result_df$diff)

### 평가
testing2 <- testing1[-3]
cor(pred,testing2)
