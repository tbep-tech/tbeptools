test_that("Checking read_transect class", {

  result <- read_transect(training = TRUE)

  expect_is(result, 'data.frame')

})

test_that("Checking read_transect class", {

  result <- read_transect(training = TRUE)

  expect_is(result, 'data.frame')

})

test_that("read_transect retries after failures then succeeds", {

  call_count <- 0
  fakedat <- jsonlite::fromJSON('https://tampabay.wateratlas.usf.edu/seagrass-transect-data-portal/api/assessments/training')

  fake_fromJSON <- function(...){
    call_count <<- call_count + 1
    if(call_count <= 2)
      stop('connection reset')
    fakedat
  }

  local_mocked_bindings(
    fromJSON = fake_fromJSON,
    .package = 'jsonlite'
  )

  result <- suppressMessages(read_transect(training = TRUE, retry = 2))

  expect_is(result, 'data.frame')
  expect_equal(call_count, 3)

})

test_that("read_transect stops with informative error after exhausting retries", {

  fake_fromJSON <- function(...) stop('connection reset')

  local_mocked_bindings(
    fromJSON = fake_fromJSON,
    .package = 'jsonlite'
  )

  expect_error(
    suppressMessages(read_transect(training = TRUE, retry = 2)),
    'Failed to retrieve data after 2 retries'
  )

})

