# TBNI species classification reference table -------------------------------

# download rds from tbni-proc repo
download.file(
  'https://raw.githubusercontent.com/tbep-tech/tbni-proc/master/data/TBIndex_spp_codes.rds',
  destfile = 'data-raw/tbnispp.rds',
  mode = 'wb'
)

tbnispp <- readRDS('data-raw/tbnispp.rds')

save(tbnispp, file = 'data/tbnispp.RData', compress = 'xz')
