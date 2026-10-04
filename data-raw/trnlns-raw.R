library(sf)
library(dplyr)

# ami transcts added 2026
trnlnsami <- st_read('T:/05_GIS/SEAGRASS_TRANSECTS/AMI_TRANSECTS/AMI_New_Transects_S4T16_S4T17_Lines.shp') |> 
  mutate(
    MonAgency = 'TBEP', 
    ActiveYN = 'YES', 
    Comments = NA_character_,
    OBJECTID = c(1, 2)
  ) |> 
  select(OBJECTID, Site = TRANSECT_I, Shape_Leng = DISTANCE, MonAgency, ActiveYN, Comments)

trnlns <- st_read('T:/05_GIS/SEAGRASS_TRANSECTS/transect_routes.shp') %>%
  st_transform(crs = 4326) %>%
  dplyr::filter(!as.character(Site) %in% c('S8T1', 'S8T2', 'S8T3', 'S3T2')) %>%
  dplyr::mutate_if(is.factor, as.character) %>%
  dplyr::bind_rows(trnlnsami) |> 
  dplyr::filter(Site %in% trnpts$TRAN_ID)

# add bearing, positive counter-clockwise from east
bearing <- lapply(trnlns$geometry, function(x) geosphere::bearing(x[, c(1:2)])[[1]]) %>%
  unlist()

trnlns$bearing <- bearing

# add bay segment using trnpts
bayseg <- trnpts %>%
  dplyr::select(TRAN_ID, bay_segment) %>%
  sf::st_set_geometry(NULL)
trnlns <- trnlns %>%
  dplyr::left_join(bayseg, by = c('Site' = 'TRAN_ID'))

save(trnlns, file = 'data/trnlns.RData', compress = 'xz')
