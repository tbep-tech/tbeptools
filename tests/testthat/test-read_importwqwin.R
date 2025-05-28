library(mockery)

test_that("read_importwqwin handles single page response", {

  # Mock response for single page (last = TRUE)
  mock_single_page <- list(
    content = data.frame(
      resultKey = c("001", "002"),
      activityStartDate = c("2025-01-01", "2025-01-02"),
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

  result <- read_importwqwin("2025-01-01", "21FLMANA", verbose = FALSE)

  # Verify util_importwqwin was called once with page 0
  expect_called(m_util, 1)
  expect_equal(mock_args(m_util)[[1]], list("2025-01-01", "21FLMANA", 0))

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
      organizationId = c("21FLMANA", "21FLMANA")
    ),
    totalPages = 3,
    last = FALSE
  )

  mock_page2 <- list(
    content = data.frame(
      resultKey = c("003", "004"),
      activityStartDate = c("2025-01-03", "2025-01-04"),
      organizationId = c("21FLMANA", "21FLMANA")
    ),
    totalPages = 3,
    last = FALSE
  )

  mock_page3 <- list(
    content = data.frame(
      resultKey = c("005"),
      activityStartDate = c("2025-01-05"),
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
      result <- read_importwqwin("2025-01-01", "21FLMANA", verbose = FALSE)

      # Verify util_importwqwin was called 3 times with correct page numbers
      expect_called(m_util, 3)
      expect_equal(mock_args(m_util)[[1]], list("2025-01-01", "21FLMANA", 0))
      expect_equal(mock_args(m_util)[[2]], list("2025-01-01", "21FLMANA", 1))
      expect_equal(mock_args(m_util)[[3]], list("2025-01-01", "21FLMANA", 2))

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
        result <- read_importwqwin("2025-01-01", "21FLMANA", verbose = TRUE)
      )

      # Check that verbose message was printed
      expect_match(output, "Retrieving page 1...")
    }
  )
})

test_that("read_importwqwin handles verbose output for multiple pages", {

  # Mock responses for 2 pages
  mock_page1 <- list(
    content = data.frame(resultKey = "001"),
    totalPages = 2,
    last = FALSE
  )

  mock_page2 <- list(
    content = data.frame(resultKey = "002"),
    totalPages = 2,
    last = TRUE
  )

  m_util <- mock(mock_page1, mock_page2)

  with_mocked_bindings(
    util_importwqwin = m_util,
    {
      output <- capture_output(
        result <- read_importwqwin("2025-01-01", "21FLMANA", verbose = TRUE)
      )

      # Check that both verbose messages were printed
      expect_match(output, "Retrieving page 1...\nRetrieving page 2 of 2...")
    }
  )
})
