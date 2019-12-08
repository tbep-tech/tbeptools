library(sf)
library(tidyverse)
library(haven)
# library(glue)

prj <- 4326

tidalcreeks <- st_read(dsn = '../../02_DOCUMENTS/tidal_creeks/Creek_ReportCard_revised.shp', drivers = 'ESRI Shapefile') %>%
  st_transform(crs = prj) %>%
  select(wbid = WBID, JEI = CreekID, class) %>%
  mutate_if(is.factor, as.character)

crkraw <- read_sas('../../02_DOCUMENTS/tidal_creeks/creek_pop.sas7bdat')
iwrraw <- read_sas('../../02_DOCUMENTS/tidal_creeks/iwr56_tidalcreeks.sas7bdat')

# wbid <- '1983B'
# urlin <- glue('https://ca.dep.state.fl.us/arcgis/rest/services/OpenData/IMPAIRED_WATERS/MapServer/1/query?where=UPPER(WATERBODY_ID)%20like%20%27%25{wbid}%25%27&outFields=*&outSR=4326&f=json')
# tmp <- fromJSON(urlin)

yr <- 2018

# mcodes <- c("CHLAC","CHLA_ ", "COLOR", "COND", "DO", "DOSAT", "DO_MG", "NO23_", "NO3O2", "ORGN", "SALIN", "TKN", "TKN_M", "TN", "TN_MG", "TP", "TPO4_",
#   "TP_MG", "TSS", "TSS_M", "TURB")
mcodes <- c("TN", "TN_MG")

# format iwr data
# filter out some data, recode masterCode, take averages by year
# spread by masterCode
iwrdat <- iwrraw %>%
  select(wbid, class, JEI, year, masterCode, result) %>%
  filter(wbid %in% unique(creek_pop$WBID) & JEI %in% unique(creek_pop$JEI)) %>%
  filter(year > yr - 11) %>%
  filter(masterCode %in% mcodes) %>%
  filter(!is.na(result) & result > 0) %>%
  mutate(
    masterCode = case_when(
      masterCode %in% c('NO23_', 'NO3O2') ~ 'NO23',
      masterCode %in% 'TKN_M' ~ 'TKN',
      masterCode %in% 'TN_MG' ~ 'TN',
      masterCode %in% c('TPO4_', 'TP_MG') ~ 'TP',
      masterCode %in% 'TSS_M' ~ 'TSS',
      T ~ masterCode
    ),
    result = log(result)
  ) %>%
  group_by(wbid, class, JEI, year, masterCode) %>%
  summarise(
    result = mean(result)
  ) %>%
  ungroup %>%
  mutate(result = exp(result)) %>%
  spread(masterCode, result)

# format creek pop
crkdat <- crkraw %>%
  select(wbid = WBID, class = CLASS, JEI, Creek_Length_m) %>%
  filter(!is.na(Creek_Length_m)) %>%
  unique
#
# if substr(jei,1,2) in ("PC","LC") then do; tn_threshold = 1.54; action=1.36;end;
#
# if class in ("3F","1") then do;
#   if TN > tn_threshold then grade=4;
#   else
#     if action<=tn<=tn_threshold then grade=3;
#     else grade=1;
# end;

# left join creek data to iwrdat and add thresholds
alldat <- iwrdat %>%
  left_join(crkdat, by = c('wbid', 'class', 'JEI')) %>%
  mutate(
    tn_threshold = case_when(
      !is.na(Creek_Length_m) ~ 1.65,
      !is.na(Creek_Length_m) & grepl('^PC|^LC', JEI) ~ 1.54
    ),
    action = case_when(
      !is.na(Creek_Length_m) ~ 1.46,
      !is.na(Creek_Length_m) & grepl('^PC|^LC', JEI) ~ 1.36
    ),
    grade = case_when(
      class %in% c('3F', '1') & TN > tn_threshold ~ 4,
      class %in% c('3F', '1') & TN <= tn_threshold & action <= TN ~ 3,
      class %in% c('3F', '1') & TN < action ~ 1
    )#,
    # caution = case_when(
    #
    #   class %in% c('3M', '2') ~
    # )
  )


