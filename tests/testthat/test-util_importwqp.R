test_that("util_importwqp succeeds on first try with no retries", {

  fake_post <- function(...) structure(list(), class = "response")
  fake_content <- function(...) "a,b\n1,2\n"

  local_mocked_bindings(
    POST = fake_post,
    content = fake_content,
    .package = 'httr'
  )

  result <- util_importwqp("http://example.com", c(a = "b"), list(x = "y"), max_retries = 5, trace = FALSE)

  expect_s3_class(result, "data.frame")
  expect_equal(result$a, 1)

})

test_that("util_importwqp retries after failures then succeeds", {

  call_count <- 0

  fake_post <- function(...){
    call_count <<- call_count + 1
    if(call_count <= 2)
      stop("connection reset")
    structure(list(), class = "response")
  }
  fake_content <- function(...) "a,b\n1,2\n"

  local_mocked_bindings(
    POST = fake_post,
    content = fake_content,
    .package = 'httr'
  )

  # low max_retries with fast exponential backoff (2 + 4 = 6s) to keep test speed reasonable
  result <- util_importwqp("http://example.com", c(a = "b"), list(x = "y"), max_retries = 2, trace = TRUE)

  expect_s3_class(result, "data.frame")
  expect_equal(result$a, 1)
  expect_equal(call_count, 3)

})

test_that("util_importwqp stops with informative error after exhausting retries", {

  fake_post <- function(...) stop("connection reset")

  local_mocked_bindings(
    POST = fake_post,
    .package = 'httr'
  )

  expect_error(
    util_importwqp("http://example.com", c(a = "b"), list(x = "y"), max_retries = 2, trace = FALSE),
    "Failed to retrieve data after 2 retries"
  )

})
