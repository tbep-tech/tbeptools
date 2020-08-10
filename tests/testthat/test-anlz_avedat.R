test_that("Checking anlz_avedat months", {
  result <- anlz_avedat(epcdata, partialyr = FALSE) %>%
    .[['mos']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(0.488524590163934, 0.914772727272727, 0.471794871794872, 0.442102969064063,
                 0.691785714285714), result)
})
test_that("Checking anlz_avedat years", {
  result <- anlz_avedat(epcdata, partialyr = FALSE) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(2.01458902208902, 1.84, 2.95, 3.14323965437366, 2.58461538461538), result)
})
test_that("Checking anlz_avedat years, partial year", {
  result <- anlz_avedat(epcdata, partialyr = T) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(2.01458902208902, 1.67064285714286, 3.2107123015873, 2.8045515638299,
                 2.19498231398231), result)
})
