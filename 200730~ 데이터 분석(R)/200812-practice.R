library(gmodels)

# 1. 교육수준과 흡연율이 관계가 있는지 검정을 실시해보자(data : smoke.csv)
# education 변수 설명 1:대졸 2:고졸 3:중졸
# smoking 변수 설명 1:과다흡연 2:보통 3:비흡연

# 1) 파일 불러오기
data <- read.csv("검정1\\smoke.csv", header=T)
head(data)
summary(data) # NA 없음
str(data)     # 범주형과 비슷한 int
dim(data)

# 2) 코딩 변경
data$education2[data$education==1] <- "1:대졸"
data$education2[data$education==2] <- "2:고졸"
data$education2[data$education==3] <- "3:중졸"
data$smoking2[data$smoking==1] <- "1:과다흡연"
data$smoking2[data$smoking==2] <- "2:보통"
data$smoking2[data$smoking==3] <- "3:비흡연"
data$education2 <- as.factor(data$education2)
data$smoking2 <- as.factor(data$smoking2)

# 3) 교차분석표(CrossTable), 독립성 검정(chisq)
x <- data$education2
y <- data$smoking2
CrossTable(x, y, chisq = T)

# 4) 결과 해석

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  18.91092     d.f. =  4     p =  0.0008182573 

qchisq(1 - 0.05, 4) # 9.487729

# X-squared = 18.91092(df=4) > 9.488이므로 카이제곱분포를 잘 따르지 않음
# 즉, 변인 간 독립성이 잘 드러나지 않음

# 관계가 없다(H0)를 기각할 수 있을 정도로 p가 작음
# 즉, 관계가 있다(H1)




# 2. 나이(age3)와 직위(position)간의 관련성을 독립성 검정(data : cleanData.csv)

# age변수 설명 1: 청년층 2: 중년층 3: 장년층
# position 변수 설명 1: very high 2: high 3: mid 4: low 5: very low

data <- read.csv("검정1\\cleanData.csv", header=T)

data <- data[,c("age3","position")]

summary(data) # position에 NA 9개
data <- na.omit(data)   # data <- subset(data, !is.na(data$position, c("age", "position")))

str(data)     # 범주형과 비슷한 int
dim(data)

table(data)

data$age4[data$age3==1] <- "1: 청년층"
data$age4[data$age3==2] <- "2: 중년층"
data$age4[data$age3==3] <- "3: 장년층"
data$position4[data$position==1] <- "1: very high"
data$position4[data$position==2] <- "2: high"
data$position4[data$position==3] <- "3: mid"
data$position4[data$position==4] <- "4: low"
data$position4[data$position==5] <- "5: very low"

x <- data$age4
y <- data$position4
CrossTable(x, y, chisq = T)

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  287.8957     d.f. =  8     p =  1.548058e-57 

qchisq(1 - 0.05, 8) # 15.50731

# Chi^2 > 15.51이므로 카이제곱분포를 잘 따르지 않으며,
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

data$job1[data$job==1] <- "1: 학생"
data$job1[data$job==2] <- "2: 직장인"
data$job1[data$job==3] <- "3: 주부"
data$response1[data$response==1] <- "1: 무응답"
data$response1[data$response==2] <- "2: 낮음"
data$response1[data$response==3] <- "3: 높음"


x <- data$job1
y <- data$response1
test <- table(x,y)


CrossTable(x,y,chisq = T)

# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  58.2081     d.f. =  4     p =  6.900771e-12 
# 
# Chi^2 > 9.49이므로 카이제곱 분포를 잘 따르지 않음
# 관계가 없다(H0)를 기각할 수 있을 정도로 p가 작음



