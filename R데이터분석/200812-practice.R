

# 1. 교육수준과 흡연율이 관계가 있는지 검정을 실시해보자(data : smoke.csv)
# education 변수 설명 1:대졸 2:중졸 3:고졸
# smoking 변수 설명 1:과다흡연 2:보통 3:비흡연

data <- read.csv("검정1\\smoke.csv", header=T)
head(data)

summary(data) # NA 없음
str(data)     # 범주형과 비슷한 int
dim(data)

table(data)

x <- data$education
y <- data$smoking
CrossTable(x, y, chisq = T)

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  18.91092     d.f. =  4     p =  0.0008182573 

# 관계가 없다(H0)를 기각할 수 있을 정도로 p가 작음





# 2. 나이(age3)와 직위(position)간의 관련성을 독립성 검정(data : cleanData.csv)

# age변수 설명 1: 청년층 2: 중년층 3: 장년층
# position 변수 설명 1: very high 2: high 3: mid 4: low 5: very low

data <- read.csv("검정1\\cleanData.csv", header=T)

data <- data[,c("age3","position")]

summary(data) # position에 NA 9개
data <- na.omit(data)

str(data)     # 범주형과 비슷한 int
dim(data)

table(data)

x <- data$age3
y <- data$position
CrossTable(x, y, chisq = T)

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  58.2081     d.f. =  4     p =  6.900771e-12 
# 
# 독립적이다(H0)를 기각할 수 있을 정도로 p가 작음




# 3. 직업유형에 따른 응답 정도에 차이가 있는가를 검정(data : response.csv)
# 
# job변수 설명 1: 학생 2: 직장인 3: 주부
# response변수 설명 1: 무응답 2: 낮음 3: 높음

data <- read.csv("검정1\\response.csv", header=T)
head(data)

summary(data) # NA 없음
str(data)     # 범주형과 비슷한 int
dim(data)

table(data)

x <- data$job
y <- data$response
test <- table(x,y)

cy1 = test[,1]  # 무응답
cy2 = test[,2]  # 낮음
cy3 = test[,3]  # 높음
cy_total = apply(test, 1, sum)

CrossTable(x,y,chisq = T)

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  58.2081     d.f. =  4     p =  6.900771e-12 
# 
# 관계가 없다(H0)를 기각할 수 있을 정도로 p가 작음


prop.test(cy1, cy_total, alternative="two.sided", conf.level=0.95)
# prop.test(cy2, cy_total, alternative="two.sided", conf.level=0.95)
prop.test(cy3, cy_total, alternative="two.sided", conf.level=0.95)

# 학생 > 직장인 > 주부 순으로
# 무응답 확률이 높고
# 높은 응답률을 보일 확률이 낮음
# 낮은 응답률은 유의미한 연관성이 발견되지 않음 (p-value = 0.1381 > 0.05이므로 H0을 기각하기 어려움)

