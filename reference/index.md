# Package index

## Read data

Functions for reading data.

- [`read_dlcurrent()`](https://tbep-tech.github.io/tbeptools/reference/read_dlcurrent.md)
  : Download latest file from epchc.org

- [`read_formbenthic()`](https://tbep-tech.github.io/tbeptools/reference/read_formbenthic.md)
  : Format benthic data for the Tampa Bay Benthic Index

- [`read_formfib()`](https://tbep-tech.github.io/tbeptools/reference/read_formfib.md)
  : Format Fecal Indicator Bacteria (FIB) data

- [`read_formfim()`](https://tbep-tech.github.io/tbeptools/reference/read_formfim.md)
  : Format FIM data for the Tampa Bay Nekton Index

- [`read_formphyto()`](https://tbep-tech.github.io/tbeptools/reference/read_formphyto.md)
  : Format phytoplankton data

- [`read_formsediment()`](https://tbep-tech.github.io/tbeptools/reference/read_formsediment.md)
  : Format sediment data

- [`read_formtransect()`](https://tbep-tech.github.io/tbeptools/reference/read_formtransect.md)
  : Format seagrass transect data from Water Atlas

- [`read_formwq()`](https://tbep-tech.github.io/tbeptools/reference/read_formwq.md)
  : Format water quality data

- [`read_formwqp()`](https://tbep-tech.github.io/tbeptools/reference/read_formwqp.md)
  : Format data and station metadata from the Water Quality Portal

- [`read_importbenthic()`](https://tbep-tech.github.io/tbeptools/reference/read_importbenthic.md)
  : Download and import benthic data for Tampa Bay

- [`read_importentero()`](https://tbep-tech.github.io/tbeptools/reference/read_importentero.md)
  : Download Enterococcus data from the Water Quality Portal

- [`read_importepc()`](https://tbep-tech.github.io/tbeptools/reference/read_importepc.md)
  : Download and/or import local water quality file for internal use

- [`read_importfib()`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)
  : Load local water quality file for Fecal Indicator Bacteria (FIB)

- [`read_importfim()`](https://tbep-tech.github.io/tbeptools/reference/read_importfim.md)
  : Load local FIM data for the Tampa Bay Nekton Index

- [`read_importphyto()`](https://tbep-tech.github.io/tbeptools/reference/read_importphyto.md)
  : Load local phytoplankton cell count file

- [`read_importprism()`](https://tbep-tech.github.io/tbeptools/reference/read_importprism.md)
  : Import PRISM daily weather data

- [`read_importrain()`](https://tbep-tech.github.io/tbeptools/reference/read_importrain.md)
  : Download daily precip data and summarise by station catchment

- [`read_importrainmany()`](https://tbep-tech.github.io/tbeptools/reference/read_importrainmany.md)
  :

  Run `read_importrain` for multiple years

- [`read_importsealevels()`](https://tbep-tech.github.io/tbeptools/reference/read_importsealevels.md)
  : Import monthly sea levels by station from NOAA Tides and Currents

- [`read_importsediment()`](https://tbep-tech.github.io/tbeptools/reference/read_importsediment.md)
  : Download and import sediment data for Tampa Bay

- [`read_importwq()`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)
  : Load local water quality file

- [`read_importwqp()`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md)
  : Import data from the Water Quality Portal

- [`read_importwqwa()`](https://tbep-tech.github.io/tbeptools/reference/read_importwqwa.md)
  : Import data from the Water Atlas API

- [`read_importwqwin()`](https://tbep-tech.github.io/tbeptools/reference/read_importwqwin.md)
  : Retrieve water quality data from the Florida Department of
  Environmental Protection's Watershed Information Network (WIN)

- [`read_prism_rasters()`](https://tbep-tech.github.io/tbeptools/reference/read_prism_rasters.md)
  : Read PRISM raster layers into data frame

- [`read_transect()`](https://tbep-tech.github.io/tbeptools/reference/read_transect.md)
  : Import JSON seagrass transect data from Water Atlas

## Analyze data

Functions for analyzing data.

- [`anlz_attain()`](https://tbep-tech.github.io/tbeptools/reference/anlz_attain.md)
  : Get attainment categories
- [`anlz_attainsite()`](https://tbep-tech.github.io/tbeptools/reference/anlz_attainsite.md)
  : Get site attainments
- [`anlz_avedat()`](https://tbep-tech.github.io/tbeptools/reference/anlz_avedat.md)
  : Estimate annual means
- [`anlz_avedatsite()`](https://tbep-tech.github.io/tbeptools/reference/anlz_avedatsite.md)
  : Estimate annual means by site
- [`anlz_enteromap()`](https://tbep-tech.github.io/tbeptools/reference/anlz_enteromap.md)
  : Assign threshold categories to Enterococcus data
- [`anlz_fibmap()`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmap.md)
  : Assign threshold categories to Fecal Indicator Bacteria (FIB) data
- [`anlz_fibmatrix()`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmatrix.md)
  : Analyze Fecal Indicator Bacteria categories over time by station or
  bay segment
- [`anlz_fibwetdry()`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibwetdry.md)
  : Identify Fecal Indicator Bacteria samples as coming from a 'wet' or
  'dry' time period
- [`anlz_hmpreport()`](https://tbep-tech.github.io/tbeptools/reference/anlz_hmpreport.md)
  : Evaluate Habitat Master Plan progress for report card
- [`anlz_hydroload()`](https://tbep-tech.github.io/tbeptools/reference/anlz_hydroload.md)
  : Estimate hydrological estimates and adjustment factors for bay
  segments
- [`anlz_iwrraw()`](https://tbep-tech.github.io/tbeptools/reference/anlz_iwrraw.md)
  : Format raw IWR data
- [`anlz_refs()`](https://tbep-tech.github.io/tbeptools/reference/anlz_refs.md)
  : Convert references csv to bib
- [`anlz_sedimentaddtot()`](https://tbep-tech.github.io/tbeptools/reference/anlz_sedimentaddtot.md)
  : Add contaminant totals to sediment data
- [`anlz_sedimentave()`](https://tbep-tech.github.io/tbeptools/reference/anlz_sedimentave.md)
  : Get average concentrations for a sediment parameter by bay segment
- [`anlz_sedimentpel()`](https://tbep-tech.github.io/tbeptools/reference/anlz_sedimentpel.md)
  : Get sediment PEL ratios at stations in Tampa Bay
- [`anlz_sedimentpelave()`](https://tbep-tech.github.io/tbeptools/reference/anlz_sedimentpelave.md)
  : Get average concentrations for a sediment parameter by bay segment
- [`anlz_splitdata()`](https://tbep-tech.github.io/tbeptools/reference/anlz_splitdata.md)
  : Analyze time series data split by date within years
- [`anlz_splitstorms()`](https://tbep-tech.github.io/tbeptools/reference/anlz_splitstorms.md)
  : Analyze storm data split by date within years
- [`anlz_tbbimed()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbimed.md)
  : Get annual medians of Tampa Bay Benthic Index scores by bay segment
- [`anlz_tbbiscr()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbiscr.md)
  : Get Tampa Bay Benthic Index scores
- [`anlz_tbniave()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniave.md)
  : Get annual averages of Tampa Bay Nekton Index scores by bay segment
- [`anlz_tbnimet()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbnimet.md)
  : Get all raw metrics for Tampa Bay Nekton Index
- [`anlz_tbniscr()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniscr.md)
  : Get Tampa Bay Nekton Index scores
- [`anlz_tdlcrk()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrk.md)
  : Estimate tidal creek report card scores
- [`anlz_tdlcrkindic()`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrkindic.md)
  : Analyze tidal creek water quality indicators
- [`anlz_transectave()`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectave.md)
  : Get annual averages of seagrass frequency occurrence by bay segments
  and year
- [`anlz_transectavespp()`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectavespp.md)
  : Get annual averages of seagrass frequency occurrence by bay
  segments, year, and species
- [`anlz_transectocc()`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectocc.md)
  : Get seagrass average abundance and occurrence across transects
- [`anlz_yrattain()`](https://tbep-tech.github.io/tbeptools/reference/anlz_yrattain.md)
  : Get attainment categories for a chosen year

## Show data

Functions for plotting data.

- [`show_annualassess()`](https://tbep-tech.github.io/tbeptools/reference/show_annualassess.md)
  : Create a table for the annual management outcome assessments
- [`show_boxplot()`](https://tbep-tech.github.io/tbeptools/reference/show_boxplot.md)
  : Plot monthly chlorophyll or light attenuation values for a segment
- [`show_compplot()`](https://tbep-tech.github.io/tbeptools/reference/show_compplot.md)
  : Make a bar plot for transect training group comparisons
- [`show_enteromap()`](https://tbep-tech.github.io/tbeptools/reference/show_enteromap.md)
  : Map Enterococcus results by month, year, and location
- [`show_fibmap()`](https://tbep-tech.github.io/tbeptools/reference/show_fibmap.md)
  : Map Fecal Indicator Bacteria (FIB) results by month, year, and
  location
- [`show_fibmatmap()`](https://tbep-tech.github.io/tbeptools/reference/show_fibmatmap.md)
  : Map Fecal Indicator Bacteria matrix results by year
- [`show_fibmatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_fibmatrix.md)
  : Plot a matrix of Fecal Indicator Bacteria categories over time by
  station or bay segment
- [`show_hmpreport()`](https://tbep-tech.github.io/tbeptools/reference/show_hmpreport.md)
  : Show Habitat Master Plan progress report card
- [`show_matrix()`](https://tbep-tech.github.io/tbeptools/reference/show_matrix.md)
  : Create a colorized table for indicator reporting
- [`show_matrixplotly()`](https://tbep-tech.github.io/tbeptools/reference/show_matrixplotly.md)
  : Creates a plotly matrix from any matrix function input
- [`show_ratab()`](https://tbep-tech.github.io/tbeptools/reference/show_ratab.md)
  : Create a bay segment assessment table for the 2022-2026 reasonable
  assurance period
- [`show_reactable()`](https://tbep-tech.github.io/tbeptools/reference/show_reactable.md)
  : Create reactable table from matrix data
- [`show_seagrasscoverage()`](https://tbep-tech.github.io/tbeptools/reference/show_seagrasscoverage.md)
  : Create a barplot of seagrass coverage over time in Tampa Bay
- [`show_sedimentalratio()`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentalratio.md)
  : Plot metal concentrations against aluminum
- [`show_sedimentave()`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentave.md)
  : Plot sediment concentration averages by bay segment
- [`show_sedimentmap()`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentmap.md)
  : Make a map for sediment contaminants at stations in Tampa Bay
- [`show_sedimentpelave()`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentpelave.md)
  : Plot summary of PEL averages by bay segment
- [`show_sedimentpelaveplotly()`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentpelaveplotly.md)
  : Creates a plotly object for average PEL plots
- [`show_sedimentpelmap()`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentpelmap.md)
  : Make a map for sediment PEL ratios at stations in Tampa Bay
- [`show_segmatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_segmatrix.md)
  : Create a colorized table for water quality outcomes and exceedances
  by segment
- [`show_segplotly()`](https://tbep-tech.github.io/tbeptools/reference/show_segplotly.md)
  : Plot chlorophyll and secchi data together with matrix outcomes
- [`show_sitemap()`](https://tbep-tech.github.io/tbeptools/reference/show_sitemap.md)
  : Map site attainment categories for a selected year
- [`show_sitesegmap()`](https://tbep-tech.github.io/tbeptools/reference/show_sitesegmap.md)
  : Map site and bay segment attainment categories for a selected year
- [`show_splitbarplot()`](https://tbep-tech.github.io/tbeptools/reference/show_splitbarplot.md)
  : Show a Split Bar Plot with Error Bars
- [`show_tbbimatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_tbbimatrix.md)
  : Plot a matrix of Tampa Bay Benthic Index scores over time by bay
  segment
- [`show_tbnimatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_tbnimatrix.md)
  : Plot a matrix of Tampa Bay Nekton Index scores over time by bay
  segment
- [`show_tbniscr()`](https://tbep-tech.github.io/tbeptools/reference/show_tbniscr.md)
  : Plot Tampa Bay Nekton Index scores over time by bay segment
- [`show_tbniscrall()`](https://tbep-tech.github.io/tbeptools/reference/show_tbniscrall.md)
  : Plot Tampa Bay Nekton Index scores over time as average across bay
  segments
- [`show_tbniscrplotly()`](https://tbep-tech.github.io/tbeptools/reference/show_tbniscrplotly.md)
  : Creates a plotly object for TBNI score plots
- [`show_tdlcrk()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrk.md)
  : Make a map for tidal creek report card
- [`show_tdlcrkindic()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkindic.md)
  : Plotly barplots of tidal creek context indicators
- [`show_tdlcrkindiccdf()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkindiccdf.md)
  : Plotly empirical CDF plots of tidal creek context indicators
- [`show_tdlcrkline()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkline.md)
  : Add a line or annotation to a plotly graph
- [`show_tdlcrkmatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkmatrix.md)
  : Plot the tidal creek report card matrix
- [`show_tdlcrkradar()`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkradar.md)
  : Radar plots for tidal creek indicators
- [`show_thrplot()`](https://tbep-tech.github.io/tbeptools/reference/show_thrplot.md)
  : Plot annual water quality values, targets, and thresholds for a
  segment
- [`show_transect()`](https://tbep-tech.github.io/tbeptools/reference/show_transect.md)
  : Plot results for a seagrass transect by time and location
- [`show_transectavespp()`](https://tbep-tech.github.io/tbeptools/reference/show_transectavespp.md)
  : Show annual averages of seagrass frequency occurrence by bay
  segments, year, and species
- [`show_transectmatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_transectmatrix.md)
  : Show matrix of seagrass frequency occurrence by bay segments and
  year
- [`show_transectsum()`](https://tbep-tech.github.io/tbeptools/reference/show_transectsum.md)
  : Plot frequency occurrence for a seagrass transect by time for all
  species
- [`show_wqmatrix()`](https://tbep-tech.github.io/tbeptools/reference/show_wqmatrix.md)
  : Create a colorized table for chlorophyll or light attenuation
  exceedances

## Internal datasets

Supporting datasets used by the other functions.

- [`acres`](https://tbep-tech.github.io/tbeptools/reference/acres.md) :
  Tampa Bay intertidal and supratidal land use and cover
- [`benthicdata`](https://tbep-tech.github.io/tbeptools/reference/benthicdata.md)
  : Benthic data for the Tampa Bay Benthic Index current as of 20251225
- [`bsmap`](https://tbep-tech.github.io/tbeptools/reference/bsmap.md) :
  Terrain basemap
- [`catchpixels`](https://tbep-tech.github.io/tbeptools/reference/catchpixels.md)
  : Catchments and radar pixels (for precip) of selected Enterococcus
  stations
- [`catchprecip`](https://tbep-tech.github.io/tbeptools/reference/catchprecip.md)
  : Daily precip by catchment for selected Enterococcus stations
- [`enterodata`](https://tbep-tech.github.io/tbeptools/reference/enterodata.md)
  : Enterococcus data from 53 key Enterococcus stations since 1995
- [`epcdata`](https://tbep-tech.github.io/tbeptools/reference/epcdata.md)
  : All bay data as of 20250210
- [`fibdata`](https://tbep-tech.github.io/tbeptools/reference/fibdata.md)
  : All Fecal Indicator Bacteria (FIB) data as of 20260108
- [`fimdata`](https://tbep-tech.github.io/tbeptools/reference/fimdata.md)
  : FIM data for Tampa Bay Nekton Index current as of 09032025
- [`fimstations`](https://tbep-tech.github.io/tbeptools/reference/fimstations.md)
  : Spatial data object of FIM stations including Tampa Bay segments
- [`hcesdfibdata`](https://tbep-tech.github.io/tbeptools/reference/hcesdfibdata.md)
  : Hillsborough County Environmental Services Division (ESD) FIB data
  as of 20260108
- [`hmptrgs`](https://tbep-tech.github.io/tbeptools/reference/hmptrgs.md)
  : Habitat Master Plan targets and goals
- [`iwrraw`](https://tbep-tech.github.io/tbeptools/reference/iwrraw.md)
  : FDEP IWR run 67
- [`mancofibdata`](https://tbep-tech.github.io/tbeptools/reference/mancofibdata.md)
  : Manatee County FIB data as of 20260108
- [`pascofibdata`](https://tbep-tech.github.io/tbeptools/reference/pascofibdata.md)
  : Pasco County FIB data as of 20260108
- [`phytodata`](https://tbep-tech.github.io/tbeptools/reference/phytodata.md)
  : Phytoplankton data current as of 10312024
- [`polcofibdata`](https://tbep-tech.github.io/tbeptools/reference/polcofibdata.md)
  : Polk County FIB data as of 20260108
- [`seagrass`](https://tbep-tech.github.io/tbeptools/reference/seagrass.md)
  : Seagrass coverage by year
- [`sealevelstations`](https://tbep-tech.github.io/tbeptools/reference/sealevelstations.md)
  : Sea level stations in Tampa Bay
- [`sedimentdata`](https://tbep-tech.github.io/tbeptools/reference/sedimentdata.md)
  : Sediment data for the Tampa Bay current as of 20251210
- [`sgmanagement`](https://tbep-tech.github.io/tbeptools/reference/sgmanagement.md)
  : Seagrass management areas for Tampa Bay
- [`sgseg`](https://tbep-tech.github.io/tbeptools/reference/sgseg.md) :
  Seagrass segment reporting boundaries for southwest Florida
- [`stations`](https://tbep-tech.github.io/tbeptools/reference/stations.md)
  : Bay stations by segment
- [`subtacres`](https://tbep-tech.github.io/tbeptools/reference/subtacres.md)
  : Tampa Bay subtidal cover
- [`swfwmdtbseg`](https://tbep-tech.github.io/tbeptools/reference/swfwmdtbseg.md)
  : Spatial data object of SWFWMD Tampa Bay segments
- [`swfwmdtbseg2024`](https://tbep-tech.github.io/tbeptools/reference/swfwmdtbseg2024.md)
  : Spatial data object of SWFWMD Tampa Bay segments, 2024
- [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md)
  : Bay segment targets
- [`tbniref`](https://tbep-tech.github.io/tbeptools/reference/tbniref.md)
  : Reference conditions for Tampa Bay Nekton Index metrics
- [`tbnispp`](https://tbep-tech.github.io/tbeptools/reference/tbnispp.md)
  : Reference table for Tampa Bay Nekton Index species classifications
- [`tbseg`](https://tbep-tech.github.io/tbeptools/reference/tbseg.md) :
  Spatial data object of Tampa Bay segments
- [`tbsegdetail`](https://tbep-tech.github.io/tbeptools/reference/tbsegdetail.md)
  : Spatial data object of detailed Tampa Bay segments
- [`tbsegdetailbcbs`](https://tbep-tech.github.io/tbeptools/reference/tbsegdetailbcbs.md)
  : Spatial data object of detailed Tampa Bay segments, Boca Ciega Bay
  as southern portion
- [`tbseglines`](https://tbep-tech.github.io/tbeptools/reference/tbseglines.md)
  : Spatial data object of lines defining major Tampa Bay segments
- [`tbsegshed`](https://tbep-tech.github.io/tbeptools/reference/tbsegshed.md)
  : Spatial data object of Tampa Bay segments plus watersheds
- [`tbshed`](https://tbep-tech.github.io/tbeptools/reference/tbshed.md)
  : Spatial data object of Tampa Bay watershed
- [`tidalcreeks`](https://tbep-tech.github.io/tbeptools/reference/tidalcreeks.md)
  : Spatial data object of tidal creeks in Impaired Waters Rule, Run 67
- [`tidaltargets`](https://tbep-tech.github.io/tbeptools/reference/tidaltargets.md)
  : Tidal creek nitrogen targets
- [`transect`](https://tbep-tech.github.io/tbeptools/reference/transect.md)
  : Seagrass transect data for Tampa Bay current as of 12052025
- [`trnlns`](https://tbep-tech.github.io/tbeptools/reference/trnlns.md)
  : Seagrass transect locations
- [`trnpts`](https://tbep-tech.github.io/tbeptools/reference/trnpts.md)
  : Seagrass transect starting locations

## Utility functions

Utility functions used by other functions.

- [`util_dateseq()`](https://tbep-tech.github.io/tbeptools/reference/util_dateseq.md)
  : Generate a two-column data frame of dates
- [`util_fibicons()`](https://tbep-tech.github.io/tbeptools/reference/util_fibicons.md)
  : Return leaflet icon set for FIB maps
- [`util_fiblevs()`](https://tbep-tech.github.io/tbeptools/reference/util_fiblevs.md)
  : A list of Fecal Indicator Bacteria (FIB) factor levels and labels
- [`util_frmyrrng()`](https://tbep-tech.github.io/tbeptools/reference/util_frmyrrng.md)
  : Format a Vector of Years into a Concise Range
- [`util_html()`](https://tbep-tech.github.io/tbeptools/reference/util_html.md)
  : Convert character string to html class
- [`util_importwqwa()`](https://tbep-tech.github.io/tbeptools/reference/util_importwqwa.md)
  : Retrieve metadata from the Water Atlas API
- [`util_importwqwin()`](https://tbep-tech.github.io/tbeptools/reference/util_importwqwin.md)
  : Utility function to retrieve water quality data from the Florida
  Department of Environmental Protection's Watershed Information Network
  (WIN)
- [`util_map()`](https://tbep-tech.github.io/tbeptools/reference/util_map.md)
  : Create an empty leaflet map from sf input
- [`util_orgin()`](https://tbep-tech.github.io/tbeptools/reference/util_orgin.md)
  : Get organization name from organization identifier in USEPA Water
  Quality Portal
- [`util_rain()`](https://tbep-tech.github.io/tbeptools/reference/util_rain.md)
  : Get rainfall data at NOAA NCDC sites
