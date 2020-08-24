library(arules)
library(arulesViz)
library(dplyr)


## 첫번째

# 1.Adult 데이터셋을 로드하세요
data("Adult")
adult <- Adult


# 2. support 0.5 confidence 0.9로 연관규칙 생성
rules <- apriori(adult, parameter=list(supp=0.5, conf=0.9))
rules; inspect(head(rules,10))


# 3. lift 기준 정렬하여 상위 10개 규칙 확인
rules_lift <- sort(rules, decreasing = T, by="lift")
rules_lift; inspect(head(rules_lift,10))


# 4. 위 결과를 연관어 네트워크 시각화
plot(rules_lift, method="graph")


# 5. 3의 결과를 LHS와 RHS의 빈도수 시각화 표현
plot(rules_lift, method="grouped")





## 두번째

# 1. 데이터 생성
itms <- list(c("삼겹살","생수",'소주','과자'),
             c("삼겹살","생수",'소주','사과'),
             c("장어","생수",'소주','양파'),
             c("땅콩","생수",'맥주','오이'),
             c("땅콩","생수",'맥주','김'))


# 2. 트랜잭션 변환
itms.tr <- as(itms, 'transactions')


# 3. 트랜잭션 확인
inspect(itms.tr)


# 4. 지지도 0.1, 신뢰도 0.8 이상인 연관성 규칙 구하기
it.rules <- apriori(itms.tr, parameter=list(supp=0.1, conf=0.8))


# 5. 결과 검토

# 1) 도출된 규칙 5개 확인
it.rules; inspect(head(it.rules,5))

# 2) 향상도가 1.2이상인 규치만 선택하여 내림차순 정렬 보기
it.rules_lift <- subset(it.rules, lift>=1.2)
it.rules_lift <- sort(it.rules_lift, decreasing=T, by="lift")
inspect(it.rules_lift)

# 3) lhs에 삼겹살이 포함된 연관성 규칙
it.rules_gogi <- subset(it.rules, lhs %pin% '삼겹살')
inspect(it.rules_gogi)

# 4) lhs에 삼겹살과 과자 동시에 포함하는 규칙(%ain%)
it.rules_gogiNbisket <- subset(it.rules, lhs %ain% c('삼겹살', '과자'))
inspect(it.rules_gogiNbisket)

# 5) lhs에 삼겹살 또는 과자 또는 삼겹살&과자 동시 포함 하는 규칙(%oin%)
it.rules_gogiNbisket2 <- subset(it.rules, lhs %oin% c('삼겹살', '과자'))
inspect(it.rules_gogiNbisket2)

# 6) it.rules에 대해 지지도 0.2 이상인 항목의 빈도수 그래프 그리기
it.rules_supp <- subset(it.rules, support>=0.2)
plot(it.rules_supp, method="grouped")


