# create segment targets file ---------------------------------------------

targets <- data.frame(
    bay_segment = c("OTB", "HB", "MTB", "LTB"),
    name = c("Old Tampa Bay", "Hillsborough Bay", "Middle Tampa Bay", "Lower Tampa Bay"),
    chla_target = c(8.5, 13.2, 7.4, 4.6),
    chla_smallex = c(8.9, 14.1, 7.9, 4.8),
    chla_thresh = c(9.3, 15.0, 8.5, 5.1),
    la_target = c(0.83, 1.58, 0.83, 0.63),
    la_smallex = c(0.86, 1.63, 0.87, 0.66),
    la_thresh = c(0.88, 1.67, 0.91, 0.68),
    stringsAsFactors = FALSE
  )

save(targets, file = 'data/targets.RData', compress = 'xz')
