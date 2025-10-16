# ---- Load packages ----
library(dplyr)
library(tidyr)
library(palmerpenguins)
library(knitr)

# ---- Load and prepare data ----
data(penguins)

# Remove rows with missing data for cleaner comparison
penguins_clean <- penguins %>%
  filter(!is.na(sex),
         !is.na(bill_length_mm),
         !is.na(bill_depth_mm),
         !is.na(body_mass_g))

# Preview the data
glimpse(penguins_clean)

# ---- Create overall summary ----
overall_summary <- penguins_clean %>%
  summarise(
    species = "Overall",
    N = n(),
    `Bill Length (mm)` = paste0(round(mean(bill_length_mm), 1), " (",
                                round(sd(bill_length_mm), 1), ")"),
    `Bill Depth (mm)` = paste0(round(mean(bill_depth_mm), 1), " (",
                               round(sd(bill_depth_mm), 1), ")"),
    `Body Mass (g)` = paste0(round(mean(body_mass_g), 0), " (",
                             round(sd(body_mass_g), 0), ")"),
    `Female (%)` = paste0(sum(sex == "female"), " (",
                          round(100*sum(sex=="female")/n(), 1), ")"),
    `Male (%)` = paste0(sum(sex == "male"), " (",
                        round(100*sum(sex=="male")/n(), 1), ")")
  )

# ---- Create summary by species ----
summary_by_species <- penguins_clean %>%
  group_by(species) %>%
  summarise(
    N = n(),
    `Bill Length (mm)` = paste0(round(mean(bill_length_mm), 1), " (",
                                round(sd(bill_length_mm), 1), ")"),
    `Bill Depth (mm)` = paste0(round(mean(bill_depth_mm), 1), " (",
                               round(sd(bill_depth_mm), 1), ")"),
    `Body Mass (g)` = paste0(round(mean(body_mass_g), 0), " (",
                             round(sd(body_mass_g), 0), ")"),
    `Female (%)` = paste0(sum(sex == "female"), " (",
                          round(100*sum(sex=="female")/n(), 1), ")"),
    `Male (%)` = paste0(sum(sex == "male"), " (",
                        round(100*sum(sex=="male")/n(), 1), ")"),
    .groups = "drop"
  )

# ---- Combine and transpose ----
summary_stats <- bind_rows(overall_summary, summary_by_species)

# Create column names (species names)
column_names <- c("Variable", summary_stats$species)

# Transpose: make species columns, variables rows
summary_transposed <- summary_stats %>%
  select(-species) %>%
  t() %>%
  as.data.frame() %>%
  tibble::rownames_to_column(var = "Variable")

colnames(summary_transposed) <- column_names

# ---- Create kable table ----
kable_table <- summary_transposed %>%
  kable(caption = "Table 1. Baseline Characteristics by Penguin Species",
        row.names = FALSE)

kable_table
