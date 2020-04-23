test_that("Checking read_chkdate, EPC data", {
  urlin <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"
  xlsx <- 'exdata.xls'

  result <- read_chkdate(urlin, xlsx)
  expect_is(result, 'logical')

})

# test_that("Checking read_chkdate, FIM data", {
#   urlin <- "ftp://ftp.floridamarine.org/users/fim/tmac/NektonIndex/TampaBay_NektonIndexData.csv"
#   xlsx <- 'fimraw.csv'
#
#   result <- read_chkdate(urlin, xlsx)
#   expect_is(result, 'logical')
#
# })

test_that("Checking read_chkdate, no connection", {
  urlin <- "floridamarine/file"
  xlsx <- 'fimraw.csv'

  expect_error(read_chkdate(urlin, xlsx), "Couldn't connect to FTP site, sad face...")

})
