# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~ BIOS 721 Topic 2 | Data Management in R Part 2 ~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# -----------------------------------------------------------------
# Section 1: Getting started

#Option 1 to access files on your computer: Working Directory Method
getwd()
setwd("C:/Users/ba124/Box/BIOS 721/2025/Lectures/Topic 2 Data Management/Data")




#Option 2: Using the here() method (more complex, less coding)
# using the here package
install.packages("here")
library(here)
here::here()


# Brooke's computer example:
here::here("f1", "f2", "f3", "Data", "penguins.csv")

#This function creates a path automatically for a reading function to use



# student example
here::here() # gives a result like "~/username/"
here::here("Duke", "721")


# what does set_here do? *it does not change your here path!
set_here(path="C:/Users/ba124/Box/BIOS 721/2025/Lectures/Topic 2 Data Management/Data")
here()



# -----------------------------------------------------------------
# Section 2: Importing data

# Base R functions for reading in data: I don't recommend these!
# read.csv()
# read.txt()


# read in a .csv file using the working directory
install.packages("readr")
library(readr)

#Option 2:
getwd()
setwd("C:/Users/ba124/Box/BIOS 721/2024/Lectures/Topic 2 Data Management/Data")
dat <- read_csv("penguins.csv")

library(here)
here()
here::here()
set_here(path = "/Users/seventh/Desktop/All class-25 fall")

library(readr)
dat <- read_csv(here("data","penguins.csv"))
head(penguins)

install.packages

#Option 2:
# read in a .csv file using here::here()
dat.h <- read_csv(here::here("Data", "penguins.csv"))





### Aside: writing to csv ###

library(palmerpenguins)
penguins

# base function: write.csv()

# reader package also contains writing functions:
# write_csv(object, "path/filename.csv")

# write out entire path way
write_csv(penguins, "C:/Users/ba124/Box/BIOS 721/2024/Lectures/Topic 2 Data Management/penguins.csv")


# working directory way
getwd() # check
setwd("C:/Users/ba124/Box/BIOS 721/2024/Lectures/Topic 2 Data Management")
write_csv(penguins, "penguins2.csv")


# here::here() way
library(here)
here::here() # check top-level path
# here("sub-folder", "sub-folder", ..., "filename.csv")
## for example: here("BIOS721", "Data", )


write_csv(penguins, here::here("penguins3.csv"))









# -----------------------------------------------------------------
# Section 3: Looking at your data in R
dat # tibbles print 10 rows
head(dat) # prints 6 rows
tail(dat)
print(dat, n = 50) # prints number of rows you ask for

# See specific rows
dat[98:102, ] #indexing!


library(tibble)
tibble::glimpse(dat)








# -----------------------------------------------------------------
# Section 4: Saving and loading R data objects
library(palmerpenguins)
palmerpenguins::penguins


#working directory option:
save(penguins, file = "penguins_test.Rdata")

#here option:
save(penguins, file = (here::here("penguins_test2.Rdata")))


#getting the data back into R
load("penguins_test.Rdata")




# Look out for ------------------------------------------------------------

# formatting/spelling issues:
patid
patID
PatID
pat_ID
pat.id
