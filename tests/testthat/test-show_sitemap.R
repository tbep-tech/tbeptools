test_that("Checking show_sitemap class", {
  result <- show_sitemap(epcdata, yrsel = 2018)
  expect_is(result, 'ggplot')
})
test_that("Checking show_sitemap yrsel",{
  expect_error(show_sitemap(epcdata, yrsel = 1962), "1962 not in epcdata")
})
