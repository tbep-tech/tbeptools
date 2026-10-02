# Changelog

## tbeptools 3.1.1

- Added
  [`show_tbniscrseas()`](https://tbep-tech.github.io/tbeptools/reference/show_tbniscrseas.md)
  to plot seasonal (monthly) Tampa Bay Nekton Index results for a single
  bay segment and year, with boxplots of site-level values overlaid with
  jittered points, the same red/yellow/green `perc` score category
  background as
  [`show_tbniscr()`](https://tbep-tech.github.io/tbeptools/reference/show_tbniscr.md)
  when plotting the TBNI score, and plotly tooltips showing station
- Added
  [`show_ambitab()`](https://tbep-tech.github.io/tbeptools/reference/show_ambitab.md)
  and
  [`show_ambitrend()`](https://tbep-tech.github.io/tbeptools/reference/show_ambitrend.md),
  and AMBI/AMBI-TB background and examples in the TBBI vignette
- Added
  [`anlz_splitdata()`](https://tbep-tech.github.io/tbeptools/reference/anlz_splitdata.md),
  `anlz_splitsorms()`, and
  [`show_splitbarplot()`](https://tbep-tech.github.io/tbeptools/reference/show_splitbarplot.md)
  for summarizing data by period/storm splits
- Added
  [`read_importsealevels()`](https://tbep-tech.github.io/tbeptools/reference/read_importsealevels.md)
  and the `sealevelstations` dataset for NOAA sea level data, with
  vignette content
- Added
  [`read_importprism()`](https://tbep-tech.github.io/tbeptools/reference/read_importprism.md)
  and
  [`read_prism_rasters()`](https://tbep-tech.github.io/tbeptools/reference/read_prism_rasters.md)
  for PRISM climate data
- Added
  [`read_importwqwin()`](https://tbep-tech.github.io/tbeptools/reference/read_importwqwin.md)
  and
  [`util_importwqwin()`](https://tbep-tech.github.io/tbeptools/reference/util_importwqwin.md)
  to retrieve water quality data from the FDEP WIN API
- Added
  [`read_importwqwa()`](https://tbep-tech.github.io/tbeptools/reference/read_importwqwa.md)
  and
  [`util_importwqwa()`](https://tbep-tech.github.io/tbeptools/reference/util_importwqwa.md)
  to retrieve Water Atlas data and metadata from its API, with vignette
  content
- Added
  [`util_rain()`](https://tbep-tech.github.io/tbeptools/reference/util_rain.md)
  to replace the retired `rnoaa` package as a precipitation data source
  for
  [`anlz_hydroload()`](https://tbep-tech.github.io/tbeptools/reference/anlz_hydroload.md)
- Added `exceed_rate` to
  [`anlz_fibmatrix()`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmatrix.md)
  as a continuous analog to the letter grade scores
- Added the `dbasin` dataset and an experimental drainage-basin mapping
  option to
  [`show_fibmatmap()`](https://tbep-tech.github.io/tbeptools/reference/show_fibmatmap.md),
  including a `bayseg` list-output enhancement
- Added `extend` and `covlab` arguments to
  [`show_seagrasscoverage()`](https://tbep-tech.github.io/tbeptools/reference/show_seagrasscoverage.md)
- Added retry with exponential backoff to
  [`read_importwqp()`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md)
  (via new
  [`util_importwqp()`](https://tbep-tech.github.io/tbeptools/reference/util_importwqp.md))
  and
  [`read_transect()`](https://tbep-tech.github.io/tbeptools/reference/read_transect.md)
  for intermittent request failures
- [`show_boxplot()`](https://tbep-tech.github.io/tbeptools/reference/show_boxplot.md)
  now plots points for the current year on top of other years
- [`show_hmpreport()`](https://tbep-tech.github.io/tbeptools/reference/show_hmpreport.md)
  legend and symbol sizing options improved for two-column output
- Fixed
  [`show_transect()`](https://tbep-tech.github.io/tbeptools/reference/show_transect.md)
  to use the maximum value, rather than erroring, when more than one
  macroalgae species is recorded at the same meter mark
- Fixed a bug in seagrass transect date assignment that could create
  duplicate dates within the same year
- Fixed
  [`show_matrixplotly()`](https://tbep-tech.github.io/tbeptools/reference/show_matrixplotly.md)
  and
  [`show_ratab()`](https://tbep-tech.github.io/tbeptools/reference/show_ratab.md)
  (for compatibility with dplyr/ggplot2 updates and 2024 results)
- Fixed
  [`show_fibmatmap()`](https://tbep-tech.github.io/tbeptools/reference/show_fibmatmap.md)
  issues with `listout` and non-baywide output
- Replaced the deprecated `size` argument with `linewidth` for
  line-based ggplot2 geoms
  ([`geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html),
  [`geom_hline()`](https://ggplot2.tidyverse.org/reference/geom_abline.html),
  [`geom_vline()`](https://ggplot2.tidyverse.org/reference/geom_abline.html),
  [`geom_segment()`](https://ggplot2.tidyverse.org/reference/geom_segment.html),
  [`geom_sf()`](https://ggplot2.tidyverse.org/reference/ggsf.html))
  across all plotting functions, and updated the default font family for
  compatibility with current ggplot2
- Removed `mapview` from Suggests; replaced `mapview()` examples in the
  seagrass transect, TBNI, TBBI, and tidal creeks vignettes with
  `leaflet()` using the ESRI World Gray Canvas basemap
- Removed the `rnoaa`, `stringr`, `scales`, and `units` dependencies and
  native pipe usage for improved R CMD check compliance; bumped the
  minimum required R version
- Updated EPC download endpoints for water quality, FIB, plankton, and
  benthic (base tables and results) data following changes to EPC’s
  SharePoint hosting
- Updated the Water Atlas seagrass transect API endpoints
- `fimdata`, `fimstations`, `epcdata`, `phytodata`, `benthicdata`,
  `sedimentdata`, `transect`, `seagrass`, `tidalcreeks`, `iwrraw`,
  `catchprecip`, and county FIB/enterococcus datasets updated with 2024
  and 2025 results
- Added `tbsegdetailbcbs` and `swfwmdtbseg2024` spatial datasets;
  updated `acres` (2023 LULC) and `subtacres`

## tbeptools 3.1.0

- [`show_matrixplotly()`](https://tbep-tech.github.io/tbeptools/reference/show_matrixplotly.md)
  now uses `automargin = T` for complete x-axis text display
- Improved URL stability for nekton index ancillary file downloads
- Added `tbsegdetail` dataset for detailed bay segment polygons
- Updated
  [`read_formphyto()`](https://tbep-tech.github.io/tbeptools/reference/read_formphyto.md)
  for correct taxa grouping for diatoms
- `phytodata`, `epcdata`, `transect`, `seagrass`, `iwrraw`,
  `tidalcreeks` data updated for 2024
- `benthicdata`, `sedimentdata` data updated for 2023
- `show_sitesegmep()` correctly drops segments not shown from legend;
  segment label display option added
- [`show_sitemap()`](https://tbep-tech.github.io/tbeptools/reference/show_sitemap.md)
  now has angled axis text; segment label option added
- [`read_formphyto()`](https://tbep-tech.github.io/tbeptools/reference/read_formphyto.md)
  default arguments updated for source data changes
- [`show_boxplot()`](https://tbep-tech.github.io/tbeptools/reference/show_boxplot.md)
  now has option to remove jittered points and outliers using `points`
  argument
- `lastlab` argument in
  [`show_seagrasscoverage()`](https://tbep-tech.github.io/tbeptools/reference/show_seagrasscoverage.md)
  is now logical
- [`show_ratab()`](https://tbep-tech.github.io/tbeptools/reference/show_ratab.md)
  font changed to Arial for PDF Quarto render compatibility
- Chaetomorpha genus option added to seagrass transect functions
- [`show_hmpreport()`](https://tbep-tech.github.io/tbeptools/reference/show_hmpreport.md)
  now has option to remove total intertidal column
- `trnlns` updated to include bay segment column
- [`anlz_transectave()`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectave.md)
  now uses `All` instead of `Tampa Bay`
- FIB reporting functions overhauled; Enterococcus and E. coli used
  exclusively for marine/freshwater stations; expanded county data
  inclusion

## tbeptools 3.0.0

- `targets` object updated with values for Boca Ciega Bay, Terra Ceia
  Bay, and Manatee River
- All data objects updated with current data
- Added HMP reporting functions and vignette
- Added sediment functions and vignette for benthic data
- Added
  [`show_seagrasscoverage()`](https://tbep-tech.github.io/tbeptools/reference/show_seagrasscoverage.md)
  function
- SWFWMD Tampa Bay segment spatial object added
- `all` argument added to
  [`read_importwq()`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)
  and
  [`read_formwq()`](https://tbep-tech.github.io/tbeptools/reference/read_formwq.md)
  to return all parameters
- Added FIB reporting functions and vignette (EPC and baywide)
- Added functions and vignette content supporting reasonable assurance
  reporting
- Mockery used for testing with web requests when able
- Numerous bug fixes and minor feature additions
- KC added as author

## tbeptools 2.0.1

- Consistent color scheme established across all report cards (red,
  yellow, green, light blue, dark orange, brown)
- `benthicdata` updated with 2020 results; default arguments changed to
  2020
- Updated download paths for `read_importwq` and `read_importbenthic`
  following EPCHC platform migration
- CITATION file added

## tbeptools 2.0.0

- Turbidity and color added as output from
  [`read_formwq()`](https://tbep-tech.github.io/tbeptools/reference/read_formwq.md)
- Added `width` and `height` arguments to `show_` functions creating
  plotly output
- Legend title fix in
  [`show_segplotly()`](https://tbep-tech.github.io/tbeptools/reference/show_segplotly.md)
- Added `family` argument for text family to
  [`show_tbniscr()`](https://tbep-tech.github.io/tbeptools/reference/show_tbniscr.md)
- Output factor order of bay segments in
  [`anlz_tbbimed()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.md)
  changed
- Global font changes to
  [`show_thrplot()`](https://tbep-tech.github.io/tbeptools/reference/show_thrplot.md)
  and
  [`show_boxplot()`](https://tbep-tech.github.io/tbeptools/reference/show_boxplot.md)
- Added `size` argument to
  [`show_tdlcrkmatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkmatrix.md)
- `transect` object updated with 2021 results; default year arguments
  changed
- Added `sppcol` argument for color in
  [`show_transect()`](https://tbep-tech.github.io/tbeptools/reference/show_transect.md);
  Caulerpa default color changed
- All default arguments with 2019 updated to 2021
- `trnpts` and `trnlns` data objects updated
- All plotly objects default download option set to SVG
- Updated URL download locations for all EPC data
- Removed `read_chkdate`; simplified EPC file import workflow

## tbeptools 1.1.0

- Release for JOSS paper

## tbeptools 1.0.2

- Added `raw` argument to
  [`read_transect()`](https://tbep-tech.github.io/tbeptools/reference/read_transect.md)
  for unformatted transect results
- Functions organized by concept on reference website
- [`anlz_tdlcrkindic()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrkindic.md)
  updated to include DO saturation exceedances
- `seagrass` data object includes 2020 estimates
- `yrrng` argument in
  [`show_matrix()`](https://tbep-tech.github.io/tbeptools/reference/show_matrix.md)
  defaults to input data range
- Added
  [`show_tdlcrkradar()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkradar.md)
  plot function
- Added `radar` argument to
  [`anlz_tdlcrkindic()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrkindic.md)
  for
  [`show_tdlcrkradar()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkradar.md)
  output specification
- Package dependencies reduced for R CMD check compliance
- `tidalcreeks` and `iwrraw` data updated for IWR run 61
- Training year returned for multiple years in
  [`read_formtransect()`](https://tbep-tech.github.io/tbeptools/reference/read_formtransect.md)
- Added `yr` argument to
  [`show_compplot()`](https://tbep-tech.github.io/tbeptools/reference/show_compplot.md)
  for training year selection
- `fimdata` and `fimstations` updated with 2020 results
- Minor bug fixes for
  [`read_formfim()`](https://tbep-tech.github.io/tbeptools/reference/read_formfim.md)
  bay segment assignments
- Benthic data import/formatting no longer uses RODBC; now uses zipped
  CSV files
- `benthicdata` updated with 2019 results
- Added `sgseg` and `sgmanagement` objects for seagrass boundaries

## tbeptools 1.0.0

- Initial release
