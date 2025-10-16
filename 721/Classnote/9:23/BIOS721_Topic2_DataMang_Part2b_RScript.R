# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~ BIOS 721 Topic 2 | Data Management in R Part 2b ~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(tidyverse)
library(palmerpenguins)
library(here)


## Creating a new variable in R
# don't write over raw data
iris2 <- iris

iris
# data_frame$new_var_name = whatever value you want
iris2$petal_area <- iris$Petal.Length * iris$Sepal.Width
iris2$petal_area

head(iris2) # new variable always added at the end



# native pipe shortcut: Ctrl + Shift + M


# -----------------------------------------------------------------
# Section 1: magrittr pipes
library(tidyverse)
library(palmerpenguins)
library(here)

pengs <- palmerpenguins::penguins

# Base R
length(unique(pengs$bill_depth_mm))

# magrittr pipes
pengs$bill_depth_mm %>%
  unique() %>%
  length()


# another example
mean(pengs$bill_depth_mm, na.rm = TRUE)

pengs$bill_depth_mm |> mean(na.rm = TRUE)

pengs$bill_depth_mm |> mean(na.rm = TRUE)

# -----------------------------------------------------------------
# Section 2: dplyr package
ICU <- read_csv(here::here("data", "ICU-1.csv"))
# examine the data
tibble::glimpse(ICU)
ICU

# Aside on indexing
# [rows, columns]

ICU[1:4, 1:2] # look at first four rows in first two columns
ICU[, 10:15] # look at all rows, columns 10 to 15
ICU[13:15, ] # look at all columns, last 3 rows


## Back to NAs

# this function provides TRUE/FLASE for each element in the vector
is.na(ICU$SYS)

sum(is.na(ICU$SYS)) # summing logical vectors = number of TRUEs found

# R isn't recognizing -999 as NA, need to set to NA


## Re-coding values to NA & dealing with NAs in general

# base R
ICU$SYS[ICU$SYS == -999] <- NA
ICU$LOC[ICU$LOC == "zzz"] <- NA

sum(is.na(ICU$SYS))
sum(is.na(ICU$LOC))

ICU

# dplyr
ICU2 <- ICU %>%
  mutate(
    SYS2 = na_if(SYS, -999), LOC2 = na_if(LOC, "zzz"),
    new_var = AGE + SER,
  )

ICU2
ICU2$LOC2
ICU2$new_var
names(ICU2)

# say we have multiple missing value indicators
# e.g.: -999, -888, -777 = NA
# set up vector of indicators in na_if() function : na_if(SYS, c(-999, -888, -777))

# readr
ICU3 <- read_csv(here("data", "ICU-1.csv"), na = c("-999", "zzz", "NA"))
ICU3

# NA flag
#if_else(condition, what to do if true, what to do if false)
SYS_new <- if_else(is.na(ICU3$SYS), "Not Taken", "Taken")
SYS_new


# Removing NAs on the fly
na.omit(ICU3)

mean(ICU3$SYS, na.rm = TRUE)

# checking NAs
table(ICU3$LOC, useNA = "ifany")
table(ICU3$SEX, useNA = "always")

# save table results
tab_LOC <- table(ICU3$LOC, useNA = "ifany")

#see distribution of a continuous variable
summary(ICU3$SYS)
summary(ICU3$HRA)
summary(pengs)
## Creating new variables
# base R
ICU$Sev.Score <- ICU$SER + ICU$TYP + (ICU$SYS / 100)

# dplyr
ICU %>% mutate(Sev.Score2 = SER + TYP + (SYS / 100))


# to save our new variable in the tibble save to tibble
ICU2 <- ICU %>% mutate(Sev.Score = SER + TYP + SYS / 100)



# this code will do the exact same thing as the above code
mutate(ICU, Sev.Score = SER + TYP + SYS / 100)






## Common dplyr functions


## Select variables to create a new tibble
new_data <- ICU %>% select(ADM, DIS, SYS)


## Remove columns
ICU %>% select(-ADM, -DIS)


# save for future use
## different symbols, but do the same thing
ICU.small <- ICU %>% select(ADM, DIS)
ICU.small <- ICU |> select(ADM, DIS)






## Select rows conditionally
ICU %>% filter(RAC == "black")

ICU %>% filter(RAC == "white" & AGE > 60) # and
ICU %>% filter(RAC == "white" | AGE < 60) # or


## Reorder your tibble by row values
ICU %>% arrange(AGE)

ICU %>% arrange(CPR, desc(HRA))
ICU %>% arrange(desc(HRA), CPR)


## Group rows to perform functions by group
ICU %>% group_by(SEX)







## Stacking functions using %>% pipes
ICU %>%
  group_by(SEX, RAC) %>%
  summarise(mean_age = mean(AGE, na.rm=TRUE), count = n())


# Count function - another way to get counts
ICU |>
  group_by(SEX, RAC) |>
  count()















## Pivot functions

# we need a dataset that has multiple observations per subject to demonstrate these functions

# long to wide data

us_rent_income # explore data in long format, this dataset is included in the tidyr package

wide_dat <- us_rent_income |> pivot_wider(
  names_from = variable,
  values_from = c(estimate, moe)
)

wide_dat




# wide to long data - and dealing with spaces in column names
u5mr <- read_csv(here("Data", "unicef-u5mr.csv")) # keeps space, adds `` symbols around name

u5mr <- read.csv(here("Data", "unicef-u5mr.csv")) # replaces space in column date with a dot


# make sure to use `` around variable names with spaces if read in with read_csv()!
long_dat <- u5mr |>
  pivot_longer(cols = `U5MR 1950`:`U5MR 2015`,
               names_to = "year", values_to = "U5MR")


print(long_dat, n = 100)






# -----------------------------------------------------------------
# Section 3: Create a categorical variable from a continuous one

# base R: character
Age_Grps <- NA
Age_Grps[29 < ICU$AGE & ICU$AGE < 50] <- "30s/40s"
Age_Grps[49 < ICU$AGE & ICU$AGE < 70] <- "50s/60s"
Age_Grps[69 < ICU$AGE & ICU$AGE < 90] <- "70s/80s"
data.frame(ICU$AGE, Age_Grps)


# base R: numeric
Age_Grps2 <- NA
Age_Grps2[29 < ICU$AGE & ICU$AGE < 50] <- 1
Age_Grps2[49 < ICU$AGE & ICU$AGE < 70] <- 2
Age_Grps2[69 < ICU$AGE & ICU$AGE < 90] <- 3

# check your results!
cbind.data.frame(ICU$AGE, Age_Grps, Age_Grps2)









# cut() function
Age.Grps <- cut(ICU$AGE,
  breaks = c(30, 50, 70, 90),
  labels = c("30s/40s", "50s/60s", "70s/80s")
)
data.frame(ICU$AGE, Age.Grps)

# with if_else function
ICU$cat_age <- if_else(ICU$AGE > 30 & ICU$AGE < 50, "30s/40s",
  if_else(ICU$AGE >= 50 & ICU$AGE < 70, "50s/60s",
    if_else(ICU$AGE >= 70, "70s/80s", NA)
  )
)








# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Refresh environment
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rm(list=ls()) #clears out R space

library(readr)
library(dplyr)

setwd("C:/Users/ba124/Box/BIOS 721/2025/Lectures/Topic 2 Data Management/Data/")


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~ Combining and Transforming Data Sets ~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Motivating Example:
# In this set of lecture slides, we will be working
# with a set of toy data sets to illustrate methods
# of combining data sets in R. Each toy data set
# will have the following variables:
# (1) Country = Country observation comes from
# (2) Year    = Year observation recorded
# (3) Y_cont  = Continuous response of interest
# (4) Y_bin   = Binary response of interest
# (5) V1 - V4 = Covariate 1 - 4

# KEY = Country + Year




# Read in the toy data sets from data files:
Data1 <- read_csv("Data1.csv")
Data2 <- read_csv("Data2.csv")
Data3 <- read_csv("Data3.csv")
Data4 <- read_csv("Data4.csv")
Data5 <- read_csv("Data5.csv")
Data6 <- read_csv("Data6.csv")
Data7 <- read_csv("Data7.csv")
Data8 <- read_csv("Data8.csv")
Data9 <- read_csv("Data9.csv")


# --------------------------------------------------

# Concatenation ...

# Example 1| Combine Data1 and Data2 using rbind()
# - Note: Data1 and Data2 have the same variables
#         (same number and same name) but different
#         observations
Data1
Data2

Analysis1 <- rbind(Data1, Data2)
Analysis1


# Example 2| Combine Data1 and Data3 using rbind()
# - Note: Data1 and Data3 have different observations
#         and the same variables, except Data3 is
#         missing the variable V2
Data1
Data3

Analysis2 <- rbind(Data1,Data3)
Analysis2


# Example 3| Combine Data1 and Data3 using bind_rows()
# - Note: Data1 and Data3 have different observations
#         and the same variables, except Data3 is
#         missing the variable V2

# - bind_rows() function is in 'dplyr' package


Data1
Data3

Analysis3 <- bind_rows(Data1,Data3)
Analysis3












# --------------------------------------------------

# Merging

# Example 4| Combine Data1 and Data4 using merge()
# - Note: Data1 and Data4 have the same observations
#         (i.e. key variables) but different variables
Data1
Data4

#merge function syntax:
#merge(x, y, by=,  <options>)

Analysis4 <- merge(Data1, Data4, by=c('Country','Year'))
Analysis4


# What happens if use the wrong key variable?
Analysis4.wrong <- merge(Data1,Data4,
                         by=c('Country'))
Analysis4.wrong



# Example 5| Combine Data1 and Data5 using merge()
# - Note: Data1 and Data5 have different variables
#         but Data5 does not have any observations
#         from Country C
Data1
Data5

Analysis5 <- merge(Data1,Data5,
                   by=c('Country','Year'))
Analysis5

#dplyr inner join
#dplyr method
Analysis5.inner = inner_join(Data1, Data5, by=c('Country','Year'))
Analysis5.inner



# What if we want to keep all observations in
# both data sets?
Analysis5.all <- merge(Data1,Data5,
                       by=c('Country','Year'),
                       all=TRUE)
Analysis5.all



#dplyr method
Analysis5.dall = full_join(Data1, Data5, by=c('Country','Year'))
Analysis5.dall





# Example 6| Combine Data1 and Data6 using merge()
# - Note: Data1 and Data6 have different variables
#         but Data6 has the same observation for
#         each year (i.e. many to one merge)
Data1
Data6

Analysis6 <- merge(Data1,Data6,
                   by=c('Country'))
Analysis6



#dplyr method
Analysis6.dall = left_join(Data1, Data6, by=c('Country'))
Analysis6.dall




# Example 7| Combine Data1 and Data7 using merge()
# - Note: Data1 and Data7 have different variables
#         but the same observations, however the
#         key variables have different names in
#         each data set.
Data1
Data7

Analysis7 <- merge(x = Data1,y = Data7,
                   by.x = c('Country','Year'),
                   by.y = c('Nation','Time'))
Analysis7


#aside with one key variable:
#merge(data1, data2, by.x=ID, by.y=PatID)


#dplyr method
Analysis7.d = inner_join(Data1, Data7,
                         by = c("Country" = "Nation", "Year" = "Time"))
Analysis7.d





# Example 8| Combine Data1 and Data8 using merge()
# - Note: Data1 and Data8 have different variables
#         but the same observations, however the
#         the non-key variables have the same names
Data1
Data8

Analysis8 <- merge(x=Data1,y=Data8,
                   by=c('Country','Year'))
Analysis8


#dplyr method
Analysis8.d = inner_join(Data1, Data8,
                         by = c("Country", "Year"))
Analysis8.d


#aside: colnames - renaming
new_data = Data8 |>
  mutate(er = V1) |>
  select(-V1)

new_data[, 3]







# --------------------------------------------------

# Identifying duplicate entries ...
# - Recall: 'Duplicates' refer to observations with
#            the same key variable value.

# - Data9 has two duplicate entries
Data9

# - Can be easier to work with duplicate entries
#   by creating one key variable
# - Can use the paste() function to create a single
#   key variable from two variables
Data9$key <- paste(Data9$Country, Data9$Year, sep='-')

Data9$key


duplicated(Data9$key)

dup.keys <- Data9$key[duplicated(Data9$key)]
dup.keys




# Example 10| Print observations with duplicate keys
Data9[Data9$key %in% dup.keys,]


#dplyr approach
Data9 |> filter(key %in% dup.keys)


#the really long way
Data9 |> filter(key=="A-2001" | key=="C-2001")









# - Which observations to keep?
#Note: Putting the ! operator in front means "Not Duplicated"
Data9[!duplicated(Data9$key),]

# - Need to do a little more data programming to
#   drop the duplicate keys here ...

#base R approach
temp <- Data9[-which(Data9$key=='A-2001'),]  #don't know which is correct and decide to remove both
temp <- temp[-5,] #remove C-2001 row with all NAs using indexing
temp


#dplyr approach
temp = Data9 |>
  filter(!(key=="A-2001") & !(key=="C-2001" & is.na(V1)))
temp










# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~ Working with Date Variables~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Creating a date variable in R:
# - The as.Date() function turns a character string into
#   a numeric variable that counts the # of days since
#   Jan 1, 1970.

# Example of data after reference:
Char.Date <- '1970-01-06'
Date <- as.Date(Char.Date)

data.frame(Char.Date,Date,as.numeric(Date))
c(mode(Char.Date),mode(Date),mode(as.numeric(Date)))




# Example of data before reference:
Char.Date <- '1969-01-01'
Date <- as.Date(Char.Date)

data.frame(Char.Date,Date,as.numeric(Date))
c(mode(Char.Date),mode(Date),mode(as.numeric(Date)))


as.Date(as.character(date_var))















## --- Convert character variables to Date variables using different date formats --- ##
#read in ICU data
library(tidyverse)
Data <- read_csv(here::here("Data", 'ICU.csv'), na=c("-999", "zzz", NA))
Data


head(Data[,c('ADM','DIS')])

# - Convert them to date vars:

#what happens if you use the wrong date format?
wrong.ADM <- as.Date(Data$ADM,format='%Y-%m-%d')
wrong.ADM

dADM <- as.Date(Data$ADM, format='%m/%d/%Y')
dADM


dDIS <- as.Date(Data$DIS,format='%d-%b-%y')
data.frame(Data$ADM,dADM,Data$DIS,dDIS)

# - Did anything really happen?
data.frame(Data$ADM,as.numeric(dADM),
           Data$DIS,as.numeric(dDIS))



# Once a date is store as a "date" in R, it can be used
# in mathematical calculations
# - Suppose we want to determine each patient's length of
#   stay; should be the number of days between admission
#   date and discharge date.

# - Calculation doesn't work with original (char) vars ...
Len.Stay <- Data$DIS-Data$ADM+1

# - Calculation does work with date vars...
Len.Stay <- dDIS-dADM+1
data.frame(Data$ADM,Data$DIS,Len.Stay)







#Using the lubridate package to make dealing dates earlier
library(lubridate)
Data

#create date variables
ADM.d = mdy(Data$ADM)
ADM.d
class(ADM.d)

DIS.d = dmy(Data$DIS)
DIS.d
class(DIS.d)

DIS.d - ADM.d

#some useful functions
year(ADM.d)
month(ADM.d)
quarter(DIS.d)
week(DIS.d)












# -------------------------------------------------------------------------
# Appendix/Extra

# Note: All of the date variables in the previous examples
#       where correctly read into R because a 4-digit year
#       was used to record the dates in the data file.
# - If a 2-DIGIT YEAR is used, this may not be the case!
# - With 2-digit years, need to be careful about
#   year-cutoff in R!!!

# Example| Working with 2-digit years in R ...
My_BDay <- '8/23/83'
Dads_BDay <- '8/23/60'

as.Date(My_BDay,format='%m/%d/%y')
as.Date(Dads_BDay,format='%m/%d/%y')


# Changing the year-cutoff to correctly read in 2-digit years:
# - Need to use a function to do this; not an option is as.Date()
# - One example is the chng.span() function below:
#   * This function uses the year() function in the lubridate package.
#   * By default, this function sets the cutoff for the 100 year span as 1969 so
#     so that dates are interpreted the same way they are by default in R.
#   * By changing the value 'cutoff' in the function input, you can shift the 100
#     year span to make sure that 2 digit years are interpreted correctly.

# - First, install the lubridate package if you haven't already
#   (if you have installed, leave commented out)
#install.packages('lubridate')
# - Then submit the function chng.span() to the R console:
chng.span <- function(x, cutoff=1969){
  # x = date with 2-digit year
  # cutoff = first year in 100 year span
  require(lubridate)
  m <- year(x) %% 100
  year(x) <- ifelse(m > cutoff %% 100, 1900+m, 2000+m)
  x }

# Then apply the chng.span() function to dates describe above:
# (1) Using cutoff=1969 --> same results as before
#                           - My_BDay interpreted correctly
#                           - Dads_BDay not interpreted correctly
chng.span(as.Date(My_BDay,format='%m/%d/%y'))
chng.span(as.Date(Dads_BDay,format='%m/%d/%y'))

# (2) Using cutoff=1900 --> now both dates are interpreted correctly
#                           - Other cutoffs would have worked, too
chng.span(as.Date(My_BDay,format='%m/%d/%y'),cutoff=1900)
chng.span(as.Date(Dads_BDay,format='%m/%d/%y'),cutoff=1900)




