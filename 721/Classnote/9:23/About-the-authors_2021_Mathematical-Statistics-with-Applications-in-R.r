library(tidyverse)

pat_demo <- read.csv(here::here("data","pat_demo-2.csv"))
pat_comorbid <- read.csv(here("data", "pat_comorbid-2.csv"))
dat <- pat_demo |> left_join(pat_comorbid, by = "PATID")

dat <- dat |> distinct()

dat <- dat |>
  mutate(
    birth_date = parse_date_time(DOB,
                                 orders = c("mdy", "ymd", "dmy", "m/d/y", "Y-m-d")),
    birth_date = if_else(birth_date > today(), birth_date - year(100), birth_date)
  )

dat <- dat |> select(-DOB)

dat |>
  select(PATID, birth_date, race, ethnicity, financialclass,
         hypertension, CHF, diabetes, CKD) |>
  arrange(PATID) 
dat <- as_tibble(dat)
print(dat, n = 10)
