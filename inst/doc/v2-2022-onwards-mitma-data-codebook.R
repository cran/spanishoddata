## -----------------------------------------------------------------------------
spanishoddata::spod_codebook(ver = 2)


## -----------------------------------------------------------------------------
library(spanishoddata)


## -----------------------------------------------------------------------------
districts_v2 <- spod_get_zones("dist", ver = 2)


## -----------------------------------------------------------------------------
municipalities_v2 <- spod_get_zones("muni", ver = 2)


## -----------------------------------------------------------------------------
luas_v2 <- spod_get_zones("lua", ver = 2)


## -----------------------------------------------------------------------------
dates <- c(start = "2022-01-01", end = "2022-01-04")
od_dist <- spod_get(type = "od", zones = "dist", dates = dates)
od_muni <- spod_get(type = "od", zones = "muni", dates = dates)


## -----------------------------------------------------------------------------
library(dplyr)
od_mean_trips_by_ses_over_the_4_days <- od_dist |>
  group_by(date, age, sex, income) |>
  summarise(
    n_trips = sum(n_trips, na.rm = TRUE),
    .groups = "drop") |> 
  group_by(age, sex, income) |>
  summarise(
    daily_mean_n_trips = mean(n_trips, na.rm = TRUE),
    .groups = "drop") |> 
  collect()
od_mean_trips_by_ses_over_the_4_days


## -----------------------------------------------------------------------------
dates <- c(start = "2022-01-01", end = "2022-01-04")
nt_dist <- spod_get(type = "number_of_trips", zones = "dist", dates = dates)


## -----------------------------------------------------------------------------
nt_dist_tbl <- nt_dist |> dplyr::collect()


## -----------------------------------------------------------------------------
dates <- c(start = "2022-01-01", end = "2022-01-04")
os_dist <- spod_get(type = "overnight_stays", zones = "dist", dates = dates)


## -----------------------------------------------------------------------------
os_dist_tbl <- os_dist |> dplyr::collect()

