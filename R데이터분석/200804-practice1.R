library(rJava); library(KoNLP)
library(RColorBrewer); library(wordcloud)
data1 <- readLines(con='data\\jeju.txt', encoding='ANSI')


# 일단 다 빼보자
data2 <- data1
data2 <- gsub("[^A-z가-힣0-9\\t\\r\\n\\v\\f]"," ",data2)
data2 <- gsub("\\^"," ",data2)
data2 <- gsub("\\["," ",data2)
data2 <- gsub("\\]"," ",data2)
data2 <- gsub("\\_"," ",data2)

############################################################

# 1. 사전 정의 전

data3 <- sapply(data2, KoNLP::extractNoun, USE.NAMES = F)
data3 <- unlist(data3)

preRemove <- function(df){
  # # 불용어 테스트
  # txt1 <- readLines("")
  # for (i in 1:length(txt)){
  #   place_re <- gsub(pattern)
  # }
  
  df <- gsub("[0-9]{1,2}월","",df)
  df <- gsub("[0-9]{1,2}일","",df)
  df <- gsub("[0-9]{1,2}시","",df)
  df <- gsub("[0-9]{1,2}분","",df)
  df <- gsub(" ","",df)
  df <- gsub("까지$","",df)
  df <- gsub("들이$","",df)
  df <- gsub("들은$","",df)
  df <- gsub("가$","",df)
  df <- gsub("부터$","",df)
  df <- gsub("어디","",df)
  df <- gsub("시간","",df)
  df <- gsub("관광지","",df)
  df <- gsub("관광","",df)
  df <- gsub("여행","",df)
  df <- gsub("이용","",df)  
  df <- gsub("숙소","",df)
  df <- gsub("일정","",df)
  df <- gsub("코스","",df)
  df <- gsub("경유","",df)
  df <- gsub("추천","",df)
  df <- gsub("도착","",df)
  df <- gsub("하루","",df)
  df <- gsub("출발","",df)
  df <- gsub("산책","",df)
  df <- gsub("위치","",df)
  df <- gsub("드라이브","",df)
  df <- gsub("있습니","",df)
  df <- gsub("가능","",df)
  df <- gsub("사진","",df)
  df <- gsub("하게","",df)
  df <- gsub("전망","",df)
  df <- gsub("해안도로","",df)
  
  # 강력한 변환기
  for (i in 1:length(df)) if (grepl("^제주$",df[i])) df[i] <- ""
  for (i in 1:length(df)) if (grepl("^제주도$",df[i])) df[i] <- ""
  for (i in 1:length(df)) if (grepl("올레",df[i])) df[i] <- "올레길"
  for (i in 1:length(df)) if (grepl("하시",df[i])) df[i] <- ""
  
  for (i in 1:length(df)) if (grepl("애월",df[i])) df[i] <- "애월해안도로"
  for (i in 1:length(df)) if (grepl("협재",df[i])) df[i] <- "협재해수욕장"
  for (i in 1:length(df)) if (grepl("협제",df[i])) df[i] <- "협재해수욕장"
  for (i in 1:length(df)) if (grepl("용머리",df[i])) df[i] <- "용머리해안"
  for (i in 1:length(df)) if (grepl("중문관광단지",df[i])) df[i] <- "중문단지"
  for (i in 1:length(df)) if (grepl("천지연",df[i])) df[i] <- "천지연폭포"
  for (i in 1:length(df)) if (grepl("천제연",df[i])) df[i] <- "천제연폭포"
  for (i in 1:length(df)) if (grepl("정방",df[i])) df[i] <- "정방폭포"

  df <- gsub("^[0-9]{1,20}$","",df) # 숫자 청소기
  df <- gsub("^[가-힣]{1}$","",df)  # 한 글자 청소기
  df <- df[df!= " "]              # 빈 성분 청소기
  df <- df[df!= ""]              # 빈 성분 청소기
  
  return(df)
}

data3 <- preRemove(data3)
View(data3)
View(table(data3))

wdcount <- head(sort(table(data3), decreasing=T),30)

palette <- brewer.pal(8,"Dark2")
wordcloud(names(wdcount),
          freq=wdcount,
          scale=c(5,0.2),
          rot.per=0.25, min.freq=1,
          random.order=F,random.color=T, colors=palette)


p1 <- c("성산일출봉",

        "주상절리",
        
        "한라산",
        "산방산",
        "송악산",
        "산굼부리",       

        "애월",
        "협재",
        "협제", # 오타
        "용머리",
        "용두암",
        "월정리",
        "중문단지",
        "중문관광단지",
        "천지연",
        "천제연",
        "정방",        
        "우도",
        
        "세계자동차박물관",
        "넥슨컴퓨터박물관",
        "이중섭거리",
        "외돌개",
        "쇠소깍",
        "휴애리",
        "비자림",
        
        "해안도로",
        "산책로",
        
        "한림공원",
        "올레길",
        "오설록",
        "전망대",

        "에코랜드",
        "함덕비치랜드",
        "퍼시픽랜드",
        "베니스랜드",
        "메이즈랜드",
        "일출랜드",
        "러브랜드",
        "미니랜드"
)
pp = rep("ncn", time=length(p1))
my_dic <- data.frame(p1,pp,stringsAsFactors = F)

buildDictionary(ext_dic=c("woorimalsam",'insighter', 'sejong'), 
                user_dic = my_dic, replace_usr_dic=F)

ddata3 <- sapply(data2, KoNLP::extractNoun, USE.NAMES = F)
ddata3 <- unlist(ddata3)

ddata3 <- preRemove(ddata3)
View(ddata3)
View(table(ddata3))


wdcount2 <- head(sort(table(ddata3), decreasing=T),30)
palette <- brewer.pal(8,"Dark2")
wordcloud(names(wdcount2),
          freq=wdcount2,
          scale=c(3,0.1),
          rot.per=0.25, min.freq=1,
          random.order=F,random.color=T, colors=palette)

devtools::install_github("lchiffon/wordcloud2")
library(wordcloud2)
wdcount2 <- head(sort(table(ddata3), decreasing=T),50)
wordcloud2(data=wdcount2)
?wordcloud2




