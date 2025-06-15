## -----------------------------------------------------------------------------
library(spanishoddata)
library(dplyr)
library(stringr)


## -----------------------------------------------------------------------------
od_1000 <- spod_quick_get_od(
  date = "2022-01-01",
  min_trips = 1000
)


## -----------------------------------------------------------------------------
glimpse(od_1000)


## -----------------------------------------------------------------------------
od_1000


## -----------------------------------------------------------------------------
od_long <- spod_quick_get_od(
  date = "2022-01-01",
  min_trips = 0,
  distances = c("10-50km", "50+km")
)


## -----------------------------------------------------------------------------
glimpse(od_long)


## -----------------------------------------------------------------------------
od_long


## -----------------------------------------------------------------------------
municipalities <- spod_quick_get_zones()

# if code above fails, you can also use the following:
# municipalities <- spod_get_zones("muni", ver = 2)
# head(municipalities)


## -----------------------------------------------------------------------------
madrid_muni_ids <- municipalities |>
  filter(str_detect(name, "Madrid")) |>
  pull(id)

madrid_muni_ids


## -----------------------------------------------------------------------------
flows_from_Madrid <- spod_quick_get_od(
  date = "2022-01-01",
  min_trips = 0,
  id_origin = madrid_muni_ids
)


## -----------------------------------------------------------------------------
glimpse(flows_from_Madrid)


## -----------------------------------------------------------------------------
barcelona_muni_ids <- municipalities |>
  filter(str_detect(name, "Barcelona")) |>
  pull(id)
barcelona_muni_ids


## -----------------------------------------------------------------------------
madrid_barcelona_od <- spod_quick_get_od(
  date = "2022-01-01",
  min_trips = 0,
  id_origin = madrid_muni_ids,
  id_destination = barcelona_muni_ids
)


## -----------------------------------------------------------------------------
madrid_barcelona_od

