library(tidyverse)
library(here)
here()
ultra_altered <- read.csv(here::here("702","ex1.1 storbe", "ultrarunning.csv"))
install.packages("ggplot")
ggplot(ultra_altered, aes(x = pb100k_dec) + 
         geom_histogram(aes(y = ..density..),
                        fill = "grey", color = "black")+
         geom_density(color = "red", size = 1.5))

install.packages("momment")