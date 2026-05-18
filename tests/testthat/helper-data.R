library(tbeptools)
library(dplyr)
library(mockery)

# data for tidal creek radar plots
cntdatrdr <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2025, radar = TRUE)

# data for tidal creek indicator plots
cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2025)

# tidal creek scores
tdldat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2025)

# benthic index scores
tbbiscr <- anlz_tbbiscr(benthicdata)

# AMBI scores
ambiscr    <- anlz_ambiscr(benthicdata)
ambiscr_tb <- anlz_ambiscr(benthicdata, type = 'AMBI-TB')

# transect freq occ
transectocc <- anlz_transectocc(transect)
