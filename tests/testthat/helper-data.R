library(tbeptools)
library(dplyr)

# data for tidal creek radar plots
cntdatrdr <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2023, radar = TRUE)

# data for tidal creek indicator plots
cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2023)

# tidal creek scores
tdldat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2023)

# benthic index scores
tbbiscr <- anlz_tbbiscr(benthicdata)

# transect freq occ
transectocc <- anlz_transectocc(transect)
