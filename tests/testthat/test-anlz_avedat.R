test_that("Checking anlz_avedat months", {
  result <- anlz_avedat(epcdata) %>%
    .[['mos']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(0.488524590163934, 0.914772727272727, 0.471794871794872, 0.442102969064063,
                 0.691785714285714), result)
})
test_that("Checking anlz_avedat years", {
  result <- anlz_avedat(epcdata) %>%
    .[['ann']] %>%
    pull(val) %>%
    .[(length(.) - 4):length(.)]
  expect_equal(c(0.78363096716534, 0.878181818181818, 0.659083139083139, 0.482318533979087,
                 0.588208009979948), result)
})
