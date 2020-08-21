test_that("Checking anlz_avedat months", {
  result <- anlz_avedat(epcdata, partialyr = FALSE) %>%
    .[['mos']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(0.691785714285714, 0.894444444444445, 0.538912133891213, 0.490449782252317,
                 0.864732142857143), result)
})
test_that("Checking anlz_avedat years", {
  result <- anlz_avedat(epcdata, partialyr = FALSE) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(2.01458902208902, 1.83, 3.06607142857143, 3.11693665357639,
                 2.36923076923077), result)
})
test_that("Checking anlz_avedat years, partial year", {
  result <- anlz_avedat(epcdata, partialyr = T) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(2.01458902208902, 1.69293187830688, 3.25333134920635, 2.84543968238577,
                 2.16459381359381), result)
})
