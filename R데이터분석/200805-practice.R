install.packages("base64enc")
library(base64enc)
library(dplyr)


Sys.setlocale('LC_ALL','C')   # 독일어 깨지는거 방지용

movies <- read.delim2(file="05movielens\\movies.dat",
                     header=F)
movies <- movies[,1]

test <- gsub("::","@@@",movies)
test <- strsplit(test,"@@@")
test <- as.data.frame(test,
                      stringsAsFactors = F)
test <- as.data.frame(t(test),
                      stringsAsFactors = F,
                      row.names=F)
df_m <- test    # 3883개
rm(test)
names(df_m) <- c("movie_id", "title", "genres")
df_m$movie_id <- as.numeric(df_m$movie_id)

###############################################

ratings <- read.table(file="05movielens\\ratings.dat",
                      header=F)
ratings <- ratings[,1]

test <- gsub("::","@@@",ratings)
test <- strsplit(test,"@@@")
test <- as.data.frame(test)
test <- as.data.frame(t(test),
                      stringsAsFactors = F,
                      row.names=F)
df_r <- test
rm(test)
names(df_r) <- c('user_id', 'movie_id', 'rating', 'time_stamp')

df_r$user_id <- as.numeric(df_r$user_id)
df_r$movie_id <- as.numeric(df_r$movie_id)
df_r$rating <- as.numeric(df_r$rating)
df_r$time_stamp <- as.numeric(df_r$time_stamp)

###############################################

users <- read.table(file="05movielens\\users.dat", header=F)
users <- users[,1]

test <- strsplit(users,"::")
test <- as.data.frame(test)
test <- as.data.frame(t(test),
                      stringsAsFactors = F,
                      row.names=F)
df_u <- test
rm(test)
names(df_u) <- c('user_id', 'gender', 'age', 'occupation', 'zip_code')

df_u$user_id <- as.numeric(df_u$user_id)
df_u$gender <- as.factor(df_u$gender)
df_u$age <- as.numeric(df_u$age)
df_u$occupation <- as.numeric(df_u$occupation)

###############################################

rm(movies,ratings,users)
View(df_m)
View(df_r)
View(df_u)

df_ru <- left_join(df_r[,c(1:3)],df_u[,c(1:2)],by="user_id")
df_rum <- left_join(df_ru, df_m[,c(1:2)], by="movie_id")
df_m_count <- as.data.frame(table(df_rum$movie_id), stringsAsFactors=F)
names(df_m_count) <- c("movie_id","rater_count")
df_m_count$movie_id <- as.numeric(df_m_count$movie_id)
df_m_count$rater_count <- as.numeric(df_m_count$rater_count)
df <- left_join(df_rum, df_m_count, by="movie_id")
rm(df_ru,df_m_count,df_rum)

df %>% 
  group_by(gender) %>% 
  summarise(mean_rating = mean(rating))

df %>% 
  group_by(title,gender) %>%
  filter(rater_count >= 100 & gender == "F") %>% 
  summarise(mean_rating = mean(rating)) %>% 
  arrange(desc(mean_rating)) %>% 
  head(20)













