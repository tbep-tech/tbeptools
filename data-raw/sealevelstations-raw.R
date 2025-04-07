librarian::shelf(
  dplyr, httr2, purrr)

sealevelstations <- tibble::tribble(
  ~station_id, ~station_name,
  8726724    , "Clearwater Beach",
  8726674    , "East Bay",
  8726384    , "Port Manatee",
  8726520    , "St. Petersburg")

get_stations <- function(
    station_id,
    api_url = "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations"){

  httr2::request(api_url) %>%
    req_url_path_append(
      paste0(station_id, ".json")) %>%
    req_perform() %>%
    resp_body_json() %>%
    (\(x) x$stations[[1]])()
}

get_details <- function(
    station_id,
    api_url = "https://api.tidesandcurrents.noaa.gov/mdapi/prod/webapi/stations"){

  httr2::request(api_url) %>%
    req_url_path_append(
      station_id, "details.json") %>%
    req_perform() %>%
    resp_body_json()
}

sealevelstations <- sealevelstations %>%
  mutate(
    lst_station = map(station_id, get_stations),
    longitude   = map_dbl(lst_station, "lng"),
    latitude    = map_dbl(lst_station, "lat"),
    lst_details = map(station_id, get_details),
    date_est    = map_chr(lst_details, "established") %>%
      as.Date() ) %>%
  select(-lst_station, -lst_details)

save(sealevelstations, file = 'data/sealevelstations.RData', compress = 'xz')
