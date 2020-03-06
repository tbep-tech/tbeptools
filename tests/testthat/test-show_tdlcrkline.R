test_that("Checking show_tdlcrkline NULL result", {
  result <- show_tdlcrkline('CHLAC')
  expect_null(result)
})

test_that("Checking show_tdlcrkline threshold and horizontal", {
  result <- show_tdlcrkline('CHLAC', thrsel = TRUE)
  expect_equal(result, list(list(type = "line", x0 = 0, x1 = 1, xref = "paper", y0 = 11,
                                 y1 = 11, line = list(color = "red", dash = 10))))
})

test_that("Checking show_tdlcrkline threshold and vertical", {
  result <- show_tdlcrkline('CHLAC', thrsel = TRUE, horiz = FALSE)
  expect_equal(result, list(list(type = "line", x0 = 11, x1 = 11, yref = "paper", y0 = 0,
                                 y1 = 1, line = list(color = "red", dash = 10))))
})

test_that("Checking show_tdlcrkline threshold, horizontal and annotate", {
  result <- show_tdlcrkline('CHLAC', thrsel = TRUE, annotate = TRUE)
  expect_equal(result, list(list(x = 0, y = 11, text = "", xref = "x", yref = "y", showarrow = FALSE,
                                 yanchor = "top", font = list(color = "red", size = 14))))
})

test_that("Checking show_tdlcrkline threshold, vertical and annotate", {
  result <- show_tdlcrkline('CHLAC', thrsel = TRUE, horiz = FALSE, annotate = TRUE)
  expect_equal(result, list(list(x = 11, y = 1, text = "", xref = "x", yref = "y", showarrow = FALSE,
                                 xanchor = "right", yanchor = "top", textangle = 90, font = list(
                                   color = "red", size = 14))))
})

