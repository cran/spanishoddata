## -----------------------------------------------------------------------------
library(spanishoddata)


## -----------------------------------------------------------------------------
dates <- c("2024-03-01")
d_1 <- spod_get(type = "od", zones = "distr", dates = dates)
class(d_1)


## -----------------------------------------------------------------------------
dates_2 <- c(start = "2023-02-14", end = "2023-02-17")
spod_download(type = "od", zones = "distr", dates = dates_2)


## -----------------------------------------------------------------------------
#| echo: false
# Try for v1 data
dates_1 <- c(start = "2020-02-14", end = "2020-02-17")
spod_download(type = "od", zones = "distr", dates = dates_1)


## -----------------------------------------------------------------------------
#| echo: false
db_1 <- spod_convert(type = "od", zones = "distr", dates = "cached_v1", save_format = "duckdb", overwrite = TRUE)
db_1 # check the path to the saved `DuckDB` database


## -----------------------------------------------------------------------------
#| echo: false
# Test adding another day:
fs::file_size(db_1)
dates_1 <- c(start = "2020-02-14", end = "2020-02-2018")
spod_download(type = "od", zones = "distr", dates = dates_1)
db_1 <- spod_convert(type = "od", zones = "distr", dates = "cached_v1", save_format = "duckdb") # no overwrite, failed
db_1 <- spod_convert(type = "od", zones = "distr", dates = "cached_v1", save_format = "duckdb", overwrite = TRUE)
db_1 <- spod_convert(type = "od", zones = "distr", dates = "cached_v1", save_format = "duckdb", overwrite = 'update')
db_1 # check the path to the saved `DuckDB` database


## -----------------------------------------------------------------------------
db_2 <- spod_convert(type = "od", zones = "distr", dates = "cached_v2", save_format = "duckdb", overwrite = TRUE)
db_2 # check the path to the saved `DuckDB` database


## -----------------------------------------------------------------------------
#| echo: false
# Test adding another day:
fs::file_size(db_2)
dates_2 <- c(start = "2020-02-14", end = "2020-02-18")
spod_download(type = "od", zones = "distr", dates = dates_2)
db_2 <- spod_convert(type = "od", zones = "distr", dates = "cached_v2", save_format = "duckdb") # no overwrite, failed
db_2 <- spod_convert(type = "od", zones = "distr", dates = "cached_v2", save_format = "duckdb", overwrite = TRUE)
db_2 <- spod_convert(type = "od", zones = "distr", dates = "cached_v2", save_format = "duckdb", overwrite = 'update')
db_2 # check the path to the saved `DuckDB` database


## -----------------------------------------------------------------------------
#| echo: false
# Test save_path argument:
db_2 <- spod_convert(type = "od", zones = "distr", dates = "cached_v2", save_format = "duckdb", save_path = "/tmp/test.duckdb")


## -----------------------------------------------------------------------------
dates_1 <- c(start = "2020-02-17", end = "2020-02-19")
db_2 <- spod_convert(type = "od", zones = "distr", dates = dates_1, overwrite = TRUE)


## -----------------------------------------------------------------------------
my_od_data_2 <- spod_connect(db_2)


## -----------------------------------------------------------------------------
spod_disconnect(my_od_data_2)


## -----------------------------------------------------------------------------
type <- "od"
zones <- "distr"
dates <- c(start = "2020-02-14", end = "2020-02-17")
od_parquet <- spod_convert(type = type, zones = zones, dates = dates, save_format = "parquet")


## -----------------------------------------------------------------------------
dates <- c(start = "2020-02-16", end = "2020-02-19")
od_parquet <- spod_convert(type = type, zones = zones, dates = dates, save_format = "parquet", overwrite = 'update')


## -----------------------------------------------------------------------------
#| echo: false
# Test for v2 data
dates <- c(start = "2023-02-14", end = "2023-02-17")
od_parquet <- spod_convert(type = type, zones = zones, dates = dates, save_format = "parquet", save_path = file.path(tempdir(), "od_parquet"))


## -----------------------------------------------------------------------------
my_od_data_3 <- spod_connect(od_parquet)


## -----------------------------------------------------------------------------
my_od_data_3 |> 
  dplyr::distinct(date) |>
  dplyr::arrange(date)


## -----------------------------------------------------------------------------
dates_v1 <- spod_get_valid_dates(ver = 1)
dates_v2 <- spod_get_valid_dates(ver = 2)


## -----------------------------------------------------------------------------
type <- "origin-destination"
zones <- "districts"
spod_download(
  type = type,
  zones = zones,
  dates = dates_v1,
  return_local_file_paths = FALSE, # to avoid getting all downloaded file paths printed to console
  max_download_size_gb = 50 # in Gb, this should be well over the actual download size for v1 data
)


## -----------------------------------------------------------------------------
save_format <- "duckdb"

analysis_data_storage <- spod_convert_data(
  type = type,
  zones = zones,
  dates = "cached_v1", # to just convert all data that was previously downloaded, no need to specify dates here
  save_format = save_format,
  overwrite = TRUE
)


## -----------------------------------------------------------------------------
my_data <- spod_connect(
  data_path = analysis_data_storage, 
  max_mem_gb = 16
)


## -----------------------------------------------------------------------------
spod_disconnect(my_data)

