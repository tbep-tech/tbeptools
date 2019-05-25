# EPC station, segment data file ---------------------------------------------

library(tidyverse)

# stations by bay segment
stations <- list(
  OTB = c(36, 38, 40, 41, 46, 47, 50, 51, 60, 63, 64, 65, 66, 67, 68),
  HB = c(6, 7, 8, 44, 52, 55, 70, 71, 73, 80),
  MTB = c(9, 11, 81, 84, 13, 14, 32, 33, 16, 19, 28, 82),
  LTB = c(23, 24, 25, 90, 91, 92, 93, 95)
  ) %>%
  enframe('bay_segment', 'epchc_station') %>%
  unnest %>%
  data.frame(stringsAsFactors = F)

save(stations, file = 'data/stations.RData', compress = 'xz')
