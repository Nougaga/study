.libPaths() # R library 위치

# 도움말 불러내는 방식 2가지
?table
help(table)

'
install.packages()
installed.packages()
data()
str(), class(), mode()
summary()
min(), max(), mean(), median(), sum()
table()
'

data()

iris  # 내장 데이터셋: 붓꽃 데이터
iris_df <- iris
View(iris_df)

# table() 사용 예시
table(iris_df$Species)


'
Vector: data type이 아닌 data structure
데이터의 순서(방향)을 가지는 1차원 구조
'
# c()를 이용한 벡터 생성
vec <- c(1,20,333,4040,55555)
vec1 = c(1,2,3,4,5)

vec
vec[1]      # 인덱스 접근방법: [i] (i는 1 ~ n)
vec[c(2,5)] # 여러 column을 접근할 때 [m,n]은 df[m,n]처럼 2차원 데이터 구조에서의 접근법


# 수열생성 1)콜론
vec1 <- 1:5
vec1

str(vec1)   # structure
class(vec1) # class
mode(vec1)  # storage mode


# 수열생성 2)seq
vec2 <- seq(from=1, to=5, by=1)
vec2
# 기존 변수에 결과를 재할당
vec2 <- vec2+1
vec2

vec3 <- '1' # 문자 할당
vec3 + 1    # Error in vec3 + 1 : 이항연산자에 수치가 아닌 인수입니다


vec4 <- "홍길동"
vec4


vec5 <- c("홍길동", "유관순")
vec5


vec6 <- c(1, "홍길동")
vec6        # 1이 문자형으로 자동변환됨


vec7 <- c(1:100)
summary(vec7)


# 시스템 날짜 확인
Sys.Date()  # "2020-07-30"
Sys.time()  # "2020-07-30 15:33:35 KST"
date()      # "Thu Jul 30 15:33:36 2020"

str('2018/6/16')
str(as.Date('2018/6/16') -> aaa)
aaa -1      # "2018-06-15"
as.Date('17/02/28', '%y/%m/%d')

dt <- c('1-5-17','18-7-20')
dt <- as.Date(dt, '%d-%m-%y') # 국가별 날짜 형식 변환


x <- c(1,3,5,7)
y <- c(3,5)
union(x,y)      # 합집합: [1] 1 3 5 7
intersect(x,y)  # 교집합: [1] 3 5
setdiff(x,y)    # 차집합: [1] 1 7


english <- c(55,80,75,100)
names(english) <- c('Jack', 'Anne','Tom','Hi')
english[3]<-NA  # english['Tom']


num <- 1:100
num
length(num)
num1<-num[1:10]
length(num1)

num2 <- num[c(1:10,91:100,16:25)]
num2
length


num[11:(length(num)/2)]
num[c(2,4)]
num[-c(91:100)]
length(num[-c(91:100)])


# TRUE / FALSE
1 %in% c(1,3,5)
6 %in% c(1,3,5)



# 범주형(factor) 타입
str(iris_df)
View(iris_df)
summary(iris_df)
iris_df$Species <- as.character(iris_df$Species)
iris_df$Species <- as.factor(iris_df$Species)
iris_df$Species


rm(list=ls())



mat <- matrix(1:9, ncol=3)
mat
mat1 <- matrix(1:9, ncol=3, byrow=TRUE)
mat1
mat2 <- matrix(1:9, nrow=3, dimnames=list(c('a1','a2','a3'),c('b1','b2','b3')))
mat2               
dimnames(mat2) <- list(c('aa1','aa2','aa3'),c('bb1','bb2','bb3'))
colnames(mat2) <- c('B1','B2','B3')
mat2

mat3 <- matrix(rep(c('a','b','c'),times=3),ncol=3)
mat4 <- matrix(rep(c('a','b','c'),each=3),ncol=3)
mat3;mat4

mat5 <- matrix(1:6, ncol=2)
mat5
dim(mat5)   # dimension
nrow(mat5);ncol(mat5)
t(mat5)




?apply
m <- matrix(1:9, ncol=3, byrow=TRUE)
m
apply(m,1,max)
apply(m,2,mean)
apply(m,2,min)