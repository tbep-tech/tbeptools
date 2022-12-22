test_that("Checking anlz_transectocc", {
  result <- transectocc
  expect_equal(ncol(result), 6)
})
