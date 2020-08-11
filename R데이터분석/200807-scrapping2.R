library(rvest)
library(dplyr)
library(stringr)
library(KoNLP)



make_df <- function(url_main){

  cd <- read_html(paste0(url_main,1,""))
  
  cd_len <- cd %>% html_node("body > div > div > div.score_total > strong > em") %>% 
    html_text()
  cd_len <- gsub(",","",cd_len)
  cd_len <- as.integer(cd_len)
  
  ## 리스트 초기화
  cd_id <- c()
  cd_nick <- c()
  cd_time <- c()
  cd_rating <- c()
  cd_like <- c()
  cd_dislike <- c()
  cd_reserv <- c()  # 관람객 태그 유무(factor: Y/N)
  cd_text <- c()
  
  page_no <- ceiling(cd_len/10)
  for (page in 1:page_no){
    url <- paste0(url_main, page, "")
    temp <- read_html(url)
    
    
    id_and_nick <- temp %>% 
      html_nodes(".score_result .score_reple em:nth-child(1) > a > span") %>% 
      html_text()
    id <- str_extract(id_and_nick, "[A-z|0-9|\\_|\\-]{4}[*]{4}")
    cd_id <- append(cd_id, id)
    nick <- gsub("\\([A-z|0-9|\\_|\\-]{4}[*]{4}\\)","",id_and_nick)
    nick <- ifelse(nick==id_and_nick, NA, nick)
    cd_nick <- append(cd_nick, nick)

    time <- temp %>% 
      html_nodes(".score_result .score_reple em:nth-child(2)") %>% 
      html_text()
    cd_time <- append(cd_time,time)
    
    
    rating <- temp %>%
      html_nodes(".score_result .star_score")%>%
      html_text()
    rating <- str_replace_all(rating,"\r|\t|\n","")
    rating <- as.integer(rating)
    cd_rating <- append(cd_rating, rating)
    
    
    like <- temp %>% 
      html_nodes(".score_result .btn_area ._sympathyButton strong") %>% 
      html_text()
    like <- as.integer(like)
    cd_like <- append(cd_like, like)
    
    
    dislike <- temp %>% 
      html_nodes(".score_result .btn_area ._notSympathyButton strong") %>% 
      html_text()
    dislike <- as.integer(dislike)
    cd_dislike <- append(cd_dislike, dislike)
  
      
    text <- temp %>%
      html_nodes(".score_result")%>% html_nodes(".score_reple")%>% html_node('p') %>%
      html_text()
    text <- str_replace_all(text,"\r|\t|\n","")
    reserv <- c()
    reserv <- append(reserv,
                     ifelse(grepl("^관람객",text),
                            "Y",
                            "N"))
    text <- gsub("^관람객","",text)
    cd_reserv <- append(cd_reserv, reserv)
    cd_text <- append(cd_text, text)  
  
    
    cat(page,"페이지 수행했어요 (",page,"/",page_no,")\n",sep="")
  }
  cd_key <- seq(1,cd_len,by=1)
  
  cd <- data.frame(key=cd_key,
                   id=cd_id,
                   nickname=cd_nick,
                   date=cd_time,
                   rating=cd_rating,
                   like=cd_like,
                   dislike=cd_dislike,
                   text=cd_text,
                   using_naver_reserv=cd_reserv  # 관람객 태그 유무(factor: Y/N)
                   )
  cd$using_naver_reserv <- as.factor(cd$using_naver_reserv)
  cd$date <- strptime(cd$date,'%Y.%m.%d %H:%M')

  return(cd)
}



# 댓글 알바 많기로 유명한
# <조선명탐정: 흡혈괴마의 비밀> = cd
# 2018년 국내 박스오피스 7위
# 관객 수: 2,272,065명
url_main <- "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=165748&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page="
cd <- make_df(url_main)

# <천문: 하늘에 묻는다> = fd
url_main2 <- "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=181381&type=after&onlyActualPointYn=N&onlySpoilerPointYn=N&order=highest&page="
fd <- make_df(url_main2)

# <토이 스토리 4>
url_main3 <- "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=101966&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page="
ts <- make_df(url_main3)

# <리얼>
url_main4 <- "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=137008&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page="
rl <- make_df(url_main4)

# url_main5 <- "https://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=187940&type=after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject=false&page="
# bakdu <- make_df(url_main5)


df_compare <- data.frame(name=c("조선명탐정: 흡혈괴마의 비밀","천문: 하늘에 묻는다","토이 스토리 4","리얼"))

count_no_nick <- function(df){
  no_nick <- df %>% 
    group_by(nickname) %>% 
    summarise(n=n()) %>% 
    filter(is.na(nickname))
  no_nick <- as.numeric(no_nick[1,2])
  return(no_nick)
}

cd_len <- length(cd$key)
fd_len <- length(fd$key)
ts_len <- length(ts$key)
rl_len <- length(rl$key)

cd_no_nick <- count_no_nick(cd)
fd_no_nick <- count_no_nick(fd)
ts_no_nick <- count_no_nick(ts)
rl_no_nick <- count_no_nick(rl)

df_compare$no_nick_rate <- c(cd_no_nick/(cd_no_nick+cd_len),
                             fd_no_nick/(fd_no_nick+fd_len),
                             ts_no_nick/(ts_no_nick+ts_len),
                             rl_no_nick/(rl_no_nick+rl_len))
rm(cd_no_nick,fd_no_nick,ts_no_nick,rl_no_nick)

count_reserv_where10 <- function(df){
  reserv <- df %>%
    group_by(using_naver_reserv, rating) %>% 
    summarise(n=n())
  N_1 <- as.numeric(reserv[1,3]/sum(reserv[c(1:10),3]))
  N_10 <- as.numeric(reserv[10,3]/sum(reserv[c(1:10),3]))
  Y_1 <- as.numeric(reserv[11,3]/sum(reserv[c(11:20),3]))
  Y_10 <- as.numeric(reserv[20,3]/sum(reserv[c(11:20),3]))
  return(c(N_1,N_10,Y_1,Y_10))
}

cd_ratingYN <- count_reserv_where10(cd)
fd_ratingYN <- count_reserv_where10(fd)
ts_ratingYN <- count_reserv_where10(ts)
rl_ratingYN <- count_reserv_where10(rl)

df_compare$rate1_N <- c(cd_ratingYN[1],
                        fd_ratingYN[1],
                        ts_ratingYN[1],
                        rl_ratingYN[1])
df_compare$rate10_N <- c(cd_ratingYN[2],
                        fd_ratingYN[2],
                        ts_ratingYN[2],
                        rl_ratingYN[2])
df_compare$rate1_Y <- c(cd_ratingYN[3],
                        fd_ratingYN[3],
                        ts_ratingYN[3],
                        rl_ratingYN[3])
df_compare$rate10_Y <- c(cd_ratingYN[4],
                        fd_ratingYN[4],
                        ts_ratingYN[4],
                        rl_ratingYN[4])
rm(cd_ratingYN,fd_ratingYN,ts_ratingYN,rl_ratingYN)
df_compare$err1_betweenYN <- (df_compare$rate1_N - df_compare$rate1_Y)/df_compare$rate1_N
df_compare$err10_betweenYN <- (df_compare$rate10_N - df_compare$rate10_Y)/df_compare$rate10_N

gurimgurim <- function(df){
  test <- df %>%
    group_by(using_naver_reserv, rating) %>% 
    summarise(n=n())
  test1 <- test %>% 
    filter(using_naver_reserv=="N")
  test2 <- test %>% 
    filter(using_naver_reserv=="Y")
  test1 <- as.data.frame(test1)
  test2 <- as.data.frame(test2)
  
  par(mfrow=c(1,2), pty="s")
  barplot(test1$n)
  barplot(test2$n)
}

gurimgurim(rl)


test <- cd %>% 
  group_by(id, nickname) %>% 
  mutate(n=n()) %>% 
  filter(n>1)



