

### <memo> ###############################################
"
- 광고쟁이 많을 것 같은 키워드: 쇼핑 쪽, 최신 IT기기, 지격증, ...
원피스 / S20 / 토익스피킹(정말 많음), 환경위해관리기사(후기 섞임, 최신 키워드)

- 광고쟁이 적은 키워드: 전공공부
linear regression / bernoulli's equation

- 광고쟁이 그 자체:
상위 노출 / 광고문의




daysdiff는 다항회귀를 시도


"

### </memo> ##############################################


### <default_settings> ###################################

# Library ------------------
library(jsonlite)
library(xml2); library(rvest)
library(httr)
library(stringr)
library(dplyr)
# library(rJava); library(KoNLP)

library(Hmisc); library(corrgram)
library(ggplot2);library(wesanderson)


# Directory ----------------
setwd("개별프로젝트")
getwd()


# DEFINE ------------------------
XML <<- "XML"
JSON <<- "JSON"
TXT <<- "TXT"

ONEPIECE <<- "원피스"
JEANJACKET <<- "청자켓"
ENGINEER1 <<- "환경위해관리기사"
ENGINEER2 <<- "전기기사"
CORONA <<- "코로나"
PEST <<- "흑사병"
MOMOLAND <<- "모모랜드"
BFMV <<- "불릿포마이발렌타인"
S20 <<- "S20"
MCSQ <<- "엠씨스퀘어"
PYTHON <<- "파이썬"
COBOL <<- "COBOL"
DOGCAFE <<- "애견카페"
HOTELWITHANIMAL <<- "동물동반호텔"
NEWTON <<- "뉴턴"
LANGMUIR <<- "랭뮤어"
AMONGUS <<- "어몽어스"
FLASHGAME <<- "플래시게임"
GREENREVIEW <<- "그린리뷰"
ADSCONTACT <<- "광고문의"

client_id <- "aQ2Jmueot4FBm2rv1DT2"
client_secret <- "8LO9jN8EDB"

# saved special defines --------------------

# OBSTACLE1: <U+200B>
load("obstacles.RData")
# save(OBSTACLE1, "obstacles.RData")

# LINE_STICKER1~12: 네이버 블로그 기본 스티커
load("line_stickers.RData")
# save(LINE_STICKER1,LINE_STICKER2,LINE_STICKER3,LINE_STICKER4,LINE_STICKER5,LINE_STICKER6, LINE_STICKER7, LINE_STICKER8, LINE_STICKER9, LINE_STICKER10, LINE_STICKER11, LINE_STICKER12, file="line_stickers.RData")
### </default_settings> ##################################



### <function> ###########################################

# 검색 > 블로그 API function
get_blogData <- function(WORD, START_PAGE, TYPE){
  
  if(require(httr)){
    # nothing
  }else{
    install.packages("httr")
    library(httr)
  }
  
  url <- "https://openapi.naver.com/v1/search/blog."
  if (TYPE=="XML") url <- paste(url, "xml?", sep="")
  else if (TYPE=="JSON") url <- paste(url, "json?", sep="")
  else {
    print("TypeError: Content-type must be XML or JSON.")
    return(0)
  }
  
  param_query <- paste("query=",WORD, sep="")
  param_query <- URLencode(iconv(param_query, to="UTF-8"))
  
  n <- as.character(1 + 100*(START_PAGE-1))
  param_rest <- paste("&display=100&start=",n,"&sort=sim",sep="")
  
  url <- paste(url, param_query, param_rest, sep="")
  response <- httr::GET(url, add_headers("X-Naver-Client-Id"=client_id,
                                         "X-Naver-Client-Secret"=client_secret))
  rescode <- rawToChar(response$content)
  Encoding(rescode) <- "UTF-8"
  
  return(rescode)
}

# 읽을 수 있는 UTF-8로 export하는 function
write_to_JSON <- function(DATA, NAME, TYPE="JSON"){
  res <- DATA
  Encoding(res) <- "utf-8"
  write(res, file=paste(NAME, TYPE, sep="."))
}

# 통합 검색어 트렌드 API function(미완)
get_trends <- function(){
  client_id = "vZxO6yNeNaA70MFNMocw"
  client_secret = "0esAHFjxAF"
  url = "https://openapi.naver.com/v1/datalab/search?"
}

# 월 수동변환 function
tf_month <- function(MONTH) {
  switch (MONTH,
          'Jan'="01",
          'Feb'="02",
          'Mar'="03",
          'Apr'="04",
          'May'="05",
          'Jun'="06",
          'Jul'="07",
          'Aug'="08",
          'Sep'="09",
          'Oct'="10",
          'Nov'="11",
          'Dec'="12",
  )
}

# 본문 스크래핑 후 유의미할 것 같은 데이터로 변환하는 func
get_blogDataContents <- function(RAWDATA, PATTERN){
  # (kw: keyword, t: title, d: description, m: main-container, p: paragraph, w: word)
  # postdate2   작성일(날짜 형식으로 변환됨)
  # cnt_kw_t    글 제목에서 키워드 수
  # cnt_kw_d    글 요약에서 키워드 수
  # cnt_kw_m    글 본문에서 키워드 수
  # cnt_href_m  글 본문에서 외부 링크 수
  # idx_p_m     글 본문에서 키워드가 처음 등장한 문단 위치
  # cnt_p_m     글 본문에서 키워드가 등장한 문단 수
  # emo_w_m     글 본문에서 ^^, ㅎㅎ 수
  # emo_LINE_m  글 본문에서 LINE 스티커 수
  # daysdiff    검색일과 작성일 차이
  
  data <- fromJSON(RAWDATA)
  ?rep
  # 추가될 열을 0으로 초기화
  data$items$postdate2 <- rep(0)
  data$items$cnt_kw_t <- rep(0)
  data$items$cnt_kw_d <- rep(0)
  data$items$cnt_kw_m <- rep(0)
  data$items$cnt_href_m <- rep(0)
  data$items$idx_p_m <- rep(0)
  data$items$cnt_p_m <- rep(0)
  data$items$emo_w_m <- rep(0)
  data$items$emo_LINE_m <- rep(0)
  data$items$daysdiff <- rep(0)
  
  # 작성일을 data 구조로 변경
  data$items$postdate2 <- as.Date(data$items[,"postdate"],format="%Y%m%d")

  # 글 제목에 들어있는 키워드 수
  data$items$cnt_kw_t <- str_count(data$items[,"title"], pattern="<b>")
  # 글 본문 요약에 들어있는 키워드 수
  data$items$cnt_kw_d <- str_count(data$items[,"description"], pattern="<b>")

  # 검색기준일을 data 구조로 변경
  temp <- strsplit(data[["lastBuildDate"]]," ")
  temp <- unlist(temp)
  temp[1] <- gsub(",","",temp[1])
  temp <- paste(temp[2], tf_month(temp[3]), temp[4])
  data[["lastBuildDate2"]] <- as.Date(temp, "%d %m %Y")
  rm(temp)
  
  # 본문 스크래핑
  for (i in 1:100){
    test_gsub <- data$items[i,"link"]
    if (!grepl("https://blog.naver.com",test_gsub)){
      next
    }
    
    test_gsub <- gsub("https://blog.naver.com/","",test_gsub)
    test_gsub <- gsub("[?]","=",test_gsub)
    test_gsub <- strsplit(test_gsub, "=")
    test_gsub <- unlist(test_gsub)
    blogId <- test_gsub[1]; logNo <- test_gsub[4]
    rm(test_gsub)
    url_test <- paste("https://blog.naver.com/PostView.nhn?blogId=",blogId,"&logNo=",logNo,"&redirect=Dlog&widgetTypeCall=true&directAccess=false",sep="")
    
    # html 코드 전부
    html_test <- read_html(url_test, options = "HUGE")
    
    # pc/mobile, editer ver.에 따라 container가 다름
    html_main <- html_test %>% html_node("div.se-main-container")
    if (length(html_main)==0){
      html_main <- html_test %>% html_node("div.se_component_wrap.sect_dsc.__se_component_area")
    }
    if (length(html_main)==0){
      html_main <- html_test %>% html_node("div#postViewArea")
    }
    
    vec_text <- html_main %>% html_nodes("p") %>% html_text()
    vec_text <- vec_text[vec_text!=OBSTACLE1]
    vec_text <- gsub(" ","",vec_text)
    chr_text <- paste(vec_text, collapse=" ")
    chr_text <- gsub("[[:space:]]{2,}","",chr_text)
    
    data$items$cnt_kw_m[i] <- str_count(chr_text, pattern=PATTERN)
    data$items$cnt_href_m[i] <- str_count(html_main, pattern="\"link\" : \"http")

    # chr_text300 <- chr_text
    # Encoding(chr_text300) <- "bytes"
    # chr_text300 <- substr(chr_text300, 1, 300)
    # Encoding(chr_text300) <- "UTF-8"
    # data$items$cnt_kw_m300[i] <- str_count(chr_text300, pattern=PATTERN)
    
    vec_text_grep <- grep(PATTERN, vec_text)
    data$items$idx_p_m[i] <- vec_text_grep[1]
    data$items$cnt_p_m[i] <- length(vec_text_grep)
    
    data$items$emo_w_m[i] <- str_count(chr_text,"[?^]{2}") + str_count(chr_text, "ㅎㅎ")
    
    vec_img <- html_main %>% html_nodes("img") %>% html_attr("src")
    chr_img <- paste(vec_img, collapse=" ")
    data$items$emo_LINE_m[i] <- 
      str_count(chr_img, LINE_STICKER1) +
      str_count(chr_img, LINE_STICKER2) +
      str_count(chr_img, LINE_STICKER3) +
      str_count(chr_img, LINE_STICKER4) +
      str_count(chr_img, LINE_STICKER5) +
      str_count(chr_img, LINE_STICKER6)+
      str_count(chr_img, LINE_STICKER7)+
      str_count(chr_img, LINE_STICKER8)+
      str_count(chr_img, LINE_STICKER9)+
      str_count(chr_img, LINE_STICKER10)+
      str_count(chr_img, LINE_STICKER11)+
      str_count(chr_img, LINE_STICKER12)
    
  }
  data$items$daysdiff <- as.numeric(data$lastBuildDate2 - data$items$postdate2)
  
  return(data)
}

get_pwcList <- function(KEYWORDS_LIST){
  df <- data.frame(title=c(),description=c(), bloggername=c(), bloggerlink=c())
  
  for (i in 1:length(KEYWORDS_LIST)){
    query = KEYWORDS_LIST[i]
    url1 <- paste("https://ad.search.naver.com/search.naver?where=pwcexpd&query=",query,"&pagingIndex=1",sep="")
    url1 <- URLencode(iconv(url1, to="UTF-8"))
    
    html1 <- read_html(url1, options = "HUGE")
    # write_html(html1, file="powercontents_keyword\\파워컨텐츠확인.html")
    cnt_res <- html1 %>% html_node("#scl > h2 > span") %>% html_text()
    cnt_res <- str_extract(cnt_res, "[0-9]{1,}건$")
    cnt_res <- gsub("건","",cnt_res)
    cnt_res <- as.integer(cnt_res)  
    cnt_pg <- cnt_res %/% 10
    
    title <- html1 %>% html_nodes("#content > div.section > ol div.inner > a") %>% html_text()
    description <- html1 %>% html_nodes("#content > div.section > ol div.inner > p.ad_dsc") %>% html_text()
    bloggername <- html1 %>% html_nodes("#content > div.section > ol div.inner > p.ad_more > a.lnk_mall") %>% html_text()
    bloggerlink <- html1 %>% html_nodes("#content > div.section > ol div.inner > p.ad_more > a.url") %>% html_text()
    
    df <- rbind(df, data.frame(title=title, description=description, bloggername=bloggername, bloggerlink=bloggerlink))
    
    if (is.na(cnt_pg)){ 
      # nothing
    }
    else if (cnt_pg>1){
      for(pagingIndex in 2:cnt_pg){
        url2 <- paste("https://ad.search.naver.com/search.naver?where=pwcexpd&query=",query,"&pagingIndex=",pagingIndex,sep="")
        url2 <- URLencode(iconv(url2, to="UTF-8"))
        html2 <- read_html(url2, options = "HUGE")
        
        title <- html2 %>% html_nodes("#content > div.section > ol div.inner > a") %>% html_text()
        description <- html2 %>% html_nodes("#content > div.section > ol div.inner > p.ad_dsc") %>% html_text()
        bloggername <- html2 %>% html_nodes("#content > div.section > ol div.inner > p.ad_more > a.lnk_mall") %>% html_text()
        bloggerlink <- html2 %>% html_nodes("#content > div.section > ol div.inner > p.ad_more > a.url") %>% html_text()
        
        df <- rbind(df, data.frame(title=title, description=description, bloggername=bloggername, bloggerlink=bloggerlink))
      }
    }
  }
  
  return (df)
}

get_blogDataSet <- function(KEYWORD){
  cat(1,"API 요청\n")
  blogData <- get_blogData(KEYWORD, 1, JSON)
  cat(1,"데이터 분석\n")
  blogData <- get_blogDataContents(blogData, KEYWORD)
  for (idx in 2:10){
    cat(idx,"API 요청\n")
    rest <- get_blogData(KEYWORD, idx, JSON)
    cat(idx,"데이터 분석\n")
    rest <- get_blogDataContents(rest, KEYWORD)
    blogData$items <- rbind(blogData$items, rest$items)
  }
  blogData$items$score <- (1+blogData$total-1:length(blogData$items$title))/blogData$total
  testtest <- blogData$items[grepl("https://blog.naver.com",blogData$items$bloggerlink),]
  testtest <- testtest[!is.na(testtest$idx_p_m),]
  blogData$items <- testtest
  
  blogData <- blogData[c(-3,-4)]
  
  return(blogData)
}

### </function> ##########################################

### <script> #############################################

csv_pwcList <- read.csv("powercontents_keyword\\powercontents_keyword.csv")

onepiece <- csv_pwcList[grepl("원피스", csv_pwcList$키워드),"키워드"]
smartphone <- csv_pwcList[grepl("스마트폰", csv_pwcList$키워드)|grepl("휴대폰", csv_pwcList$키워드),"키워드"]
toeicspeaking <- csv_pwcList[grepl("토익스피킹", csv_pwcList$키워드),"키워드"]
engineer <- csv_pwcList[grepl("기사", csv_pwcList$키워드)&csv_pwcList$대분류=="교육/취업","키워드"]

pwcList_onepiece <- get_pwcList(onepiece)
pwcList_smartphone <- get_pwcList(smartphone)
pwcList_toeicspeaking <- get_pwcList(toeicspeaking)
pwcList_engineer <- get_pwcList(engineer)

cntTable_onepiece <- table(pwcList_onepiece$bloggerlink)
cntTable_smartphone <- table(pwcList_smartphone$bloggerlink)
cntTable_toeicspeaking <- table(pwcList_toeicspeaking$bloggerlink)
cntTable_engineer <- table(pwcList_engineer$bloggerlink)

?wes_palette

?plot





# blogData_onepiece <- get_blogDataSet(ONEPIECE)
# blogData_jeanjacket <- get_blogDataSet(JEANJACKET)
# blogData_engineer1 <- get_blogDataSet(ENGINEER1)
# blogData_engineer2 <- get_blogDataSet(ENGINEER2)
# blogData_corona <- get_blogDataSet(CORONA)
# blogData_pest <- get_blogDataSet(PEST)
# blogData_momoland <- get_blogDataSet(MOMOLAND)
# blogData_bfmv <- get_blogDataSet(BFMV)
# blogData_s20 <- get_blogDataSet(S20)
# blogData_mcsq <- get_blogDataSet(MCSQ)
# blogData_python <- get_blogDataSet(PYTHON)
# blogData_cobol <- get_blogDataSet(COBOL)
# blogData_dogcafe <- get_blogDataSet(DOGCAFE)
# blogData_hotelwithanimal <- get_blogDataSet(HOTELWITHANIMAL)
# blogData_newton <- get_blogDataSet(NEWTON)
# blogData_langmuir <- get_blogDataSet(LANGMUIR)
# blogData_amongus <- get_blogDataSet(AMONGUS)
# blogData_flashgame <- get_blogDataSet(FLASHGAME)
# blogData_greenreview <- get_blogDataSet(GREENREVIEW)
# blogData_adscontact <- get_blogDataSet(ADSCONTACT)

tempfunc <- function (DATASET){
  DATASET$items$cnt_list <- rep(DATASET$total)
  return(DATASET)
}

blogData_onepiece <- tempfunc(blogData_onepiece)
blogData_jeanjacket <- tempfunc(blogData_jeanjacket)
blogData_engineer1 <- tempfunc(blogData_engineer1)
blogData_engineer2 <- tempfunc(blogData_engineer2)
blogData_corona <- tempfunc(blogData_corona)
blogData_pest <- tempfunc(blogData_pest)
blogData_momoland <- tempfunc(blogData_momoland)
blogData_bfmv <- tempfunc(blogData_bfmv)
blogData_s20 <- tempfunc(blogData_s20)
blogData_mcsq <- tempfunc(blogData_mcsq)
blogData_python <- tempfunc(blogData_python)
blogData_cobol <- tempfunc(blogData_cobol)
blogData_dogcafe <- tempfunc(blogData_dogcafe)
blogData_hotelwithanimal <- tempfunc(blogData_hotelwithanimal)
blogData_newton <- tempfunc(blogData_newton)
blogData_langmuir <- tempfunc(blogData_langmuir)
blogData_amongus <- tempfunc(blogData_amongus)
blogData_flashgame <- tempfunc(blogData_flashgame)
blogData_greenreview <- tempfunc(blogData_greenreview)
blogData_adscontact <- tempfunc(blogData_adscontact)

bigBlogData <- rbind(blogData_onepiece$items,
                     blogData_jeanjacket$items,
                     blogData_engineer1$items,
                     blogData_engineer2$items,
                     blogData_corona$items,
                     blogData_pest$items,
                     blogData_momoland$items,
                     blogData_bfmv$items,
                     blogData_s20$items,
                     blogData_mcsq$items,
                     blogData_python$items,
                     blogData_cobol$items,
                     blogData_dogcafe$items,
                     blogData_hotelwithanimal$items,
                     blogData_newton$items,
                     blogData_langmuir$items,
                     blogData_amongus$items,
                     blogData_flashgame$items,
                     blogData_greenreview$items,
                     blogData_adscontact$items
                     )

bigBlogData <- bigBlogData[,8:length(bigBlogData)]








View(blogData_cobol$items)

blogData_onepiece$items$link[blogData_onepiece$items$idx_p_m>200]


df <- blogData_onepiece$items[,8:length(blogData_onepiece$items)]
dim(df)
summary(df)
head(df,10)
freq <- table(df$idx_p_m)
freq <- freq[1:7]
barplot(freq, ylim = c(0,350), 
        main="키워드가 처음으로 등장하는 문단 위치",
        xlab="등장 위치",
        ylab="블로그 수",
        col=wes_palette(n=7, name="Darjeeling1", type="continuous"))


corrgram::corrgram(as.matrix(df), upper.panel = panel.conf,
                   cex.labels = 1)

?corrgram
test_lm <- lm(score~., data=df)
summary(test_lm)

test_step <- step(test_lm, direction = "both")
summary(lm(score~idx_p_m, data=testData_lm))

View(blogData_onepiece$items)
df[df$cnt_kw_t==2,]
summary(df)
str(df)

blogData_onepiece$items[blogData_onepiece$items$cnt_href_m>10,c(-1,-3,-4,-5,-6,-7)]

### </script> ############################################
