# tbsegshed minus bay ----------------------------------------------------
library(sf)
library(tidyverse)

dbasinraw <- st_read("T:/05_GIS/BOUNDARIES/TBEP_dBasins_Correct_Projection.shp")
dbasin <- dbasinraw |> 
  rename(long_name = BAYSEGNAME) |> 
  mutate(bay_segment = case_when(
    long_name == "Hillsborough Bay" ~ "HB",
    long_name == "Old Tampa Bay" ~ "OTB",
    long_name == "Middle Tampa Bay" ~ "MTB",
    long_name == "Lower Tampa Bay" ~ "LTB",
    long_name == "Manatee River" ~ "MR",
    long_name == 'Terra Ceia Bay' ~ "TCB",
    long_name == 'Boca Ciega Bay' ~ "BCB",
    TRUE ~ NA_character_
  )) |>
  st_transform(4326) |>
  st_make_valid()

save(dbasin, file = 'data/dbasin.RData', compress = 'xz')

