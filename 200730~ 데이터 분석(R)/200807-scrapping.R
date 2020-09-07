library(rvest)
library(dplyr)
library(stringr)


# 1. URL
url_main <- "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=187940&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page="

# 2. HTML scrapping
download.file(url=paste0(url_main,1,""), destfile="data\\bakdu.html", quiet=T)
bakdu_review <- read_html("data\\bakdu.html")

# 3. get data
## 3.1. star_score
star_score <- bakdu_review %>% 
  html_nodes(".score_result")%>% html_nodes(".star_score")%>% 
  html_text()

star_score1 <- str_replace_all(star_score,"\r|\t|\n","")
star_score1

## 3.2. review
review_text <- bakdu_review %>% 
  html_nodes(".score_result")%>% html_nodes(".score_reple")%>% html_node('p') %>% 
  html_text()

review_text
review_text1 <- str_replace_all(review_text,"\r|\t|\n","")
review_text1

## 
page_no <- 2
star_list <- c()
text_list <- c()
for (page in 1:page_no){
  url <- paste0(url_main, page, "")
  fname <- sprintf("backdu_review(%d).html",page)
  download.file(url, fname, quiet=T)
  review_temporary <- read_html(fname)
  
  # 평점
  score <- review_temporary %>% 
    html_nodes(".score_result")%>% html_nodes(".star_score")%>% 
    html_text()
  score1 <- str_replace_all(score,"\r|\t|\n","")
  star_list <- append(star_list, score1)
  
  # 리뷰
  text <- review_temporary %>% 
    html_nodes(".score_result")%>% html_nodes(".score_reple")%>% html_node('p') %>% 
    html_text()
  text1 <- str_replace_all(text,"\r|\t|\n","")
  text1 <- gsub("^관람객","[관람객] ",text1)
  text_list <- append(text_list, text1)
}

star_list
text_list





