# all data from key Enterococcus stations, 1995-2023
# although apparently data collection only started in 2000 at the earliest of these stations
library(here)

enterodata <- read_importentero(startDate = '1995-01-01', endDate = '2023-12-31') %>%
  dplyr::select(-qualifier,
                -LabComments)

save(enterodata, file = here('data/enterodata.RData'), compress = 'xz')
