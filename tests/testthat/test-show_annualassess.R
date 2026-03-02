test_that("Function returns a valid flextable object", {
  yrsel <- 2025
  result <- show_annualassess(epcdata, yrsel, width = 7)
  expect_s3_class(result, "flextable")
})

test_that("Check segment colors", {
  yrsel <- 1975
  result <- show_annualassess(epcdata, yrsel)
  result <- result$body$styles$cells$background.color$data[, 'bay_segment']
  expected <- c("#CC3231", "#CC3231", "#CC3231", "#E9C318")
  expect_equal(result, expected)
})

test_that("Check caption", {
  yrsel <- 1975
  result <- show_annualassess(epcdata, yrsel, caption = T)
  result <- result$caption$value$txt
  expected <- "Water quality outcomes for 1975."
  expect_equal(result, expected)
})

test_that("Check width", {
  yrsel <- 2025
  result <- show_annualassess(epcdata, yrsel, width = 7)
  result <- result$body$colwidths %>% unique
  expected <- 7
  expect_equal(result, expected)
})

