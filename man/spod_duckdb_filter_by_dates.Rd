% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/duckdb-helpers.R
\name{spod_duckdb_filter_by_dates}
\alias{spod_duckdb_filter_by_dates}
\title{Filter a duckdb conenction by dates}
\usage{
spod_duckdb_filter_by_dates(con, source_view_name, new_view_name, dates)
}
\arguments{
\item{con}{A duckdb connection}

\item{source_view_name}{The name of the source duckdb "view" (the virtual table, in the context of current package likely connected to a folder of CSV files)}

\item{new_view_name}{The name of the new duckdb "view" (the virtual table, in the context of current package likely connected to a folder of CSV files).}

\item{dates}{A \code{character} or \code{Date} vector of dates to process. Kindly keep in mind that v1 and v2 data follow different data collection methodologies and may not be directly comparable. Therefore, do not try to request data from both versions for the same date range. If you need to compare data from both versions, please refer to the respective codebooks and methodology documents. The v1 data covers the period from 2020-02-14 to 2021-05-09, and the v2 data covers the period from 2022-01-01 to the present until further notice. The true dates range is checked against the available data for each version on every function run.

The possible values can be any of the following:
\itemize{
\item For the \code{spod_get()} and \code{spod_convert()} functions, the \code{dates} can be set to "cached_v1" or "cached_v2" to request data from cached (already previously downloaded) v1 (2020-2021) or v2 (2022 onwards) data. In this case, the function will identify and use all data files that have been downloaded and cached locally, (e.g. using an explicit run of \code{spod_download()}, or any data requests made using the \code{spod_get()} or \code{spod_convert()} functions).
\item A single date in ISO (YYYY-MM-DD) or YYYYMMDD format. \code{character} or \code{Date} object.
\item A vector of dates in ISO (YYYY-MM-DD) or YYYYMMDD format. \code{character} or \code{Date} object. Can be any non-consecutive sequence of dates.
\item A date range
\itemize{
\item eigher a \code{character} or \code{Date} object of length 2 with clearly named elements \code{start} and \code{end} in ISO (YYYY-MM-DD) or YYYYMMDD format. E.g. \code{c(start = "2020-02-15", end = "2020-02-17")};
\item or a \code{character} object of the form \code{YYYY-MM-DD_YYYY-MM-DD} or \code{YYYYMMDD_YYYYMMDD}. For example, \verb{2020-02-15_2020-02-17} or \verb{20200215_20200217}.
}
\item A regular expression to match dates in the format \code{YYYYMMDD}. \code{character} object. For example, \verb{^202002} will match all dates in February 2020.
}}
}
\value{
A \code{duckdb} connection with original views and a new filtered view.
}
\description{
IMPORTANT: This function assumes that the table or view that is being filtered has separate \code{year}, \code{month} and \code{day} columns with integer values. This is done so that the filtering is faster on CSV files that are stored in a folder structure with hive-style \verb{/year=2020/month=2/day=14/}.
}
\keyword{internal}
