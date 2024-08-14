test_that("util_fibicons returns correct Enterococcus icon list for entero", {

  result <- util_fibicons('entero')

  expect_true(is.list(result))
  expect_equal(length(result), 8)  # Check if it returns 8 icons

  expect_true(all(grepl("dry|wet", names(result))))
  expect_true(all(grepl("green|yellow|orange|red", names(result))))

})

test_that("util_fibicons returns correct fecal coliform icon list for fcolif", {

  result <- util_fibicons('fcolif')

  expect_true(is.list(result))
  expect_equal(length(result), 8)  # Check if it returns 8 icons

  expect_true(all(grepl("entero|ecoli", names(result))))
  expect_true(all(grepl("green|yellow|orange|red", names(result))))

})
