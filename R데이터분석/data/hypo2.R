### 1. 중소기업에서 판매란 HDTV 판매율을 높이기 위해 프로모션 진행 결과
###    기존 구매비율보다 15% 향상되었는지를 단계별로 분석 수행하여 검정!

setwd("C:\\r_code\\kame_data\\Part-III")
hdtv <- read.csv("hdtv.csv",header= TRUE)
head(hdtv)
summary(hdtv)
str(hdtv)
# step 1) 코딩 변경
hdtv$buy2[hdtv$buy==1] <- "구매안함"
hdtv$buy2[hdtv$buy==2] <- "구매"
hdtv$buy2
table(hdtv$buy2)

# 이항분포 비율검정 :
# 50명의 고객을 대상으로 프로모션 후,
# 15%의 구매비율이 향상 되었는지를 검정
install.packages("prettyR")
library(prettyR)
freq(hdtv$buy2)
binom.test(c(13,37),p=0.15)
# Exact binomial test
# data:  c(10, 40)
# number of successes = 10, number of trials = 50, p-value = 0.321
# alternative hypothesis: true probability of success is not equal to 0.15
# 95 percent confidence interval:
#   0.1003022 0.3371831
# sample estimates:
#   probability of success 
# 0.2 

## 해석
# p-value > 0.05 이므로 "프로모션 후 15% 구매비율의 향상은 없었다"의 
# 귀무가설을 채택한다.

### 2. 한국의 중학교 2학년 여학생의 평균 신장은 148.5cm이다.
### A 중학교 2학년 여학생 500명 중 10%인 50명을 표본으로 표본평균 신장을
### 계산하고, 모집단의 평균과 차이가 있는지를 검정하라

stheight <- read.csv("student_height.csv",header=TRUE)
head(stheight)
# 결측치 확인
summary(stheight)
# 표본의 평균신장
height <- stheight$height
mean(height)
# 정규분포 검정
shapiro.test(height)
hist(height)
qqnorm(height)
qqline(height,lty=1,col='blue')
# Shapiro-Wilk normality test
# data:  height
# W = 0.88711, p-value = 0.0001853 > 0.05 이므로 정규분포를 따르지 않아
## wilcox test를 실시
help("wilcox.test")
wilcox.test(height, mu=148.5,
            alternative = "two.sided", conf.level = 0.95)
## result of wilcox test
# Wilcoxon signed rank test with continuity correction
# data:  height
# V = 826, p-value = 0.067
# alternative hypothesis: true location is not equal to 148.5
# p-value = 0.067 > 0.05 이므로 표본의 평균이 한국 중학교 2학년 여학생
# 평균 신장 크기와 차이가 없다는 귀무가설을 채택한다.

### 3. 대학에 진학한 남학생과 여학생을 대상으로 진학한 대학에 대해서
### 만족도에 차이가 있는가를 검정하라
satis <- read.csv("two_sample.csv",header = TRUE)
head(satis)
# NA 확인
summary(satis)
# 두집단 데이터 전처리
x <- satis$gender
y <- satis$survey
# 집단별 빈도 분석
table(x)
table(y)
table(x,y)
# 비율차이 검정
prop.test(c(138,107),c(174,126),
          alternative = "two.sided",conf.level = 0.95)
## 테스트 결과
# 2-sample test for equality of proportions with continuity correction
# data:  c(138, 107) out of c(174, 126)
# X-squared = 1.1845, df = 1, p-value = 0.2765
# alternative hypothesis: two.sided
# 95 percent confidence interval:
#   -0.14970179  0.03749599
# sample estimates:
#   prop 1    prop 2 
# 0.7931034 0.8492063 

## 해석
# p-value > 0.05 이므로, 양 집단의 만족도에 차이가 없다는
# 귀무가설을 채택한다.

### 4. 교육방법에 따라 시험성적에 차이가 있는지 검정하라
twomethod <- read.csv("twomethod.csv",header = TRUE)
head(twomethod)
# subset
tmethod <- subset(twomethod, !is.na(score),c(method,score))
summary(tmethod)
# 데이터 분리
a <- subset(tmethod,method==1)
b <- subset(tmethod,method==2)
a1 <- a$score
b1 <- b$score
length(a1) #22
length(b1) #35
mean(a1) #16.41
mean(b1) #29.23
# 동질성 검정
var.test(a1,b1) #p-value=0.85 > 0.05 이므로 두 집단의 분포형태는 동질함
# 두 집단 평균 차이 검정
t.test(a1,b1,alternative = "two.sided",conf.level = 0.95)
## 테스트 결과
# Welch Two Sample t-test
# data:  a1 and b1
# t = -5.6056, df = 43.705, p-value = 1.303e-06
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -17.429294  -8.209667
# sample estimates:
#   mean of x mean of y 
# 16.40909  29.22857 

## 해석 : p-value < 0.05 이므로, 두 교육 방법간의 시험 성적에 차이가 없다는
## 귀무가설을 기각한다. 차이가 있다!
