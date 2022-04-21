library(dplyr)
library(readr)
library(geographr)
library(sf)

# LTLA & UTLA data -------
ltla21 <- boundaries_ltla21 |>
  mutate(type = "Local Authority", .before = "geometry") |>
  rename(code = ltla21_code, name = ltla21_name) |>
  filter(str_detect(code, "^E"))

# Don't include Counties that have 1-2-1 match with Local Authority
utla21 <- lookup_ltla21_utla21 |>
  distinct(code = utla21_code, name = utla21_name) |>
  mutate(type = "County") |>
  left_join(boundaries_utla21, by = c("code" = "utla21_code")) |>
  select(-utla21_name)

utla21_not_ltla21 <- utla21 |>
  anti_join(ltla21, by = "code")


# MSOA data ------
# Source: https://houseofcommonslibrary.github.io/msoanames/
msoa_names_raw <- read_csv("raw_data/MSOA-Names-1.17.csv")

msoa_names <- msoa_names_raw |>
  select(code = msoa11cd, name = msoa11hclnm) |>
  mutate(type = "MSOA") |>
  left_join(boundaries_msoa11, by = c("code" = "msoa11_code")) |>
  select(-msoa11_name)

combined <- ltla21 |>
  bind_rows(
    utla21_not_ltla21,
    msoa_names
  ) |>
  st_drop_geometry()

combined_sf <- ltla21 |>
  bind_rows(
    utla21,
    msoa_names
  )

# Save ----
combined_sf |>
  saveRDS("clean_data/geography_list_sf.rds")

combined |>
  saveRDS("clean_data/geography_list.rds")
