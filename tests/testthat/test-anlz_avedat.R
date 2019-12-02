test_that("Checking anlz_avedat months", {
  result <- anlz_avedat(epcdata) %>%
    .[['mos']] %>%
    pull(val) %>%
    .[1:4]
  expect_equal(c(36.2, 1.75, 4.4, 42.4), result)
})
test_that("Checking anlz_avedat years", {
  result <- anlz_avedat(epcdata) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[1:4] %>%
    round(5)
  expect_equal(c(22.40455, 27.93182, 29.45111, 32.54222), result)
})
