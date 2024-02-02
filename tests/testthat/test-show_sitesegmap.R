test_that("Checking show_sitesegmap class", {
  result <- show_sitesegmap(epcdata, yrsel = 2018)
  expect_is(result, 'ggplot')
})
test_that("Checking show_sitesegmap class, partialyr = T", {
  result <- show_sitesegmap(epcdata, yrsel = 2020, partialyr = TRUE)
  expect_is(result, 'ggplot')
})
test_that("Checking show_sitesegmap class, thrs = T", {
  result <- show_sitesegmap(epcdata, thrs = TRUE, yrsel = 2018)
  expect_is(result, 'ggplot')
})
test_that("Checking show_sitesegmap yrsel",{
  expect_error(show_sitesegmap(epcdata, yrsel = 1962), "1962 not in epcdata")
})
