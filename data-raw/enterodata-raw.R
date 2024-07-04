stations <- c('21FLHILL_WQX-101',
              '21FLHILL_WQX-102',
              '21FLHILL_WQX-501',
              '21FLDOH_WQX-MANATEE152',
              '21FLPDEM_WQX-19-02')
entero_names <- c('Enterococci',
                  'Enterococcus')
startDate <- as.Date('2019-01-01')
endDate <- as.Date('2023-12-31')

args <- list(
  siteid = stations,
  characteristicName = entero_names,
  startDateLo = format(startDate, '%m-%d-%Y'),
  startDateHi = format(endDate, '%m-%d-%Y')
)
# date format has to be mm-dd-yyyy

enterodata <- read_importentero(args = args) %>%
  dplyr::select(-qualifier,
                -LabComments)

save(enterodata, file = 'data/enterodata.RData', compress = 'xz')
