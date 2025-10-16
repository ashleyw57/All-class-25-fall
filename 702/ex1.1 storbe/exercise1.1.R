#visualize
ultra <- read.csv("/Users/seventh/Desktop/All class-25 fall/702/ultrarunning.csv")

summary(ultra$pb100k_dec)
hist(ultra$pb100k_dec)
boxplot(ultra$pb100k_dec)

summary(ultra$teique_sf)
hist(ultra$teique_sf)

nrow(ultra)
ultra$exclude <- ifelse( is.na(ultra$teique_sf) |
                          is.na(ultra$pb100k_dec), 1, 0)
ultra$excludeF <- factor(ultra$exclude,
                         levels = c(0,1),
                         labels = c ("included", "excluded"))
View(ultra)
table(ultra$excludeF)

#analyze
class(ultra$pb_surface)
ultra$pb_surfaceF <- factor(ultra$pb_surface, 
                            levels = c(1, 2, 3, 4), 
                            labels = c("trial", "track", "road", "mix"))
table(ultra$pb_surfaceF)

class(ultra$pb_elev)
class(ultra$avg_km)
class(ultra$steu_b)
class(ultra$stem_b)

summary(ultra$steu_b)
summary(ultra$stem_b)
summary(ultra$avg_km)
summary(ultra)

library(tableone)
vars <- c("pb_surfaceF", "pb_elev", "avg_km", "steu_b", "stem_b")
comparsionTable <- CreateTableOne(vars = vars,
                                  strata = "excludeF",
                                  data = ultra,
                                  test = FALSE)
print(comparsionTable, smd = TRUE, missing = TRUE)

#interpret









total_n <- nrow(ultra)

sum(is.na(ultra$teique_sf))
sum(is.na(ultra$pb100k_dec))

analytic <- subset(ultra, !is.na(teique_sf) & !is.na(pb100k_dec))
analytic_n <- nrow(analytic)

removed_n <- total_n - analytic_n

cat("Total sample:", total_n, "\n",
    "Analytic dataset:", analytic_n, "\n",
    "Removed:", removed_n, "\n")


# 定义 included (是否进入分析数据集)
ultra$included <- ifelse(!is.na(ultra$teique_sf) & !is.na(ultra$pb100k_dec), "Included", "Excluded")

# 检查分布
table(ultra$included)

# 生成 Table 1
vars <- c("pb_surface", "pb_elev", "avg_km", "steu_b", "stem_b")

library(tableone)
tab1 <- CreateTableOne(vars = vars, strata = "included", data = ultra, test = FALSE, smd = TRUE)
print(tab1, smd = TRUE)

# 提取 SMD 值
smd_values <- ExtractSmd(tab1)
print(smd_values)


ultra$included <- ifelse(!is.na(ultra$teique_sf) & is.na(ultra$pb100k_dec), 1, 0)
vars <- c("pb_surface", "pb_elev", "avg_km","steu_b","stem_b")
table(ultra$included, useNA = "ifany")
tab1 <- CreateTableOne(vars = vars, strata = "included", data = ultra, test = FALSE, smd = TRUE)
print(tab1, smd = TRUE)


