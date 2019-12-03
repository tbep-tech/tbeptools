test_that("Checking read_dlcurrent", {

  xlsx <- here::here('vignettes/2018_Results_Updated.xls')
  expect_message(read_dlcurrent(xlsx))

})
