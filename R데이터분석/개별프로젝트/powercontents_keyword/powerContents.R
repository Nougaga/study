(load("search_keywords.RData"))

all_list <- read.csv("powercontents_keyword\\powercontents_keyword.csv")
View(all_list)

onepiece <- all_list[grepl("원피스", all_list$키워드),"키워드"]
smartphone <- all_list[grepl("스마트폰", all_list$키워드)|grepl("휴대폰", all_list$키워드),"키워드"]
toeicspeaking <- all_list[grepl("토익스피킹", all_list$키워드),"키워드"]
engineer <- all_list[grepl("기사", all_list$키워드)&all_list$대분류=="교육/취업","키워드"]

url <- "https://ad.search.naver.com/search.naver?where=pwcexpd&"
query
pagingIndex