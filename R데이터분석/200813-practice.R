# 1. HDTV 판매율을 높이기 위해 프로모션 진행한 결과 기존 구매비율 15% 보다 
# 향상되었는가? (data : hdtv.csv)
# 1: 구매안함 2: 구매

data <- read.csv("검정2\\hdtv.csv", header=T)

dim(data)
str(data)
summary(data) # NA 없음
data$buy2[data$buy==1] <- "1:구매안함"
data$buy2[data$buy==2] <- "2:구매"
data_tbl <- table(data$buy2)

binom.test(c(data_tbl[2],data_tbl[1]), p=0.15, alternative="greater", conf.level=0.95)
# Exact binomial test
# 
# data:  c(data_tbl[2], data_tbl[1])
# number of successes = 10, number of trials = 50, p-value = 0.2089
# alternative hypothesis: true probability of success is greater than 0.15
# 95 percent confidence interval:
#   0.1127216 1.0000000
# sample estimates:
#   probability of success 
# 0.2 
# H1: 기존 구매비율 15%보다 향상되었다.
# H0: 기존 구매비율 15%보다 향상되지 않았다.
# p값이 0.05보다 크므로 유의수준 0.05에서 H0을 기각하기 어렵다.




# 2. 우리나라 전체 중학교 2학년 여학생 평균키가 148.5cm이다. A 중학교 2학년 전체 500명 중
# 10%인 50명을 선정하여 평균신장을 계산하고 평균 신장에 차이가 있는지 규명(data : student_height.csv)

data <- read.csv("검정2\\student_height.csv", header=T)

dim(data)
summary(data) # NA없음
str(data);head(data)

shapiro.test(data$height)
# Shapiro-Wilk normality test
# 
# data:  data$height
# W = 0.88711, p-value = 0.0001853
#---------------------------------------------------------
# Shapiro-Wilk 검정의 귀무가설인 '정규성을 따른다'를 기각할 수 있으므로
# wilcox.test()를 실시한다.


wilcox.test(data$height, mu=148.5, alternative="two.sided", conf.level=0.95)
# Wilcoxon signed rank test with continuity correction
# 
# data:  data$height
# V = 826, p-value = 0.067
# alternative hypothesis: true location is not equal to 148.5
#-------------------------------------------------------------
# 유의수준 0.05 하에 p값이 충분히 크지 못하므로
# 귀무가설을 기각하기 어렵다. 즉, 평균 신장에 차이가 거의 없다.




# 3. 대학 진학한 남학생과 여학생 대상으로 학교에 대한 만족도에 차이가 있는지 검정(data : sample.csv)
# gender 1:남 2:여
# survey 0:불만족 1:만족

data <- read.csv("검정2\\sample.csv", header=T)
head(data); str(data)
summary(data)
data <- data[!is.na(data$score),]

data$gender2[data$gender==1] <- "1:남"
data$gender2[data$gender==2] <- "2:여"
data$survey2[data$survey==0] <- "0:불만족"
data$survey2[data$survey==1] <- "1:만족"

CrossTable(data$gender2, data$survey2, chisq=T)
# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  0.7977941     d.f. =  1     p =  0.3717537 
# 
# Pearson's Chi-squared test with Yates' continuity correction 
# ------------------------------------------------------------
# Chi^2 =  0.5232812     d.f. =  1     p =  0.4694454 
qchisq(1 - 0.05, 1) # 3.84
# Chi^2 > 3.84이므로 카이제곱분포를 따르며(변인 간 독립성이 드러나지 않으며),
# 유의수준 0.05 하에서 p값이 크기 때문에 '관계가 없다'(H0)를 기각하기 어려움




# 4. 두가지 다른 교육방법에 대한 시험성적에 차이가 있는지 검정(method.csv)

data <- read.csv("검정2\\method.csv", header=T)

str(data)
data <- data[!is.na(data$score),]
data <- na.omit(data)
subset1 <- data[data$method==1,]
subset2 <- data[data$method==2,]

summary(subset1);summary(subset2)

var.test(subset1$score, subset2$score, conf.level=0.95)
# F test to compare two variances
# 
# data:  subset1$score and subset2$score
# F = 1.0648, num df = 21, denom df = 34, p-value = 0.8494
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#   0.502791 2.427170
# sample estimates:
#   ratio of variances
# 1.06479
# --------------------------------------------------------------------------
# p값 >> 0.05이므로 유의수준 0.05 하에서 두 집단은 등분산성을 따른다.

t.test(subset1$score, subset2$score, var.equal=T, conf.level = 0.95)
# Two Sample t-test
# 
# data:  subset1$score and subset2$score
# t = -5.6466, df = 55, p-value = 5.946e-07
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -17.369242  -8.269719
# sample estimates:
#   mean of x mean of y 
# 16.40909  29.22857 
# --------------------------------------------------------------------------
# p값 < 0.05이므로 유의수준 0.05 하에서 두 집단은 서로 차이를 보인다.





