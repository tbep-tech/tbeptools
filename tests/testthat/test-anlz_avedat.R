test_that("Checking anlz_avedat months", {
  result <- anlz_avedat(epcdata, partialyr = FALSE) %>%
    .[['mos']] %>%
    pull(val) %>%
    .[1:4]
  expect_equal(c(36.2, 1.75, 11.4639520508097, 4.4), result)
})
test_that("Checking anlz_avedat years", {
  result <- anlz_avedat(epcdata, partialyr = FALSE) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[1:4]
  expect_equal(c(22.4045454545455, 4.23863636363636, 9.65873729643123, 10.2410622710623
  ), result)
})
test_that("Checking anlz_avedat years, partial year", {
  result <- anlz_avedat(epcdata, partialyr = T) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[1:4]
  expect_equal(c(22.4045454545455, 4.23863636363636, 9.65873729643123, 10.2410622710623
  ), result)
})
