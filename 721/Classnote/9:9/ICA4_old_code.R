## --------------- ##
## setting up data ##
## --------------- ##

rm(list=ls())

library(tidyverse)
library(lubridate)
library(pracma)
library(eeptools)

##-- Patient level data --##
setwd("//vlp-somanlyshr01.dhe.duke.edu/dcri/cpm/projects/CHDI/EnvironmentalAsthma/PEOPLE/Brooke/data")


enc_dat = read_csv("//vlp-somanlyshr01.dhe.duke.edu/dcri/cpm/projects/CHDI/EnvironmentalAsthma/Papers/TemporalFactors/Data/RawData/Encounters.csv" )
outcome_dat = read_csv("//vlp-somanlyshr01.dhe.duke.edu/dcri/cpm/projects/CHDI/EnvironmentalAsthma/Papers/TemporalFactors/Data/RawData/Asthma_outcome.csv" )


#need to merge individual level info from cohort into outcome data, then combine with eco 
enc_dat$Date = as.Date(mdy(enc_dat$contact_date))
enc_dat = enc_dat %>% select(PAT_ID, ENCOUNTERID, Date, instype, BIRTH_DATE2, 
                      SEX, raceeth, ATOPY, obesity, Aler_rhin_conj_ever, Food_aler_ever, Eczema_ever)

pat_dat = left_join(enc_dat, outcome_dat, by="ENCOUNTERID")

pat_dat = pat_dat %>% arrange(PAT_ID, Date) %>% select(PATID, ENCOUNTERID, ENC_TYPE, Date, OUTCOMETIERTYPE, instype,BIRTH_DATE2, SEX, raceeth, ATOPY, obesity, Aler_rhin_conj_ever, Food_aler_ever,Eczema_ever)
pat_dat = pat_dat %>%  filter(Date>="2014-01-01")  %>% select(-ENCOUNTERID, -ENC_TYPE)










##-- Time level data --##

#read in ses data 
ses = read_csv("//vlp-somanlyshr01.dhe.duke.edu/dcri/cpm/projects/CHDI/EnvironmentalAsthma/Papers/TemporalFactors/Data/RawData/Geographical/Old/UniqueAddress_Daterange_SES.csv")
ses = ses %>% select(pat_id, stdt, enddt, SES_Score) #5289 unique pat_id 

#ecological variables 
eco_dat = read_csv("Temp_analytic.csv")

eco_dat = eco_dat %>% select(Date, TempAve, TempMax, TempMin, WindMax, size, count,mean_tempave_3days, mean_windave_3days,
                      flu_count, mean_flu_3days, PM2.5_Ave, Ozone_8h_max, SO2_1h_max, PM2.5_Ave_perday, Ozone_8h_max_perday,
                      SO2_1h_max_perday,  mean_pm25_3days, mean_so2_3days, mean_ozo_3days, Grasses, Trees, Weeds, 
                      mean_grass_3days, mean_tree_3days, mean_weed_3days, mean_precipitation,mean_prec_3days) %>% 
                mutate("PM25_Ave"="PM2.5_Ave", "PM25_Ave_perday"="PM2.5_Ave_perday") %>%
                select(-"PM2.5_Ave", -"PM2.5_Ave_perday")




eco_dat$MinTemp_lag = movavg(eco_dat$TempMin, 2, type=c("s"))
eco_dat$MaxTemp_lag = movavg(eco_dat$TempMax, 2, type=c("s")) 

eco_dat[eco_dat<0] = 0 #set negative to 0 



##-- join data --#
#create dates
dates=NULL
dates = enframe(ymd(seq(from=as.Date("2014-07-01"), to=as.Date("2019-06-30"), by="days")))
dates = dates %>% select(value) %>% rename(Date=value) %>% mutate(fake=1)

#dates and PATID list
j0 = cbind.data.frame(unique(pat_dat$PATID), 1)
colnames(j0) = c("pat_id", "fake")

j1 = full_join(dates, j0, by='fake')
j1 = j1 %>% select(-fake)
j2 = full_join(j1, eco_dat, by='Date') 

#join with patient-level data
j3 = left_join(j2, pat_dat, by=c('Date'='Date', "pat_id"="PATID"))


j4 = j3 %>% arrange(Date) %>% group_by(pat_id) %>% fill(instype, BIRTH_DATE2, SEX,raceeth,ATOPY,obesity,Aler_rhin_conj_ever,Food_aler_ever,Eczema_ever) %>%
            fill(instype, BIRTH_DATE2, SEX,raceeth,ATOPY,obesity,Aler_rhin_conj_ever,Food_aler_ever,Eczema_ever, .direction = "up")

j4 = j4 %>% arrange(pat_id, Date) %>% mutate(BD = as.Date(mdy(BIRTH_DATE2))) %>% 
            mutate(age=round(interval(start= BD, end=Date)/duration(n=1, unit="years"),0)) %>% 
            select(-"BIRTH_DATE2")
  
j4 %>% glimpse()




#save full data 
write.csv(j4, "full_data.csv")



#filter by warm months
dat = j4 %>% filter(month(Date)>3 & month(Date)<10)
write.csv(dat, "warm_data.csv")



#cases
cases = dat %>% filter(asthma_ex==1)

junk = dat %>% filter(year(Date)==2016)

plot(junk$asthma_ex ~ junk$PM2.5)



#data checks
setwd("//vlp-somanlyshr01.dhe.duke.edu/dcri/cpm/projects/CHDI/EnvironmentalAsthma/PEOPLE/Brooke/data")
dat_full = read_csv("full_data.csv")

mini = dat_full %>% select(-OutcomeTierType, -sex, -age, -raceeth, -ins, -atopy, -obesity, -asthma_ex)
mini

write_csv(mini, "test.csv")






#prep for export to SAS 
setwd("//vlp-somanlyshr01.dhe.duke.edu/dcri/cpm/projects/CHDI/EnvironmentalAsthma/PEOPLE/Brooke/data")
warm = read_csv("warm_data.csv")
#glimpse(warm)
warm = warm[,-1]

glimpse(warm)

write.csv(warm, "warm_data.csv")



