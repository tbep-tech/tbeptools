test_that("Function returns a flextable object", {
  yrsel <- 2023
  result <- show_ratab(epcdata, yrsel)
  expect_s3_class(result, "flextable")
})

test_that("Function raises an error for invalid input years", {
  yrsel <- 2021
  expect_error(show_ratab(epcdata, yrsel), "yrsel must be from 2022 to 2026")
})

test_that("Check width", {
  yrsel <- 2023
  result <- show_ratab(epcdata, yrsel, width = 7)
  result <- result$body$colwidths %>% unique
  expected <- 7
  expect_equal(result, expected)
})

