library(mockery)

test_that("read_importwqwin handles single page response", {

  # Mock response for single page (last = TRUE)
  mock_single_page <- list(
    content = data.frame(
      resultKey = c("001", "002"),
      activityStartDate = c("2025-01-01", "2025-01-02"),
      activityEndDate = c("2025-02-01", "2025-02-01"),
      organizationId = c("21FLMANA", "21FLMANA")
    ),
    totalPages = 1,
    last = TRUE
  )

  # Mock util_importwqwin to return single page
  m_util <- mock(mock_single_page)

  local_mocked_bindings(
    util_importwqwin = m_util,
    .package = 'tbeptools'
  )

  result <- read_importwqwin("2025-01-01", "2025-02-01", "21FLMANA", verbose = FALSE)

  # Verify result structure
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_true("resultKey" %in% names(result))

})

test_that("read_importwqwin handles multiple pages", {

  # Mock responses for multiple pages
  mock_page1 <- list(
    content = data.frame(
      resultKey = c("001", "002"),
      activityStartDate = c("2025-01-01", "2025-01-02"),
      activityEndDate = c("2025-02-01", "2025-02-01"),
      organizationId = c("21FLMANA", "21FLMANA")
    ),
    totalPages = 3,
    last = FALSE
  )

  mock_page2 <- list(
    content = data.frame(
      resultKey = c("003", "004"),
      activityStartDate = c("2025-01-03", "2025-01-04"),
      activityEndDate = c("2025-02-03", "2025-02-04"),
      organizationId = c("21FLMANA", "21FLMANA")
    ),
    totalPages = 3,
    last = FALSE
  )

  mock_page3 <- list(
    content = data.frame(
      resultKey = c("005"),
      activityStartDate = c("2025-01-05"),
      activityEndDate = c("2025-02-05"),
      organizationId = c("21FLMANA")
    ),
    totalPages = 3,
    last = TRUE
  )

  # Mock util_importwqwin to return different responses based on call sequence
  m_util <- mock(mock_page1, mock_page2, mock_page3)

  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      result <- read_importwqwin("2025-01-01", "2025-02-01", "21FLMANA", verbose = FALSE)

      # Verify result combines all pages
      expect_s3_class(result, "data.frame")
      expect_equal(nrow(result), 5) # 2 + 2 + 1 rows
      expect_equal(result$resultKey, c("001", "002", "003", "004", "005"))
    }
  )
})

test_that("read_importwqwin handles verbose output", {

  # Mock single page response
  mock_response <- list(
    content = data.frame(resultKey = "001"),
    totalPages = 1,
    last = TRUE
  )

  m_util <- mock(mock_response)

  # Capture console output
  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      output <- capture_output(
        result <- read_importwqwin("2025-01-01", "2025-01-15", "21FLMANA", verbose = TRUE)
      )

      # Check that verbose message was printed
      expect_match(output[1], "Retrieving data from 2025-01-01 to 2025-01-15")
    }
  )
})



test_that("read_importwqwin retries on timeout and succeeds", {

  # Create timeout error with proper try-error structure
  timeout_condition <- simpleError("Connection timeout after 30 seconds")
  timeout_error <- structure(
    list(),
    class = "try-error",
    condition = timeout_condition
  )

  # Mock successful response after timeout
  mock_success <- list(
    content = data.frame(
      resultKey = c("001", "002"),
      organizationId = c("21FLMANA", "21FLMANA")
    ),
    totalPages = 1,
    last = TRUE
  )

  # First call times out, second call succeeds
  m_util <- mock(timeout_error, mock_success)

  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      # Use skip_on_cran() to avoid long test times, or set max_retries to 1 for faster tests
      result <- read_importwqwin("2025-01-01", "2025-02-01", "21FLMANA", verbose = FALSE, max_retries = 1)

      # Should succeed and return data
      expect_s3_class(result, "data.frame")
      expect_equal(nrow(result), 2)

    }
  )
})

test_that("read_importwqwin retries with verbose output", {

  # Create timeout error with proper structure
  timeout_condition <- simpleError("Request timed out")
  timeout_error <- structure(
    list(),
    class = "try-error",
    condition = timeout_condition
  )

  # Mock successful response
  mock_success <- list(
    content = data.frame(resultKey = "001"),
    totalPages = 1,
    last = TRUE
  )

  m_util <- mock(timeout_error, timeout_error, mock_success)

  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      output <- capture_output(
        result <- read_importwqwin("2025-01-01", "2025-01-15", "21FLMANA", verbose = TRUE, max_retries = 2)
      )

      # Check retry messages (using lower max_retries to speed up test)
      expect_match(paste(output, collapse = " "), "Timeout occurred, retrying.*attempt 1 of 2")
      expect_match(paste(output, collapse = " "), "Timeout occurred, retrying.*attempt 2 of 2")
    }
  )
})

test_that("read_importwqwin skips after max retries on timeout", {

  # Create persistent timeout error
  timeout_error <- simpleError("Connection timeout")
  timeout_error <- structure(
    list(),
    class = "try-error",
    condition = timeout_error
  )

  # Mock to always return timeout (use fewer calls for faster test)
  m_util <- mock(timeout_error, timeout_error, timeout_error)

  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      result <- read_importwqwin("2025-01-01", "2025-02-01", "21FLMANA", verbose = FALSE, max_retries = 2)

      # Should return empty data frame since all attempts failed
      expect_s3_class(result, "data.frame")
      expect_equal(nrow(result), 0)

    }
  )
})

test_that("read_importwqwin handles non-timeout errors without retry", {

  # Create non-timeout error (e.g., no data found)
  no_data_error <- simpleError("No data found for specified parameters")
  no_data_error <- structure(
    list(),
    class = "try-error",
    condition = no_data_error
  )


  m_util <- mock(no_data_error)

  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      result <- read_importwqwin("2025-01-01", "2025-02-01", "21FLMANA", verbose = FALSE)

      # Should return empty data frame
      expect_s3_class(result, "data.frame")
      expect_equal(nrow(result), 0)

    }
  )
})

test_that("read_importwqwin handles timeout during pagination", {

  # Mock first page success
  mock_page1 <- list(
    content = data.frame(resultKey = c("001", "002")),
    totalPages = 2,
    last = FALSE
  )

  # Create timeout error for second page
  timeout_error <- simpleError("Request timeout")
  timeout_error <- structure(
    list(),
    class = "try-error",
    condition = timeout_error
  )

  # Mock successful second page after retry
  mock_page2 <- list(
    content = data.frame(resultKey = c("003", "004")),
    totalPages = 2,
    last = TRUE
  )

  # First call succeeds, second times out, third succeeds
  m_util <- mock(mock_page1, timeout_error, mock_page2)

  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      result <- read_importwqwin("2025-01-01", "2025-02-01", "21FLMANA", verbose = FALSE, max_retries = 1)

      # Should succeed and return all data
      expect_s3_class(result, "data.frame")
      expect_equal(nrow(result), 4)
      expect_equal(result$resultKey, c("001", "002", "003", "004"))

    }
  )
})
