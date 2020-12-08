test_that("Checking show_sitemap class", {
  result <- show_sitemap(epcdata, yrsel = 2018)
  expect_is(result, 'ggplot')
})
test_that("Checking show_sitemap class with mosel",{
  result <- show_sitemap(epcdata, yrsel = 2018, mosel = c(1, 5))
  expect_is(result, 'ggplot')
})
test_that("Checking show_sitemap class, thrs = T", {
  result <- show_sitemap(epcdata, thrs = TRUE, yrsel = 2018)
  expect_is(result, 'ggplot')
})
test_that("Checking show_sitemap yrsel",{
  expect_error(show_sitemap(epcdata, yrsel = 1962), "1962 not in epcdata")
})
test_that("Checking show_sitemap mosel out of range",{
  expect_error(show_sitemap(epcdata, yrsel = 2018, mosel = 13), "mosel not in range of 1 to 12")
})
test_that("Checking show_sitemap mosel not in ascending order",{
  expect_error(show_sitemap(epcdata, yrsel = 2018, mosel = c(5, 2)), "mosel must be in ascending order")
})
test_that("Checking show_sitemap mosel more than two",{
  expect_error(show_sitemap(epcdata, yrsel = 2018, mosel = c(1:3)), "mosel must be length 1 or 2")
})

