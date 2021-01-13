# create tidal creek nitrogen targets -------------------------------------

tidaltargets <- data.frame(
  region = c("West Central", "Peninsula"),
  prioritize = c(1.65, 1.54),
  investigate = c(1.38, 1.30),
  caution = c("1.38 - 0.0174 * (23.78 - (Creek_Length_m / 1000))", "1.30 - 0.0174 * (23.78 - (Creek_Length_m / 1000))"),
  stringsAsFactors = FALSE
)

save(tidaltargets, file = 'data/tidaltargets.RData', compress = 'xz')
