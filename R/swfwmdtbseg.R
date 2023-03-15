#' Spatial data object of SWFWMD Tampa Bay segments
#'
#' Spatial data object of SWFWMD Tampa Bay segments
#'
#' @format A simple features \code{\link[sf]{sf}} object (MULTIPOLYGON) with 7 features and 1 fields, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' library(sf)
#' library(dplyr)
#'
#' levs <- c('oldTampaBay', 'hillsboroughBay', 'middleTampaBay',
#'   'lowerTampaBay', 'bocaCiegaBay', 'terraCieaBay', 'manateeRiver')
#' labs <- c('Old Tampa Bay', 'Hillsborough Bay', 'Middle Tampa Bay',
#'   'Lower Tampa Bay', 'Boca Ciega Bay', 'Terra Ceia Bay', 'Manatee River')
#'
#' swfwmdtbseg <- st_read(
#'     dsn = 'T:/05_GIS/SWFWMD/Seagrass/2022_Seagrass/DraftMaps2022_1130.gdb',
#'     layer = 'suncoastSeagrassSegments'
#'   ) %>%
#'   filter(waterbodyName %in% levs) %>%
#'   mutate(
#'     waterbodyName = factor(waterbodyName, levels = levs, labels = labs)
#'   ) %>%
#'   select(segment = waterbodyName) %>%
#'   st_transform(crs = 4326)
#'
#' save(swfwmdtbseg, file = 'data/swfwmdtbseg.RData', compress = 'xz')
#' }
"swfwmdtbseg"



