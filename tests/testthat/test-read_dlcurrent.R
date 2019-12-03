test_that("Checking read_dlcurrent", {

  xlsx <- 'exdata.xls'
  expect_message(read_dlcurrent(xlsx, connecttimeout = 20, tryurl = TRUE))

})
