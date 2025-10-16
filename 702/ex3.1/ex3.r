library(tidyverse)
library(here)
here()
here::i_am("Desktop/All class-25 fall/702")
ultra_altered <- read.csv(here::here())
ggplot(ultra_altered, aes(x = pb100k_dec) + 
         geom_histogram(aes(y = ..density..),
                        fill = "grey", color = "black")+
         geom_density(color = "red", size = 1.5))

install.packages("momment")
