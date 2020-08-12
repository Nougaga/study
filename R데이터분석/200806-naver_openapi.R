### 네이버 검색 API ###
library(httr)
library(stringr)
library(dplyr)
library(rJava); library(KoNLP)
library(RColorBrewer); library(wordcloud); library(wordcloud2)




get_blogData <- function(STR, n){
    
  # 1. ID/PW 저장
  clientID <- "aQ2Jmueot4FBm2rv1DT2"
  clientPW <- "8LO9jN8EDB"
  
  # 2. 기본 URL
  urlStr <- "https://openapi.naver.com/v1/search/blog.xml?"
  
  # 3. 검색어 설정 및 UTF-8 URL encoding
  searchQuery <- paste("query=",STR,sep="")
  
  # 3-1. UTF-8 encoding
  searchStr <- iconv(searchQuery, to="UTF-8")
  
  # 3-2. URL encoding
  searchStr <- URLencode(searchStr)
  

    # 4. 나머지 요청변수 설정(유사도 정렬)
  start <- as.character(1 + 100*(n-1))
  otherStr <- paste("&display=100&start=",start,"&sort=sim",sep="")
  
  # 5. URL 완성
  reqURL <- paste(urlStr, searchStr, otherStr, sep="")
  
  # httr 패키지가 없을 때 library는 오류내고는 끊고, require는 논리값을 반환하고 지나감
  if(require(httr)){
    print("package exists")
  }else{
    print("need to install httr package")
  }
  
  # 6. httr 패키지(GET() 이용 인증정보 담아 url 호출) library(httr)
  # 7. GET 함수 호출
  apiResult <- httr::GET(reqURL,
                         add_headers("X-Naver-Client-Id"=clientID,
                                     "X-Naver-Client-Secret"=clientPW))
  # 8. 호출결과 확인
  # str(apiResult)
  # apiResult$content
  
  # 9. raw data --> char로 변경
  blogData <- rawToChar(apiResult$content)
  
  # 10. encoding 변경
  Encoding(blogData) <- "UTF-8"
  
  return(blogData)
}

# 함수 저장
save(get_blogData, file="get_blogData.rdata")

rawData = ""


temp <- readLines(con="data\\pork_do.txt", encoding = "UTF-8")
ud <- data.frame(temp,rep("ncn",time=length(temp)),
                 stringsAsFactors = F)
buildDictionary(ext_dic=c("woorimalsam",'insighter', 'sejong'), 
                user_dic=ud, replace_usr_dic=T)
rm(temp)

for (i in 1:10){
  blogData <- get_blogData("돼지고기",i) # 1 ~ 10
  
  copyData <- gsub("<.*?>"," ", blogData)
  
  copyData <- str_extract_all(copyData,"[가-힣]{1,}")
  copyData <- unlist(copyData)
  
  copyData <- paste(copyData, collapse=" ")
  
  copyData <- sapply(copyData, KoNLP::extractNoun, USE.NAMES = F)
  copyData <- unlist(copyData)
  copyData <- copyData[,1]
  
  rawData <- c(rawData, copyData, sep="")
}

head(rawData)

test <- rawData[grepl("^[가-힣]{1}$",rawData)]
test <- table(test)
rm(test)

test1 <- gsub("^[^찜&^밥&^술]{1}$","",rawData)
test1 <- test1[test1!=""]


test2 <- test1
re <- readLines(con="data\\pork_not.txt", encoding = "UTF-8")
for (i in 1:length(re)){
  test2 <- gsub(paste("^",re[i],"$",sep=""),"",test2)
}
test2 <- test2[test2!=""]
# test2 <- test1
# test2 %in% re
# test2.final <- test2[!test2 %in% re]


# Out뭐시기 = c() # 대충 불용어들 들어있음
# nouns %in% Out뭐시기
# nouns.final <- nouns[!nouns %in% Out뭐시기]
# nouns.final


figPath = system.file("examples/t.png",package = "wordcloud2")
wordcloud2(demoFreq, figPath = figPath, size = 1.5,color = "skyblue")
.libPaths()
wordcount = head(sort(table(test2), decreasing=T),100)
letterCloud(data=wordcount,word='R',wordSize=1,fontFamily='나눔바른고딕')
wordcloud2(data=wordcount,
           shape="star",
           # figPath="C:\\Users\\admin\\Desktop\\GitHub\\practice\\R데이터분석\\data\\pig.png",
           fontFamily="Mapo배낭여행",
           size = 0.5, color="Salmon"
           )



########################################################




