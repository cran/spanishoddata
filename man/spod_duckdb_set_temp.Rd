% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/duckdb-helpers.R
\name{spod_duckdb_set_temp}
\alias{spod_duckdb_set_temp}
\title{Set temp file for DuckDB connection}
\usage{
spod_duckdb_set_temp(con, temp_path = spod_get_temp_dir())
}
\arguments{
\item{con}{A duckdb connection}

\item{temp_path}{The path to the temp folder for DuckDB for \href{https://duckdb.org/2024/07/09/memory-management.html#intermediate-spilling}{intermediate spilling} in case the set memory limit and/or physical memory of the computer is too low to perform the query. By default this is set to the \code{temp} directory in the data folder defined by SPANISH_OD_DATA_DIR environment variable (set by \code{\link[=spod_set_data_dir]{spod_set_data_dir()}})). Otherwise, for queries on folders of CSV files or parquet files, the temporary path would be set to the current R working directory, which probably is undesirable, as the current working directory can be on a slow storage, or storage that may have limited space, compared to the data folder.}
}
\value{
A \code{duckdb} connection.
}
\description{
Set temp file for DuckDB connection
}
\keyword{internal}
