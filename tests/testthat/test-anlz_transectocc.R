test_that("Checking anlz_transectocc", {
  result <- anlz_transectocc(transect)
  expect_equal(ncol(result), 5)
})
