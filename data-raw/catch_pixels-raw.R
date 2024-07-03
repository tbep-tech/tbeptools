#' Make a data frame associating SWFWMD radar pixels with Enterococcus stations and their catchments

library(tidyverse)
library(sf)

# station, catchment data
catchments <- read_sf('data-raw/TB_Select_Fib_Catchments_Dissolved.shp')

# SWFWMD pixel data
# this will need to be saved to tbeptools
pixels <- read_sf('data-raw/swfwmd_pixel_2_utm_m_83.shp')

# put into same crs and join
catch2 <- st_transform(catchments,
                       crs = st_crs(pixels))

catch_pixels <- st_intersection(pixels, catch2) |>
  sf::st_drop_geometry() |>
  select(PIXEL, StationNam) |>
  separate_wider_delim(StationNam, delim = " + ", names = c('a','b', 'c','d'),
                       too_few = 'align_start', cols_remove = F) |>
  pivot_longer(cols = c(a, b, c, d), names_to = 'col', values_to = 'value') |>
  filter(!is.na(value)) |>
  mutate(
    station = case_when(
      StationNam == '21FLHILL_WQX-102 + 103 + 619' & col != 'a' ~ paste0('21FLHILL_WQX-', value),
      StationNam == '21FLHILL_WQX-596 + 597' & col != 'a' ~ paste0('21FLHILL_WQX-', value),
      StationNam == '21FLHILL_WQX-136 + 264' & col != 'a' ~ paste0('21FLHILL_WQX-', value),
      StationNam == '21FLHILL_WQX-112 + 180' & col != 'a' ~ paste0('21FLHILL_WQX-', value),
      StationNam == '21FLDOH_WQX-MANATEE152 + 153' & col != 'a' ~ paste0('21FLDOH_WQX-', value),
      StationNam == '21FLCOSP_WQX-NORTH CANAL + SOUTH CANAL + CENTRAL *' & col != 'a' ~ paste0('21FLCOSP_WQX-', value),
      StationNam == '21FLPDEM_WQX-39-01 + 39-05' & col != 'a' ~ paste0('21FLPDEM_WQX-', value),
      StationNam == '21FLMANA_WQX-LM3 + LM4 + LM5 + LM6' & col != 'a' ~ paste0('21FLMANA_WQX-', value),
      T ~ value
    ),
    station = case_when(station == '21FLCOSP_WQX-CENTRAL *' ~ '21FLCOSP_WQX-CENTRAL CANAL',
                        T ~ station)
  ) |>
  select(station, pixel = PIXEL)

save(catch_pixels, file = 'data/catch_pixels.RData', compress = 'xz')
