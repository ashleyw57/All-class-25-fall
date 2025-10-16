library(dplyr)
library(palmerpenguins)
library(gtsummary)
library(gt) 

penguins_fix <- penguins
cn <- names(penguins_fix)

if (all(c("bill_len","bill_dep","flipper_len","body_mass") %in% cn)) {
  penguins_fix <- penguins_fix |>
    rename(
      bill_length_mm   = bill_len,
      bill_depth_mm    = bill_dep,
      flipper_length_mm= flipper_len,
      body_mass_g      = body_mass
    )
}

penguins_clean <- penguins_fix |>
  filter(!is.na(sex),
         !is.na(bill_length_mm),
         !is.na(bill_depth_mm),
         !is.na(body_mass_g))
gtsummary_table <- penguins_clean |>
  select(species, bill_length_mm, bill_depth_mm, body_mass_g, sex) |>
  tbl_summary(
    by = species,
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    # 每个变量的小数位（与课堂一致：长度/深度保留1位，体重整数，性别百分比1位）
    digits = list(
      bill_length_mm ~ c(1, 1),
      bill_depth_mm  ~ c(1, 1),
      body_mass_g    ~ c(0, 0),
      sex            ~ c(0, 1)
    ),
    # 变量标签（课堂示例里把列名换成人话）
    label = list(
      bill_length_mm ~ "Bill Length (mm)",
      bill_depth_mm  ~ "Bill Depth (mm)",
      body_mass_g    ~ "Body Mass (g)",
      sex            ~ "Sex"
    )
  ) |>
  add_overall() |>
  add_p() |>
  modify_header(label ~ "**Characteristic**") |>
  bold_labels()

as_gt(gtsummary_table) |> gtsave("Table1_penguins.html")   # 或 .png/.pdf（需安装相应依赖）
# kable 快速表
penguins_clean |> slice_head(n = 10) |> knitr::kable()

# gt 看前10行，更漂亮
penguins_clean |> slice_head(n = 10) |> gt()


pbinom(8, 9, 0.3)

