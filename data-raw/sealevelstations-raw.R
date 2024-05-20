sealevelstations <- tibble::tribble(
  ~station_id, ~station_name,
  8726724    , "Clearwater Beach",
  8726674    , "East Bay",
  8726384    , "Port Manatee",
  8726520    , "St. Petersburg")

save(sealevelstations, file = 'data/sealevelstations.RData', compress = 'xz')
