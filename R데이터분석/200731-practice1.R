# Q1
vec1 <- rep('R',5)
vec2 <- seq(1, 10, by=3)
vec3 <- rep(seq(1, 10, by=3), 3)
vec4 <- c(vec2, vec3)
vec_with_seq <- seq(25, -15, by=-5)
vec5 <- vec4[c(seq(1,length(vec4),by=2))]


# Q2
user = data.frame(name=c('최민수','유관순','이순신','김유신','홍길동'),
           age=c(55,45,45,53,15),
           gender=c(1,2,1,1,1),
           job=c('연예인','학생','군인','직장인','무직'),
           sat=c(3,4,2,5,5),
           grade=c('C','C','A','D','A'),
           total=c(44.4, 28.5,43.5,NA,27.1))
user$gender <- as.factor(user$gender)
barplot(table(user$gender), main="gender 빈도")


# Q3
score = data.frame(kor=c(90,85,90),
                   eng=c(70,85,75),
                   mat=c(86,92,88))
# 조건1)
apply(score, 1, max)  # 행
apply(score, 2, max)  # 열
# 조건2)
round(apply(score, 1, mean),2)  # 행
round(apply(score, 2, mean),2)  # 열
