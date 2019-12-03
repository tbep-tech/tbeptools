test_that("Checking read_chkdate", {
  epchc_url <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"
  xlsx <- 'exdata.xls'

  result <- read_chkdate(epchc_url, xlsx)
  expect_is(result, 'logical')

})
