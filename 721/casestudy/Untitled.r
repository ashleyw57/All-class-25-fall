library(tidyverse)   # for dplyr, readr, etc.
library(here)        # for reproducible file paths

pats   <- read_csv(here("dem.csv"))     # Patient-level data
cta    <- read_csv(here("cta.csv"))      # CTA test data
echo   <- read_csv(here("echo.csv"))     # Echo test data
endpts <- read_csv(here("endpts.csv"))   # Outcomes / endpoints data

glimpse(pats)
glimpse(cta)
glimpse(echo)
glimpse(endpts)

length(unique(pats$patid))   # Expect: 10,001
length(unique(cta$patid))    # < number of rows
length(unique(echo$patid))

cta_summary <- cta %>%
  group_by(patid) %>%
  summarise(
    max_cac = max(cac_category, na.rm = TRUE),   # ← 用 cac_category 代替 cac_score
    n_cta = n(),
    .groups = "drop"
  )

echo_summary <- echo %>%
  group_by(patid) %>%
  summarise(
    ever_ocad_positive = max(ocad_positive, na.rm = TRUE), # if ever positive
    n_echos = n(),                                         # number of echo tests
    .groups = "drop"
  )

analytic <- pats %>%
  left_join(cta_summary,  by = "patid") %>%
  left_join(echo_summary, by = "patid") %>%
  left_join(endpts,       by = "patid")

analytic <- analytic %>%
  mutate(
    max_cac = replace_na(max_cac, 0),
    max_ocad = replace_na(max_ocad, 0),
    ever_ocad_positive = replace_na(ever_ocad_positive, 0)
  )

# Confirm one row per patient
nrow(analytic)              # should equal number of pats
any(duplicated(analytic$patid))  # should be FALSE

# Check variable summaries
summary(analytic)
glimpse(analytic)

write_csv(analytic, here("analytic_dataset.csv"))

