library(tidyverse)
install.packages("palmerpenguins")
library(palmerpenguins)
palmerpenguins::penguins
data(penguins)
class(penguins)#data.frame
penguins[,2]
class(penguins$island)#factor
print(penguins$bill_depth_mm[5])#19.3

fit1 = lm(flipper_length_mm ~ bill_depth_mm + body_mass_g + sex, data=penguins)
typeof(fit1)#list
print(fit1)
names(fit1)
summary(fit1)
