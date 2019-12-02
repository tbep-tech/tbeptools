test_that("Checking anlz_avedatsite months", {
  result <- anlz_avedatsite(epcdata) %>%
    .[['mos']] %>%
    pull(val) %>%
    .[1:4]
  expect_equal(c(53, 19, 46, 3), result)
})
test_that("Checking anlz_avedatsite years", {
  result <- anlz_avedatsite(epcdata) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[1:4] %>%
    round(5)
  expect_equal(c(25.59091, 24.77273, 32.99444, 43.90833), result)
})
