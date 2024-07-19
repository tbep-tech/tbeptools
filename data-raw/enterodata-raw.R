# all data from key Enterococcus stations, 1995-2023
# although apparently data collection only started in 2000 at the earliest of these stations
library(here)

stations <- unique(catchprecip$station)
entero_names <- c('Enterococci',
                  'Enterococcus')
startDate <- as.Date('1995-01-01')
endDate <- as.Date('2023-12-31')

args <- list(
  siteid = stations,
  characteristicName = entero_names,
  startDateLo = format(startDate, '%m-%d-%Y'),
  startDateHi = format(endDate, '%m-%d-%Y')
)
# date format has to be mm-dd-yyyy

enterodata <- read_importentero(args = args) %>%
  dplyr::select(-qualifier,
                -LabComments)

save(enterodata, file = here('data/enterodata.RData'), compress = 'xz')
