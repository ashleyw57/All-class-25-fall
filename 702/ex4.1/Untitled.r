#question1
library(dplyr)

ultra <- read.csv(here::here("data","ultrarunning.csv"))

ultra_clean <- ultra %>% 
  select(pb100k_dec, teique_sf) %>% 
  filter(!is.na(pb100k_dec), !is.na(teique_sf))

ultra_clean <- ultra_clean %>% 
  mutate(intercept = 1)

head(ultra_clean)

#scatterplot
plot(ultra_clean$teique_sf, ultra_clean$pb100k_dec,
     pch = 19, col = "darkgray",
     main = "Personal best 100k times in hour vs Emotional intelligence score",
     xlab = "Emotional intelligence score",
     ylab = "Personal best 100k times")
abline(lm(pb100k_dec ~ teique_sf, 
          data = ultra_clean), col = "blue", lwd = 2)

#matrix
Y <- as.matrix(ultra_clean$pb100k_dec)
X <- as.matrix(ultra_clean[, c("intercept", "teique_sf")])

#caculate beta
Beta <- solve(t(X) %*% X) %*% t(X) %*% Y
Beta

#question2
lm_obj <- lm(pb100k_dec ~ teique_sf, data = ultra_clean)
sum_lm <- summary(lm_obj)
sum_lm

beta_df <- setNames(as.numeric(Beta), c("intercept","teique_sf"))
beta_df
coef(lm_obj)
all.equal(unname(beta_df), unname(coef(lm_obj)))

nm <- names(lm_obj)
nm
length(nm)

lm_obj$coefficients

coef(lm_obj)[["teique_sf"]]
lm_obj$coefficients["teique_sf"]
lm_obj$coefficients[2]

Fitted <- lm_obj$fitted.values
head(Fitted, 5)

all.equal(Fitted, predict(lm_obj))
head(predict(lm_obj), 5)

yhat_auto   <- Fitted[1]
yhat_manual <- 11.03 + 0.71 * 5.73
c (yhat_manual, yhat_auto)

