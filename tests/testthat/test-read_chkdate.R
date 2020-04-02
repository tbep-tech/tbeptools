test_that("Checking read_chkdate", {
  urlin <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"
  xlsx <- 'exdata.xls'

  result <- read_chkdate(urlin, xlsx, connecttimeout = 20, tryurl = TRUE)
  expect_is(result, 'logical')

})
