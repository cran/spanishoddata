# Codebook and cookbook for v2 (2022 onwards) Spanish mobility data


You can view this vignette any time by running:

``` r
spanishoddata::spod_codebook(ver = 2)
```

The mobility data v2 (2022 onwards) was originally released by the
Ministerio de Transportes, Movilidad y Agenda Urbana (MITMA) , now
[Ministerio de Transportes y Movilidad Sostenible
(MITMS)](https://www.transportes.gob.es/) (MITMS 2024).

The dataset is produced by
<a href="https://www.nommon.es/" target="_blank">Nommon</a> using the
raw data from
<a href="https://www.orange.es/" target="_blank">Orange España</a>. Even
though the raw data is only from one mobile phone operator, the
resulting flows and other counts of number of individuals in the data
set are already resampled to be representative of the total population
of Spain (see details in the official methodology).

The tables in the data set provide hourly flows between zones across
Spain for every day of the observation period (2022-01-01 onwards), the
number of individuals making trips for each zone, the number of
individuals spending the nights in one location while regularly residing
in a different location, and many more advanced datasets. This document
will introduce you to the available data and provide brief code snippets
on how to access it using the `{spanishoddata}` R package.

Compared to the [v1 data
(2020-2021)](v1-2020-2021-mitma-data-codebook.qmd) this dataset has many
additional variables, such as age, sex, and income, has better spatial
resolution (the zones are more spatially granular) and covers a
continuous period[1] (2022-01-01 onward), rather than only a limited
period (in v1 - 2020-02-14 to 2021-05-09).

> **Warning**
>
> Due to mobile network outages, the data on certain dates is missing.
> Kindly keep this in mind when calculating mean monthly or weekly
> flows.
>
>   
>
> Please check the <a
> href="https://www.transportes.gob.es/ministerio/proyectos-singulares/estudios-de-movilidad-con-big-data/opendata-movilidad"
> target="_blank">original data page</a> for currently known missing
> dates. At the time of writing, the following dates are missing: 26,
> 27, 30, 31 October; 1, 2 and 3 November 2023; 4, 18, 19 April 2024, 10
> and 11 November 2024. You can use `spod_get_valid_dates()` function to
> get all available dates.

In v2 data, the datasets comparable to the [v1 (2020-2021)
data](v1-2020-2021-mitma-data-codebook.qmd) (hourly daily origin
destination matrices and number of trips at each location) are called <a
href="https://www.transportes.gob.es/ministerio/proyectos-singulares/estudios-de-movilidad-con-big-data/estudio-basico-diario"
target="_blank">“basic studies” (“estudios basicos”)</a>, however there
are even more advanced datasets that are already available or will be
made available soon: <a
href="https://www.transportes.gob.es/ministerio/proyectos-singulares/estudios-de-movilidad-con-big-data/estudios-completos"
target="_blank">“complete studies” (“estudios completos”)</a> and <a
href="https://www.transportes.gob.es/ministerio/proyectos-singulares/estudios-de-movilidad-con-big-data/rutas-por-carretera"
target="_blank">“road routes” (“rutas de carretera”)</a>. At the moment,
the `{spanishoddata}` package only provides the interface to the “basic
studies” datasets, but support for “complete studies” and “road routes”
will be added in the future.

Key sources for this codebook/cookbook include:

-   <a
    href="https://www.transportes.gob.es/recursos_mfom/paginabasica/recursos/a3_informe_metodologico_estudio_movilidad_mitms_v8.pdf"
    target="_blank">original data collection methodology and codebook in
    Spanish</a> + <a
    href="https://rOpenSpain.github.io/spanishoddata/codebooks/a3_informe_metodologico_estudio_movilidad_mitms_v8_en.pdf"
    target="_blank">automatically translated English version of methodology
    and codebook</a>

-   <a
    href="https://www.transportes.gob.es/recursos_mfom/paginabasica/recursos/20241024_validaciones_estudios_basicos_bigdata_v1.0.pdf"
    target="_blank">original quality assessment</a> + <a
    href="https://rOpenSpain.github.io/spanishoddata/codebooks/20241024_validaciones_estudios_basicos_bigdata_v1.0_en.pdf"
    target="_blank">automatically translated English version of quality
    assessment</a>

-   <a
    href="https://www.transportes.gob.es/ministerio/proyectos-singulares/estudios-de-movilidad-con-big-data/opendata-movilidad"
    target="_blank">original data download page</a>

-   <a
    href="https://www.transportes.gob.es/el-ministerio/buen-gobierno/licencia_datos"
    target="_blank">original data license</a>

-   <a
    href="https://www.transportes.gob.es/ministerio/proyectos-singulares/estudio-de-movilidad-con-big-data"
    target="_blank">homepage of the v2 study and open mobility data project
    of the Ministry of Transport and Sustainable Mobility of Spain</a>

> **Note**
>
> Kindly consult the documents above for any specific details on the
> methodology. The codebook here is only a simplified summary.

To access the data we reference in this codebook, please follow these
steps:

## Install the package

The package is not yet available on CRAN.

You can install the latest version of the package from rOpenSpain R
universe:

``` r
install.packages("spanishoddata",
  repos = c("https://ropenspain.r-universe.dev",
    "https://cloud.r-project.org"))
```

<details>
<summary>
Alternative installation and developemnt
</summary>

Alternative way to install the package from GitHub:

``` r
if (!require("remotes")) install.packages("remotes")

remotes::install_github("rOpenSpain/spanishoddata",
  force = TRUE, dependencies = TRUE)
```

**For Developers**

To load the package locally, clone it and navigate to the root of the
package in the terminal, e.g. with the following:

``` bash
gh repo clone rOpenSpain/spanishoddata
code spanishoddata
# with rstudio:
rstudio spanishoddata/spanishoddata.Rproj
```

Then run the following command from the R console:

``` r
devtools::load_all()
```

</details>

Load it as follows:

``` r
library(spanishoddata)
```

Using the instructions below, set the data folder for the package to
download the files into. You may need up to 400 GB to download all data
and another 400 GB if you would like to convert the downloaded data into
analysis ready format (a `DuckDB` database file, or a folder of
`parquet` files). You can find more info on this conversion in the
[Download and convert OD datasets](convert.html) vignette.

## Set the data directory

Choose where `{spanishoddata}` should download (and convert) the data by
setting the data directory following command:

``` r
spod_set_data_dir(data_dir = "~/spanish_od_data")
```

The function above will also ensure that the directory is created and
that you have sufficient permissions to write to it.

<details>
<summary>
Setting data directory for advanced users
</summary>

You can also set the data directory with an environment variable:

``` r
Sys.setenv(SPANISH_OD_DATA_DIR = "~/spanish_od_data")
```

The package will create this directory if it does not exist on the first
run of any function that downloads the data.

To permanently set the directory for all projects, you can specify the
data directory globally by setting the `SPANISH_OD_DATA_DIR` environment
variable, e.g. with the following command:

``` r
usethis::edit_r_environ()
# Then set the data directory globally, by typing this line in the file:
```

    SPANISH_OD_DATA_DIR = "~/spanish_od_data"

You can also set the data directory locally, just for the current
project. Set the ‘envar’ in the working directory by editing `.Renviron`
file in the root of the project:

``` r
file.edit(".Renviron")
```

</details>

# Overall approach to accessing the data

If you only need flows data aggregated by day at municipal level, you
can use the `spod_quick_get_od()` function. This will download the data
directly from the web API and let you analyse it in-memory. More on this
in the [Quickly get daily
data](https://ropenspain.github.io/spanishoddata/articles/quick-get.html)
vignette.

If you only want to analyse the data for a few days, you can use the
`spod_get()` function. It will download the raw data in CSV format and
let you analyse it in-memory. This is what we cover in the steps on this
page.

If you need longer periods (several months or years), you should use the
`spod_convert()` and `spod_connect()` functions, which will convert the
data into special format which is much faster for analysis, for this see
the [Download and convert OD
datasets](https://ropenspain.github.io/spanishoddata/articles/convert.html)
vignette. `spod_get_zones()` will give you spatial data with zones that
can be matched with the origin-destination flows from the functions
above using zones ’id’s. Please see a simple example below, and also
consult the vignettes with detailed data description and instructions in
the package vignettes with `spod_codebook(ver = 1)` and
`spod_codebook(ver = 2)`, or simply visit the package website at
<https://ropenspain.github.io/spanishoddata/>. The
<a href="#fig-overall-flow" class="quarto-xref">Figure 1</a> presents
the overall approach to accessing the data in the `spanishoddata`
package.

<img src="../man/figures/package-functions-overview.svg"
style="width:78.0%" />

# 1. Spatial data with zoning boundaries

The boundary data is provided at three geographic levels:
[`Distrtics`](#districts), [`Municipalities`](#municipalities), and
[`Large Urban Areas`](#lua). It’s important to note that these do not
always align with the official Spanish census districts and
municipalities. To comply with data protection regulations, certain
aggregations had to be made to districts and municipalities”.

## 1.1 `Districts`

`Districts` correspond to official census districts in cities; however,
in those with lower population density, they are grouped together. In
rural areas, one district is often equal to a municipality, but
municipalities with low population are combined into larger units to
preserve privacy of individuals in the dataset. Therefore, there are
3792 ‘districts’ compared to the 10494 official census districts on
which they are based. There are also
<a href="https://ec.europa.eu/eurostat/web/nuts" target="_blank">NUTS3
statistical regions</a> covering France (94 units) and Portugal (23
units). Therefore there is a total of 3909 zones in the `Districts`
dataset.

``` r
districts_v2 <- spod_get_zones("dist", ver = 2)
```

The `districts_v2` object is of class `sf` consisting of polygons.

Data structure:

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr>
<th>Variable Name</th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><code>id</code></td>
<td>District <code>id</code> assigned by the data provider. Matches with
<code>id_origin</code>, <code>id_destination</code>, and <code>id</code>
in district-level origin-destination and number of trips data.</td>
</tr>
<tr>
<td><code>name</code></td>
<td>Name of the district.</td>
</tr>
<tr>
<td><code>population</code></td>
<td>Number of individuals in the district according to <a
href="https://ine.es/" target="_blank">INE</a><a href="#fn1"
class="footnote-ref" id="fnref1"
role="doc-noteref"><sup>1</sup></a>.</td>
</tr>
<tr>
<td><code>census_sections</code></td>
<td>Semicolon-separated list of census section identifiers that
correspond to each district, classified by the Spanish Statistical
Office (INE).</td>
</tr>
<tr>
<td><code>census_districts</code></td>
<td>Semicolon-separated list of census district identifiers
corresponding to each district, as classified by the Spanish Statistical
Office (INE).</td>
</tr>
<tr>
<td><code>municipalities</code></td>
<td>Semicolon-separated list of municipality identifiers corresponding
to each district, as classified by the Spanish Statistical Office
(INE).</td>
</tr>
<tr>
<td><code>municipalities_mitma</code></td>
<td>Semicolon-separated list of municipality identifiers as assigned by
the data provider (MITMA).</td>
</tr>
<tr>
<td><code>luas_mitma</code></td>
<td>Semicolon-separated list of Large Urban Areas (LUAs) as assigned by
the data provider, corresponding to each district.</td>
</tr>
<tr>
<td><code>district_ids_in_v1</code></td>
<td>Semicolon-separated district identifiers from v1 data corresponding
to each district in v2. If no match exists, marked as
<code>NA</code>.</td>
</tr>
<tr>
<td><code>geometry</code></td>
<td>Spatial geometry of each district stored as a
<code>MULTIPOLYGON</code> object, projected in the ETRS89 / UTM zone 30N
CRS with XY dimensions.</td>
</tr>
</tbody>
</table>
<section id="footnotes" class="footnotes footnotes-end-of-document"
role="doc-endnotes">
<hr />
<ol>
<li id="fn1"><p>This is likely the population as of end of 2021 or start
of 2022. Population for a few districts is missing. Instead of
population, residence and overnight stays data may be used as a proxy
with caution. Also, newer population figures may be obtained and joined
with the provided zones using the reference tables that match the zones
ids with official municipal and census district ids from INE.<a
href="#fnref1" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
</ol>
</section>

## 1.2 `Municipalities`

`Municipalities` are made up of official municipalities in those of a
certain size; however, they have also been aggregated in cases of lower
population density. As a result, there are 2618 municipalities compared
to the 8,125 official municipalities on which they are based. There are
also
<a href="https://ec.europa.eu/eurostat/web/nuts" target="_blank">NUTS3
statistical regions</a> covering France (94 units) and Portugal (23
units). Therefore there is a total of 2735 zones in the `Districts`
dataset.

``` r
municipalities_v2 <- spod_get_zones("muni", ver = 2)
```

The resulting `municipalities_v2` object is type `sf` consisting of
polygons.

Data structure:

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr>
<th>Variable Name</th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><code>id</code></td>
<td>District <code>id</code> assigned by the data provider. Matches with
<code>id_origin</code>, <code>id_destination</code>, and <code>id</code>
in district-level origin-destination and number of trips data.</td>
</tr>
<tr>
<td><code>name</code></td>
<td>Name of the district.</td>
</tr>
<tr>
<td><code>population</code></td>
<td>Number of individuals in the district according to <a
href="https://ine.es/" target="_blank">INE</a><a href="#fn1"
class="footnote-ref" id="fnref1"
role="doc-noteref"><sup>1</sup></a>.</td>
</tr>
<tr>
<td><code>census_sections</code></td>
<td>Semicolon-separated list of census section identifiers that
correspond to each district, classified by the Spanish Statistical
Office (INE).</td>
</tr>
<tr>
<td><code>census_districts</code></td>
<td>Semicolon-separated list of census district identifiers
corresponding to each district, as classified by the Spanish Statistical
Office (INE).</td>
</tr>
<tr>
<td><code>municipalities</code></td>
<td>Semicolon-separated list of municipality identifiers corresponding
to each district, as classified by the Spanish Statistical Office
(INE).</td>
</tr>
<tr>
<td><code>districts_mitma</code></td>
<td>Semicolon-separated list of district identifiers as assigned by the
data provider (MITMA).</td>
</tr>
<tr>
<td><code>luas_mitma</code></td>
<td>Semicolon-separated list of Large Urban Areas (LUAs) as assigned by
the data provider, corresponding to each district.</td>
</tr>
<tr>
<td><code>municipality_ids_in_v1</code></td>
<td>Semicolon-separated district identifiers from v1 data corresponding
to each district in v2. If no match exists, marked as
<code>NA</code>.</td>
</tr>
<tr>
<td><code>geometry</code></td>
<td>Spatial geometry of each district stored as a
<code>MULTIPOLYGON</code> object, projected in the ETRS89 / UTM zone 30N
CRS with XY dimensions.</td>
</tr>
</tbody>
</table>
<section id="footnotes" class="footnotes footnotes-end-of-document"
role="doc-endnotes">
<hr />
<ol>
<li id="fn1"><p>This is likely the population as of end of 2021 or start
of 2022. Population for a few districts is missing. Instead of
population, residence and overnight stays data may be used as a proxy
with caution. Also, newer population figures may be obtained and joined
with the provided zones using the reference tables that match the zones
ids with official municipal and census district ids from INE.<a
href="#fnref1" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
</ol>
</section>

## 1.3 `LUAs (Large Urban Areas)`

`Large Urban Areas (LUAs)` has essentially the same spatial units as
[`Municipalities`](#municipalities), but are not aggregated. Therefore,
there are 2086 locations in the `LUAs` dataset. There are also
<a href="https://ec.europa.eu/eurostat/web/nuts" target="_blank">NUTS3
statistical regions</a> covering France (94 units) and Portugal (23
units). Therefore there is a total of 2203 zones in the `LUAs` dataset.

``` r
luas_v2 <- spod_get_zones("lua", ver = 2)
```

The resulting `luas_v2` object is type `sf` consisting of polygons.

Data structure:

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 75%" />
</colgroup>
<thead>
<tr>
<th>Variable Name</th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><code>id</code></td>
<td>District <code>id</code> assigned by the data provider. Matches with
<code>id_origin</code>, <code>id_destination</code>, and <code>id</code>
in district-level origin-destination and number of trips data.</td>
</tr>
<tr>
<td><code>name</code></td>
<td>Name of the district.</td>
</tr>
<tr>
<td><code>population</code></td>
<td>Number of individuals in the district according to <a
href="https://ine.es/" target="_blank">INE</a><a href="#fn1"
class="footnote-ref" id="fnref1"
role="doc-noteref"><sup>1</sup></a>.</td>
</tr>
<tr>
<td><code>census_sections</code></td>
<td>Semicolon-separated list of census section identifiers that
correspond to each district, classified by the Spanish Statistical
Office (INE).</td>
</tr>
<tr>
<td><code>census_districts</code></td>
<td>Semicolon-separated list of census district identifiers
corresponding to each district, as classified by the Spanish Statistical
Office (INE).</td>
</tr>
<tr>
<td><code>municipalities</code></td>
<td>Semicolon-separated list of municipality identifiers corresponding
to each district, as classified by the Spanish Statistical Office
(INE).</td>
</tr>
<tr>
<td><code>districts_mitma</code></td>
<td>Semicolon-separated list of district identifiers as assigned by the
data provider (MITMA).</td>
</tr>
<tr>
<td><code>municipalities_mitma</code></td>
<td>Semicolon-separated list of municipality identifiers as assigned by
the data provider (MITMA).</td>
</tr>
<tr>
<td><code>geometry</code></td>
<td>Spatial geometry of each district stored as a
<code>MULTIPOLYGON</code> object, projected in the ETRS89 / UTM zone 30N
CRS with XY dimensions.</td>
</tr>
</tbody>
</table>
<section id="footnotes" class="footnotes footnotes-end-of-document"
role="doc-endnotes">
<hr />
<ol>
<li id="fn1"><p>This is likely the population as of end of 2021 or start
of 2022. Population for a few districts is missing. Instead of
population, residence and overnight stays data may be used as a proxy
with caution. Also, newer population figures may be obtained and joined
with the provided zones using the reference tables that match the zones
ids with official municipal and census district ids from INE.<a
href="#fnref1" class="footnote-back" role="doc-backlink">↩︎</a></p></li>
</ol>
</section>

# 2. Mobility data

All mobility data is referenced via `id_origin`, `id_destination`, or
other location identifiers (mostly labelled as `id`) with the two sets
of zones described above.

## 2.1. Origin-destination data

The origin-destination data contain the number of trips between
`districts`, `municipalities`, or `large urban areas (LUAs)` in Spain
for every hour of every day between 2022-02-01 and whichever currently
available latest data (2024-06-30 at the time of writing). Each flow
also has attributes such as the trip purpose (composed of the type of
activity
(`home`/`work_or_study`/`frequent_activity`/`infrequent_activity`) at
both the origin and destination, but also age, sex, and income of each
group of individuals traveling between the origin and destination),
province of residence of individuals making this trip, distance covered
while making the trip. See the detailed attributes below in a table.

Here are the variables you can find in the `district`, `municipality`
and `large urban area` level data:

<table>
<colgroup>
<col style="width: 12%" />
<col style="width: 12%" />
<col style="width: 12%" />
<col style="width: 62%" />
</colgroup>
<thead>
<tr>
<th><strong>English Variable Name</strong></th>
<th><strong>Original Variable Name</strong></th>
<th><strong>Type</strong></th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><code>date</code></td>
<td><code>fecha</code></td>
<td><code>Date</code></td>
<td>The date of the recorded data, formatted as
<code>YYYY-MM-DD</code>.</td>
</tr>
<tr>
<td><code>time_slot</code></td>
<td><code>periodo</code></td>
<td><code>integer</code></td>
<td>The time slot during which the trips occurred.</td>
</tr>
<tr>
<td><code>id_origin</code></td>
<td><code>origen</code></td>
<td><code>factor</code></td>
<td>The origin zone <code>id</code> of <code>district</code>,
<code>municipality</code>, or <code>large urban area</code>.</td>
</tr>
<tr>
<td><code>id_destination</code></td>
<td><code>destino</code></td>
<td><code>factor</code></td>
<td>The destination zone <code>id</code> of <code>district</code>,
<code>municipality</code>, or <code>large urban area</code>.</td>
</tr>
<tr>
<td><code>distance</code></td>
<td><code>distancia</code></td>
<td><code>factor</code></td>
<td>The distance range of the trip, categorized into specific intervals
such as <code>0.5-2</code> (500 m to 2 km), <code>2-10</code> (2-10 km),
<code>10-50</code> (10-50km), and <code>&gt;50</code> (50 or more
km).</td>
</tr>
<tr>
<td><code>activity_origin</code></td>
<td><code>actividad_origen</code></td>
<td><code>factor</code></td>
<td>The type of activity at the origin zone, recoded from
<code>casa</code>, <code>trabajo_estudio</code>, <code>frecuente</code>,
<code>no_frecuente</code> to <code>home</code>,
<code>work_or_study</code>, <code>frequent_activity</code>,
<code>infrequent_activity</code> respectively.</td>
</tr>
<tr>
<td><code>activity_destination</code></td>
<td><code>actividad_destino</code></td>
<td><code>factor</code></td>
<td>The type of activity at the destination zone, similarly recoded as
for <code>activity_origin</code> above.</td>
</tr>
<tr>
<td><code>study_possible_origin</code></td>
<td><code>estudio_origen_posible</code></td>
<td><code>logical</code></td>
<td><code>TRUE</code> if the activity at origin may be connected with
study, and <code>FALSE</code> otherwise.</td>
</tr>
<tr>
<td><code>study_possible_destination</code></td>
<td><code>estudio_destino_posible</code></td>
<td><code>logical</code></td>
<td><code>TRUE</code> if the activity at destination may be connected
with study, and <code>FALSE</code> otherwise.</td>
</tr>
<tr>
<td><code>residence_province_ine_code</code></td>
<td><code>residencia</code></td>
<td><code>factor</code></td>
<td>The province code of residence of individuals making the trips in
<code>n_trips</code>, encoded as province codes as classified by the
Spanish Statistical Office (INE).</td>
</tr>
<tr>
<td><code>residence_province_name</code></td>
<td>Derived from <code>residencia</code></td>
<td><code>factor</code></td>
<td>The full name of the residence province, derived from the province
code above.</td>
</tr>
<tr>
<td><code>income</code></td>
<td><code>renta</code></td>
<td><code>factor</code></td>
<td>The income group of individuals making the trips in
<code>n_trips</code>. Categorized into <code>&lt;10</code>,
<code>10-15</code>, and <code>&gt;15</code> (thousands of euros per
year). The income for each individual is assigned based on the mean
census tract income per person (data source is <a
href="https://www.ine.es/dyngs/INEbase/en/operacion.htm?c=Estadistica_C&amp;cid=1254736177088&amp;menu=ultiDatos&amp;idp=1254735976608">INE
Household income distribution map</a>).</td>
</tr>
<tr>
<td><code>age</code></td>
<td><code>edad</code></td>
<td><code>factor</code></td>
<td>The age group of individuals making the trips in
<code>n_trips</code>. Categorized into <code>0-25</code>,
<code>25-45</code>, <code>45-65</code>, <code>65-100</code>, or
<code>NA</code>. The data is partially imputed, for details see <a
href="https://www.nommon.es/blog/using-machine-learning-to-predict-sociodemographic-characteristics/">this
blogpost</a> by Nommon.</td>
</tr>
<tr>
<td><code>sex</code></td>
<td><code>sexo</code></td>
<td><code>factor</code></td>
<td>The sex of individuals making the trips in <code>n_trips</code>.
Categorized into <code>female</code>, <code>male</code>, or
<code>NA</code>. The data is partially imputed, for details see <a
href="https://www.nommon.es/blog/using-machine-learning-to-predict-sociodemographic-characteristics/">this
blogpost</a> by Nommon.</td>
</tr>
<tr>
<td><code>n_trips</code></td>
<td><code>viajes</code></td>
<td><code>numeric</code></td>
<td>The number of trips for that specific origin-destination pair and
time slot.</td>
</tr>
<tr>
<td><code>trips_total_length_km</code></td>
<td><code>viajes_km</code></td>
<td><code>numeric</code></td>
<td>The total length of trips in kilometers, summing up all trips
between the origin and destination zones.</td>
</tr>
<tr>
<td><code>year</code></td>
<td><code>year</code></td>
<td><code>integer</code></td>
<td>The year of the recorded data, extracted from the date.</td>
</tr>
<tr>
<td><code>month</code></td>
<td><code>month</code></td>
<td><code>integer</code></td>
<td>The month of the recorded data, extracted from the date.</td>
</tr>
<tr>
<td><code>day</code></td>
<td><code>day</code></td>
<td><code>integer</code></td>
<td>The day of the recorded data, extracted from the date.</td>
</tr>
</tbody>
</table>

**Getting the data**

To access the data, use the `spod_get()` function. In this example we
will use a short interval of dates:

``` r
dates <- c(start = "2022-01-01", end = "2022-01-04")
od_dist <- spod_get(type = "od", zones = "dist", dates = dates)
od_muni <- spod_get(type = "od", zones = "muni", dates = dates)
```

The data for the specified dates will be automatically downloaded and
cached in the `SPANISH_OD_DATA_DIR` directory. Existing files will not
be re-downloaded.

**Working with the data**

The resulting objects `od_dist` and `od_muni` are of class
`tbl_duckdb_connection`[2]. Basically, you can treat these as regular
`data.frame`s or `tibble`s. One important difference is that the data is
not actually loaded into memory, because if you requested more dates,
e.g. a whole month or a year, all that data would most likely not fit
into your computer’s memory. A `tbl_duckdb_connection` is mapped to the
downloaded CSV files that are cached on disk and the data is only loaded
in small chunks as needed at the time of computation. You can manipulate
`od_dist` and `od_muni` using `{dplyr}` functions such as `select()`,
`filter()`, `mutate()`, `group_by()`, `summarise()`, etc. In the end of
any sequence of commands you will need to add `collect()` to execute the
whole chain of data manipulations and load the results into memory in an
R `data.frame`/`tibble` like so:

``` r
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
```

    # A tibble: 39 × 4
       age   sex    income daily_mean_n_trips
       <fct> <fct>  <fct>               <dbl>
     1 NA    NA     <10              7002485.
     2 NA    NA     10-15           16551405.
     3 NA    NA     >15              2651481.
     4 0-25  NA     <10               539060.
     5 0-25  NA     10-15            1950892.
     6 0-25  NA     >15               401557.
     7 0-25  female <10              1484989.
     8 0-25  female 10-15            5357785.
     9 0-25  female >15              1764454.
    10 0-25  male   <10              1558461.
    # ℹ 29 more rows
    # ℹ Use `print(n = ...)` to see more rows

In this example above, becaus the data is with hourly intervals within
each day, we first summed the number of trips for each day by age, sex,
and income groups. We then grouped the data again dropping the day
variable and calculated the mean number of trips per day by age, sex,
and income groups. The full data for all 4 days was probably never
loaded into memory all at once. Rather the available memory of the
computer was used up to its maximum limit to make that calculation
happen, without ever exceeding the available memory limit. If you were
doing the same opearation on 100 or even more days, it would work in the
same way and would be possible even with limited memory. This is done
transparantly to the user with the help of
<a href="https://duckdb.org/" target="_blank"><code>DuckDB</code></a>
(specifically, with
<a href="https://r.duckdb.org/index.html" target="_blank">{duckdb} R
package</a> Mühleisen and Raasveldt (2024)).

The same summary operation as provided in the example above can be done
with the entire dataset for multiple years worth of data on a regular
laptop with 8-16 GB memory. It will take a bit of time to complete, but
it will be done. To speed things up, please also see the [vignette on
converting the data](convert.qmd) into formats that will increase the
analsysis performance.

> **Note**
>
> As long as you use a table connection object created with `spod_get()`
> function, it is much quicker to filter the dates by the `year`,
> `month` and `day` variables, rather than by the `date` variable. This
> is because the data for each day is in a separate CSV file located in
> folders that look like `year=2020/month=2/day=14`. So when filtering
> by the `date` field, R will have to scan all CSV files comparing the
> specified date with what is stored inside each CSV file. However, if
> you query by `year`, `month` and `day` variables, R only needs to
> check these against the path to each CSV file, which is much quicker.
> This caveat is only relevant as long as you use `spod_get()` . If you
> convert (see the [relevant vignette](convert.qmd)) the downloaded data
> to a format that it optimized for quick analysis, you can use
> whichever field you want, it should not affect the performance.

## 2.2. Number of trips data

For each location, the “number of trips” data provides the number of
individuals who spent the night there, with breakdown by the number of
trips made, age, and sex.

<table style="width:100%;">
<colgroup>
<col style="width: 23%" />
<col style="width: 23%" />
<col style="width: 23%" />
<col style="width: 30%" />
</colgroup>
<thead>
<tr>
<th><strong>English Variable Name</strong></th>
<th><strong>Original Variable Name</strong></th>
<th><strong>Type</strong></th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><code>date</code></td>
<td><code>fecha</code></td>
<td><code>Date</code></td>
<td>The date of the recorded data, formatted as
<code>YYYY-MM-DD</code>.</td>
</tr>
<tr>
<td><code>id</code></td>
<td><code>distrito</code></td>
<td><code>factor</code></td>
<td>The identifier of the <code>district</code> or
<code>municipality</code> zone.</td>
</tr>
<tr>
<td><code>age</code></td>
<td><code>edad</code></td>
<td><code>factor</code></td>
<td>The age group of individuals making the trips in
<code>n_trips</code>. Categorized into <code>0-25</code>,
<code>25-45</code>, <code>45-65</code>, <code>65-100</code>, or
<code>NA</code>. The data is partially imputed, for details see <a
href="https://www.nommon.es/blog/using-machine-learning-to-predict-sociodemographic-characteristics/">this
blogpost</a> by Nommon.</td>
</tr>
<tr>
<td><code>sex</code></td>
<td><code>sexo</code></td>
<td><code>factor</code></td>
<td>The sex of individuals making the trips in <code>n_trips</code>.
Categorized into <code>female</code>, <code>male</code>, or
<code>NA</code>. The data is partially imputed, for details see <a
href="https://www.nommon.es/blog/using-machine-learning-to-predict-sociodemographic-characteristics/">this
blogpost</a> by Nommon.</td>
</tr>
<tr>
<td><code>n_trips</code></td>
<td><code>numero_viajes</code></td>
<td><code>factor</code></td>
<td>The number of individuals who made trips, categorized by
<code>0</code>, <code>1</code>, <code>2</code>, or <code>2+</code>
trips.</td>
</tr>
<tr>
<td><code>n_persons</code></td>
<td><code>personas</code></td>
<td><code>factor</code></td>
<td>The number of persons making the trips from <code>district</code>,
<code>municipality</code>, or <code>large urban area (LUA)</code> with
zone <code>id</code>.</td>
</tr>
<tr>
<td><code>year</code></td>
<td><code>year</code></td>
<td><code>integer</code></td>
<td>The year of the recorded data, extracted from the date.</td>
</tr>
<tr>
<td><code>month</code></td>
<td><code>month</code></td>
<td><code>integer</code></td>
<td>The month of the recorded data, extracted from the date.</td>
</tr>
<tr>
<td><code>day</code></td>
<td><code>day</code></td>
<td><code>integer</code></td>
<td>The day of the recorded data, extracted from the date.</td>
</tr>
</tbody>
</table>

**Getting the data**

To access it use `spod_get()` with `type` set to “number_of_trips”, or
just “nt”.

``` r
dates <- c(start = "2022-01-01", end = "2022-01-04")
nt_dist <- spod_get(type = "number_of_trips", zones = "dist", dates = dates)
```

Because this data is small, we can actually load it completely into
memory:

``` r
nt_dist_tbl <- nt_dist |> dplyr::collect()
```

## 2.3. Overnight stays

This dataset provides the number of people who spend the night in each
location, also identifying their place of residence down to the census
district level according to the <a
href="https://www.ine.es/ss/Satellite?c=Page&amp;p=1259952026632&amp;pagename=ProductosYServicios%2FPYSLayout&amp;cid=1259952026632&amp;L=1"
target="_blank">INE encoding</a>.

Here are the variables you can find in the `district`, `municipality`
and `large urban area` level data:

<table style="width:100%;">
<colgroup>
<col style="width: 23%" />
<col style="width: 23%" />
<col style="width: 23%" />
<col style="width: 30%" />
</colgroup>
<thead>
<tr>
<th><strong>English Variable Name</strong></th>
<th><strong>Original Variable Name</strong></th>
<th><strong>Type</strong></th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr>
<td><code>date</code></td>
<td><code>fecha</code></td>
<td><code>Date</code></td>
<td>The date of the recorded data, formatted as
<code>YYYY-MM-DD</code>.</td>
</tr>
<tr>
<td><code>id_residence</code></td>
<td><code>zona_residencia</code></td>
<td><code>factor</code></td>
<td>The identifier of the census district according to the <a
href="https://www.ine.es/ss/Satellite?c=Page&amp;p=1259952026632&amp;pagename=ProductosYServicios%2FPYSLayout&amp;cid=1259952026632&amp;L=1"
target="_blank">INE encoding</a>.</td>
</tr>
<tr>
<td><code>id_overnight_stay</code></td>
<td><code>zona_pernoctacion</code></td>
<td><code>factor</code></td>
<td>The identifier of the <code>district</code>,
<code>municipality</code>, or <code>large urban area (LUA)</code>
zone.</td>
</tr>
<tr>
<td><code>n_persons</code></td>
<td><code>personas</code></td>
<td><code>factor</code></td>
<td>The number of persons making the trips from <code>district</code>,
<code>municipality</code>, or <code>large urban area</code> with zone
<code>id</code>.</td>
</tr>
<tr>
<td><code>year</code></td>
<td><code>year</code></td>
<td><code>integer</code></td>
<td>The year of the recorded data, extracted from the date.</td>
</tr>
<tr>
<td><code>month</code></td>
<td><code>month</code></td>
<td><code>integer</code></td>
<td>The month of the recorded data, extracted from the date.</td>
</tr>
<tr>
<td><code>day</code></td>
<td><code>day</code></td>
<td><code>integer</code></td>
<td>The day of the recorded data, extracted from the date.</td>
</tr>
</tbody>
</table>

**Getting the data**

To access it use `spod_get()` with `type` set to “number_of_trips”, or
just “nt”.

``` r
dates <- c(start = "2022-01-01", end = "2022-01-04")
os_dist <- spod_get(type = "overnight_stays", zones = "dist", dates = dates)
```

Because this data is small, we can actually load it completely into
memory:

``` r
os_dist_tbl <- os_dist |> dplyr::collect()
```

MITMS. 2024. “Estudio de Movilidad de Viajeros de Ámbito Nacional
Aplicando La Tecnología Big Data. Informe Metodológico (Study of
National Traveler Mobility Using Big Data Technology. Methodological
Report).” Secretaría de Estado de Transportes y Movilidad Sostenible;
Ministerio de Transportes, Movilidad y Agenda Urbana.
<https://www.transportes.gob.es/ministerio/proyectos-singulares/estudio-de-movilidad-con-big-data>.

Mühleisen, Hannes, and Mark Raasveldt. 2024. *Duckdb: DBI Package for
the DuckDB Database Management System*.
<https://doi.org/10.32614/CRAN.package.duckdb>.

[1] For reference: this object also has classes: `tbl_dbi` ,`tbl_sql`,
`tbl_lazy` ,and `tbl` .

[2] For reference: this object also has classes: `tbl_dbi` ,`tbl_sql`,
`tbl_lazy` ,and `tbl` .
