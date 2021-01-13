test_that("Checking read_dlcurrent", {

  xlsx <- 'exdata.xls'
  urlin <- 'ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
  expect_message(read_dlcurrent(xlsx, urlin = urlin))

})
