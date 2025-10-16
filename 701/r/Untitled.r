library(knitr)
install.packages("gt")
installed.packages("gtsummary")
library(gt)
library(gtsummary)
library(tidyverse)

pizzaplace

pp_summary <- pizzaplace %>% 
  group_by(type, size) %>% 
  summarize(price_mean = mean(price),
            price_so = sd(price))
pp_summary |> kable()

pizzaplace[1:10, ] |> gt()

pp_summary <- pizzaplace %>% 
  group_by(type, size) %>% 
  summarize(price_man = mean(price),
            price_so = sd(price))
pp_summary |> gt()
pp_summary

pp_summary$size = factor(pp_summary$size, levels = c("S","M","L","XL"))
pp_summary = pp_summary |> arrange(type, size)
pp_summary$price_mean = round(pp_summary$price_mean, 2)
pp_summary$price_SD   = round(pp_summary$price_SD, 2)
colnames(pp_summary)  = c("Type","Size","Mean Price","SD Price")
