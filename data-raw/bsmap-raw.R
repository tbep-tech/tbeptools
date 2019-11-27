# basemap for show_sitemap ------------------------------------------------

library(sf)
library(ggmap)
library(tbeptools)

data(tbseg)

# basemap
bbx <- tbseg %>%
  st_buffer(dist = 0.02) %>%
  st_bbox
names(bbx) <- c('left', 'bottom', 'right', 'top')
bsmap <- get_stamenmap(bbox = bbx, zoom = 10,maptype = 'terrain-background')

save(bsmap, file = 'data/bsmap.RData', compress = 'xz')
