test_that("util_fibicons returns correct Enterococcus icon list for entero", {

  result <- util_fibicons('entero')

  expect_true(is.list(result))
  expect_equal(length(result), 8)  # Check if it returns 8 icons

  expect_true(all(grepl("dry|wet", names(result))))
  expect_true(all(grepl("green|yellow|orange|red", names(result))))

})

test_that("util_fibicons returns correct Enterococcus and E. coli icon list for entero&ecoli", {

  result <- util_fibicons('entero&ecoli')

  expect_true(is.list(result))
  expect_equal(length(result), 8)  # Check if it returns 8 icons

  expect_true(all(grepl("entero|ecoli", names(result))))
  expect_true(all(grepl("green|yellow|orange|red", names(result))))

})

test_that("util_fibicons returns correct FIB matrix score icon list for fibmat", {

  result <- util_fibicons('fibmat')

  expect_true(is.list(result))
  expect_equal(length(result), 5)  # Check if it returns 8 icons

  expect_true(all(grepl("fibmat", names(result))))
  expect_true(all(grepl("green|yellow|orange|red|purple", names(result))))

})

