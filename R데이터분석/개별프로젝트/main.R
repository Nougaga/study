

### <memo> ###############################################
"
- 광고쟁이 많을 것 같은 키워드: 쇼핑 쪽, 최신 IT기기, 지격증, ...
원피스 / S20 / 토익스피킹(정말 많음), 환경위해관리기사(후기 섞임, 최신 키워드)

- 광고쟁이 적은 키워드: 전공공부
linear regression / bernoulli's equation

- 광고쟁이 그 자체:
상위 노출 / 광고문의




[200824 하던곳]

https://blog.naver.com/PostView.nhn?blogId=koreaxn12&logNo=222062982799&redirect=Dlog&widgetTypeCall=true&directAccess=false

Error in read_xml.raw(raw, encoding = encoding, base_url = base_url, as_html = as_html,  : 
  Excessive depth in document: 256 use XML_PARSE_HUGE option [1]


"





### </memo> ##############################################


### <default_settings> ###################################

# Library ------------------
library(jsonlite)
library(xml2); library(rvest)
library(httr)
library(stringr)
library(dplyr)
library(rJava); library(KoNLP)


# Directory ----------------
setwd("개별프로젝트")
getwd()


# DEFINE ------------------------
XML <<- "XML"
JSON <<- "JSON"
TXT <<- "TXT"


# saved special defines --------------------

# 검색 키워드가 미리 저장되어 있음
load("search_keywords.RData")
# save(ONEPIECE, S20, TOEICSPEAKING, ENGINEER1, LM, BE, ADS1, ADS2, file="search_keywords.RData")

# OBSTACLE1: <U+200B>
load("obstacles.RData")
# save(OBSTACLE1, "obstacles.RData")

# LINE_STICKER1~6: 네이버 블로그 기본 스티커
load("line_stickers.RData")
# save(LINE_STICKER1,LINE_STICKER2,LINE_STICKER3,LINE_STICKER4,LINE_STICKER5,LINE_STICKER6, file="line_stickers.RData")


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
  client_id <- "aQ2Jmueot4FBm2rv1DT2"
  client_secret <- "8LO9jN8EDB"
  response <- httr::GET(url,
                        add_headers("X-Naver-Client-Id"=client_id,
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

# 유의미할 것 같은 데이터로 변환하는 func
glaemfdj <- function(RAWDATA, PATTERN){
  # (kw: keyword, t: title, d: description, m: main-container, p: paragraph, w: word)
  # score       [총검색결과 - (노출순위 - 1)] / 총검색결과
  # postdate2   작성일(날짜 형식으로 변환됨)
  # cnt_kw_t    글 제목에서 키워드 수
  # cnt_kw_d    글 요약에서 키워드 수
  # cnt_kw_m    글 본문에서 키워드 수
  # cnt_href_m  글 본문에서 외부 링크 수
  # cnt_kw_m300 글 본문의 처음 300bytes(글 요약 후보)에서 키워드 수
  # idx_p_m     글 본문에서 키워드가 처음 등장한 문단 위치
  # cnt_p_m     글 본문에서 키워드가 등장한 문단 수
  # emo_w_m     글 본문에서 ^^, ㅎㅎ 수
  # emo_LINE_m  글 본문에서 LINE 스티커 수
  # daysdiff    검색일과 작성일 차이
  
  data <- fromJSON(RAWDATA)
  
  # 점수
  data$items$score <- (data$total - 0:99)/data$total
  
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
    
    data$items$cnt_kw_m[i] <- str_count(html_main, pattern=PATTERN)
    data$items$cnt_href_m[i] <- str_count(html_main, pattern="<a href=\"http")
    
    # 본문 내용
    vec_text <- html_main %>% html_nodes("p") %>% html_text()
    
    vec_text <- vec_text[vec_text!=OBSTACLE1]
    chr_text <- paste(vec_text, collapse=" ")
    chr_text <- gsub("[[:space:]]{2,}","",chr_text)
    chr_text300 <- chr_text
    Encoding(chr_text300) <- "bytes"
    chr_text300 <- substr(chr_text300, 1, 300)
    Encoding(chr_text300) <- "UTF-8"
    data$items$cnt_kw_m300[i] <- str_count(chr_text300, pattern=PATTERN)
    
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
      str_count(chr_img, LINE_STICKER6)
  }
  data$items$daysdiff <- as.numeric(data$lastBuildDate2 - data$items$postdate2)
  
  return(data)
}

View(data$items)

### </function> ##########################################
### <script> #############################################

# test data
RAWDATA <- test_res
PATTERN <- ONEPIECE
i = 1

View(data$items)
write(chr_text,"테스트.txt")
write_html(html_main, "테스트.html")

test_res <- get_blogData(ONEPIECE, 1, JSON)
test_res2 <- glaemfdj(test_res, ONEPIECE)
View(test_res2$items)


### </script> ############################################
