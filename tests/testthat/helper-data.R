library(tbeptools)

# data for tidal creek radar plots
cntdatrdr <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2021, radar = TRUE)

# data for tidal creek indicator plots
cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2021)

# tidal creek scores
tdldat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2021)

# benthic index scores
tbbiscr <- anlz_tbbiscr(benthicdata)
