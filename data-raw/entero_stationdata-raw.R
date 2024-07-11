#' compile metadata on key Enterococcus stations
#' primarily so bay segments are easily available

library(dplyr)
library(sf)
library(tbeptools)


# load stations
stns <- unique(catch_precip$station)


# download data to get lat/longs
entero_names <- c('Enterococci',
                  'Enterococcus')
startDate <- as.Date('2013-01-01')
endDate <- as.Date('2023-12-31')
args <- list(
  siteid = stns,
  characteristicName = entero_names,
  startDateLo = format(startDate, '%m-%d-%Y'),
  startDateHi = format(endDate, '%m-%d-%Y')
)

dat_in <- read_importentero(args = args) %>%
  dplyr::select(-qualifier,
                -LabComments)


# refine the data frame
# there are a few with multiple lat/longs, but from eyeballing it nothing
# is obscenely different - so take an average
dat <- dat_in %>%
  select(station, Latitude, Longitude) %>%
  distinct() %>%
  summarize(.by = station,
            latitude = mean(Latitude),
            longitude = mean(Longitude))

# three of our original stations don't show up in the last 10 years
# make sure it's no mistake but otherwise we can ignore - if
# no longer sampled, they won't show up in anything else anyway
stns[which(!(stns %in% dat$station))]



# intersect with spatial object
# containing bay segment delineations

# first make the spatial object valid
tbsegshed2 <- st_make_valid(tbsegshed)

# intersect and refine the data frame
entero_stationdata <- st_as_sf(dat,
                               coords = c("longitude", "latitude"),
                               crs = "EPSG:4326",
                               remove = FALSE) %>%
  st_intersection(tbsegshed2) %>%
  st_drop_geometry() %>%
  rename(bay_segment_abbrev = bay_segment,
         bay_segment = long_name)

# save it
save(entero_stationdata, file = 'data/entero_stationdata.RData', compress = 'xz')

