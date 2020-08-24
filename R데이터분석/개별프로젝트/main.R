

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

# DEFINE -------------------
XML <<- "XML"
JSON <<- "JSON"
TXT <<- "TXT"

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
glaemfdj <- function(RAWDATA){
  RAWDATA=test_res
  data <- fromJSON(RAWDATA)
  
  # 글 제목에 들어있는 키워드 수
  data$items$cnt_kw_t <- str_count(data$items[,"title"], pattern="<b>")
  # 글 본문 요약에 들어있는 키워드 수
  data$items$cnt_kw_d <- str_count(data$items[,"description"], pattern="<b>")
  # 작성일을 data 구조로 변경
  data$items$postdate2 <- as.Date(data$items[,"postdate"],format="%Y%m%d")
  
  # 검색기준일을 data 구조로 변경
  temp <- strsplit(data[["lastBuildDate"]]," ")
  temp <- unlist(temp)
  temp[1] <- gsub(",","",temp[1])
  temp <- paste(temp[2], tf_month(temp[3]), temp[4])
  data[["lastBuildDate2"]] <- as.Date(temp, "%d %m %Y")
  
  # 본문 스크래핑
  for (i in 17:100){
    test_gsub <- data$items[i,"link"]
    test_gsub <- gsub("https://blog.naver.com/","",test_gsub)
    test_gsub <- gsub("[?]","=",test_gsub)
    test_gsub <- strsplit(test_gsub, "=")
    test_gsub <- unlist(test_gsub)
    test_blogId <- test_gsub[1]; test_logNo <- test_gsub[4]
    url_test <- paste("https://blog.naver.com/PostView.nhn?blogId=",test_blogId,"&logNo=",test_logNo,"&redirect=Dlog&widgetTypeCall=true&directAccess=false",sep="")
    html_test <- read_html(url_test)
    
    html_main <- html_test %>% html_node("div.se-main-container") # pc
    if (length(html_main)==0){
      html_main <- html_test %>% html_node("div.se_component_wrap.sect_dsc.__se_component_area")  # mobile
    }
    
    data$items$cnt_kw_m[i] <- str_count(html_main, pattern="원피스")
    data$items$cnt_href_m[i] <- str_count(html_main, pattern="<a href=\"http")
  }
  
  return(data)
}
View(data$items)
url_test
i = 85


### </function> ##########################################




### <script> #############################################

test_res <- get_blogData("원피스", 1, JSON)
write_to_JSON(test_res, "분석용", TXT)

test_res2 <- glaemfdj(test_res)















### </script> ############################################
