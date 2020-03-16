test_that("Checking read_dlcurrent", {

  xlsx <- 'exdata.xls'
  expect_message(read_dlcurrent(xlsx, connecttimeout = 20, tryurl = TRUE))

})

test_that("Checking read_dlcurrent, phyto = TRUE", {

  xlsx <- 'phytodata.xlsx'
  expect_message(read_dlcurrent(xlsx, connecttimeout = 20, tryurl = TRUE, phyto = TRUE))

})
