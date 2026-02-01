# --- Happy path: data returned, converted mm→inches, summed ---
test_that("util_rain converts mm to inches and sums", {
  stub(util_rain, "httr::GET", function(...) "mock")
  stub(util_rain, "httr::status_code", function(...) 200)
  stub(util_rain, "httr::content", function(...) "{}")
  stub(util_rain, "jsonlite::fromJSON", function(...) list(results = data.frame(value = c(25.4, 50.8))))
  out <- util_rain("st", "2021-01-01", "2021-12-31", "tk", quiet = TRUE)
  expect_equal(out$sum, 3.0)  # (25.4 + 50.8) / 25.4
})

# --- Zero-row data.frame results: triggers nrow == 0 early return ---
test_that("util_rain returns NA for zero-row results", {
  stub(util_rain, "httr::GET", function(...) "mock")
  stub(util_rain, "httr::status_code", function(...) 200)
  stub(util_rain, "httr::content", function(...) "{}")
  stub(util_rain, "jsonlite::fromJSON", function(...) list(results = data.frame(value = numeric(0))))
  out <- util_rain("st", "2021-01-01", "2021-12-31", "tk", quiet = TRUE)
  expect_true(is.na(out$sum))
})

# --- NULL results: hits the else→empt branch in the first try block.
#     Latent bug exposed: empt has column "sum" but mutate downstream expects "value". ---
test_that("util_rain errors on NULL results", {
  stub(util_rain, "httr::GET", function(...) "mock")
  stub(util_rain, "httr::status_code", function(...) 200)
  stub(util_rain, "httr::content", function(...) "{}")
  stub(util_rain, "jsonlite::fromJSON", function(...) list(results = NULL))
  expect_error(util_rain("st", "2021-01-01", "2021-12-31", "tk", quiet = TRUE))
})

# --- First GET throws, retry succeeds: covers while loop entry + "Retrying" cat ---
test_that("util_rain retries on error and succeeds", {
  i <- 0L
  stub(util_rain, "httr::GET", function(...) { i <<- i + 1L; if (i == 1L) stop("e") else "mock" })
  stub(util_rain, "httr::status_code", function(...) 200)
  stub(util_rain, "httr::content", function(...) "{}")
  stub(util_rain, "jsonlite::fromJSON", function(...) list(results = data.frame(value = 25.4)))
  out <- util_rain("st", "2021-01-01", "2021-12-31", "tk", quiet = FALSE)
  expect_equal(out$sum, 1.0)
})

# --- All attempts return non-200: covers stop("API...") in both try blocks,
#     "Retrying"/"Failed" cats (quiet = FALSE), and the ntry-exhaustion stop(). ---
test_that("util_rain stops after exhausting retries", {
  stub(util_rain, "httr::GET", function(...) "mock")
  stub(util_rain, "httr::status_code", function(...) 500)
  expect_error(util_rain("st", "2021-01-01", "2021-12-31", "tk", ntry = 1, quiet = FALSE))
})

# --- First attempt non-200, retry succeeds with NULL results:
#     covers the retry block's else→empt branch. ---
test_that("util_rain retry else branch on NULL results", {
  i <- 0L
  stub(util_rain, "httr::GET", function(...) "mock")
  stub(util_rain, "httr::status_code", function(...) { i <<- i + 1L; if (i <= 1L) 500 else 200 })
  stub(util_rain, "httr::content", function(...) "{}")
  stub(util_rain, "jsonlite::fromJSON", function(...) list(results = NULL))
  expect_error(util_rain("st", "2021-01-01", "2021-12-31", "tk", quiet = TRUE))
})