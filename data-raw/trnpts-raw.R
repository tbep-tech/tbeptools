library(sf)
library(dplyr)
library(tbeptools)

trnpts <- st_read('T:/05_GIS/SEAGRASS_TRANSECTS/TransectBasics2019.shp') %>%
   st_transform(crs = 4326) %>%
   dplyr::rename(MonAgency = 'MON_AGENCY') %>%
   dplyr::filter(!as.character(TRAN_ID) %in% c('S8T1', 'S8T2', 'S8T3', 'S3T2'))

# s4t10 is slightly outside boundary for lower tampa bay
s4t10 <- trnpts %>%
   dplyr::filter(TRAN_ID %in% 'S4T10') %>%
   dplyr::mutate(bay_segment = 'LTB')

# add new 2026 ami points
trnptsami <- read.csv('T:/05_GIS/SEAGRASS_TRANSECTS/AMI_TRANSECTS/AMI_New_Transects_S4T16_S4T17_Starting_Points.csv') |>
   mutate(
      SEGMENT = 4, 
      TRANSECT = as.numeric(gsub('^S4T', '', TRANSECT_ID)),
      MonAgency = 'TBEP', 
      STATUS = 'ACTIVE', 
      Comments  = NA_character_,
      bay_segment = 'LTB',
      ID = 'START'
   ) |> 
   select(SEGMENT, TRANSECT, TRAN_ID = TRANSECT_ID, Metermark = METER, ID, LAT_DD, LONG_DD, MonAgency, STATUS, Comments, bay_segment) |> 
   st_as_sf(coords = c('LONG_DD', 'LAT_DD'), remove = F, crs = 4326)

trnpts <- trnpts %>%
   sf::st_intersection(sf::st_make_valid(tbsegshed)) %>%
   dplyr::select(-long_name) %>%
   dplyr::mutate_if(is.factor, as.character) %>%
   dplyr::bind_rows(s4t10) |> 
   dplyr::bind_rows(trnptsami)

save(trnpts, file = 'data/trnpts.RData', compress = 'xz')
