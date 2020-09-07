library(PerformanceAnalytics)
library(lmtest)

PerformanceAnalytics::chart.Correlation(as.matrix(bigBlogData))
cat("\n총 ",dim(bigBlogData)[1],"개의 검색 결과를 이용합니다.\n",sep=""); summary(bigBlogData)


row.names(bigBlogData) <- 1:length(bigBlogData$cnt_kw_t)
lm1 <- lm(score~., data=bigBlogData)
summary(lm1)

dwtest(lm1)
par(mfrow=c(2,2))
plot(lm1, which=1)  # 선형성(빨간 실선이 0에 가까운 수평선) & 독립성(특정한 모여있는 패턴이 발견되지 않음)
plot(lm1, which=2)  # 정규성(직선에 가깝게 잘 모여있음)
plot(lm1, which=3)  # 등분산성 & 독립성(적절하게 퍼져 있음, 특정 패턴 없음)
plot(lm1, which=4)  # 극단치




bigBlogData2 <- bigBlogData
row.names(bigBlogData2) <- 1:length(bigBlogData2$cnt_kw_t)
length(bigBlogData2$cnt_kw_t)

bigBlogData2 <- bigBlogData2[-10235,]
row.names(bigBlogData2) <- 1:length(bigBlogData2$cnt_kw_t)
lm2 <- lm(score~., data=bigBlogData2)
summary(lm2)

dwtest(lm2)

par(mfrow=c(2,2))
plot(lm2, which=1)  # 선형성(빨간 실선이 0에 가까운 수평선) & 독립성(특정한 모여있는 패턴이 발견되지 않음)
plot(lm2, which=2)  # 정규성(직선에 가깝게 잘 모여있음)
plot(lm2, which=3)  # 등분산성 & 독립성(적절하게 퍼져 있음, 특정 패턴 없음)
plot(lm2, which=4)  # 극단치




bigBlogData3 <- bigBlogData2
bigBlogData3 <- bigBlogData3[,-2]
row.names(bigBlogData3) <- 1:length(bigBlogData3$cnt_kw_t)
bigBlogData3$daysdiff2 <- bigBlogData3$daysdiff^2
lm3 <- lm(score~., data=bigBlogData3)
summary(lm3)
step3 <- step(lm3, direction = "both")
summary(step3)

dwtest(step3)
par(mfrow=c(2,2))
plot(step3, which=1)  # 선형성(빨간 실선이 0에 가까운 수평선) & 독립성(특정한 모여있는 패턴이 발견되지 않음)
plot(step3, which=2)  # 정규성(직선에 가깝게 잘 모여있음)
plot(step3, which=3)  # 등분산성 & 독립성(적절하게 퍼져 있음, 특정 패턴 없음)
plot(step3, which=4)  # 극단치






# blogData_7years <- get_blogDataSet("7years")
pred <- blogData_7years$items
row.names(pred) <- 1:length(pred$title)
pred$daysdiff2 <- pred$daysdiff^2
pred$score_pred <- predict(step3, pred)
plot(pred$score, pred$score_pred);abline(a=0, b=1, col="red")




blogData_gadi <- tempfunc(blogData_gadi)
pred <- blogData_gadi$items
row.names(pred) <- 1:length(pred$title)
pred$daysdiff2 <- pred$daysdiff^2

pred$score_pred <- predict(step3, pred)
pred$rank_pred <- as.integer(pred$score_pred * blogData_gadi$total)

plot(pred$rank_pred);abline(a=0, b=1, col="red")





