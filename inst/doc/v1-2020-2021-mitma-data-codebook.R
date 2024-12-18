## -----------------------------------------------------------------------------
spanishoddata::spod_codebook(ver = 1)


## -----------------------------------------------------------------------------
library(spanishoddata)


## -----------------------------------------------------------------------------
districts_v1 <- spod_get_zones("dist", ver = 1)


## -----------------------------------------------------------------------------
municipalities_v1 <- spod_get_zones("muni", ver = 1)


## -----------------------------------------------------------------------------
dates <- c(start = "2020-02-14", end = "2020-02-17")
od_dist <- spod_get(type = "od", zones = "dist", dates = dates)
od_muni <- spod_get(type = "od", zones = "muni", dates = dates)


## -----------------------------------------------------------------------------
library(dplyr)
od_mean_hourly_trips_over_the_4_days <- od_dist |>
  group_by(time_slot) |>
  summarise(
    mean_hourly_trips = mean(n_trips, na.rm = TRUE),
    .groups = "drop") |> 
  collect()
od_mean_hourly_trips_over_the_4_days


## -----------------------------------------------------------------------------
dates <- c(start = "2020-02-14", end = "2021-05-09")
nt_dist <- spod_get(type = "number_of_trips", zones = "dist", dates = dates)


## -----------------------------------------------------------------------------
nt_dist_tbl <- nt_dist |> dplyr::collect()

