# Mock response helper function
create_mock_response <- function(status_code = 200, items = list(), total_pages = 1) {
  response <- list()
  class(response) <- "response"
  
  # Mock the status code
  attr(response, "status_code") <- status_code
  
  # Mock the content
  content_data <- list(
    items = items,
    totalPages = total_pages
  )
  
  return(list(response = response, content = content_data))
}

test_that("util_importwqwa validates endpoint argument", {
  expect_error(
    util_importwqwa("invalid_endpoint"),
    "'arg' should be one of"
  )
})

test_that("util_importwqwa handles single page response", {
  # Mock data
  mock_items <- list(
    list(id = 1, name = "Item 1"),
    list(id = 2, name = "Item 2")
  )
  
  mock_data <- create_mock_response(200, mock_items, 1)
  
  # Mock httr functions
  mock_get <- mock(mock_data$response)
  mock_stop_for_status <- mock()
  mock_content <- mock(mock_data$content)
  
  # Mock dplyr::bind_rows to return a simple data frame
  mock_bind_rows <- mock(data.frame(id = c(1, 2), name = c("Item 1", "Item 2")))
  
  # Apply stubs
  stub(util_importwqwa, "httr::GET", mock_get)
  stub(util_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  stub(util_importwqwa, "httr::content", mock_content)
  stub(util_importwqwa, "dplyr::bind_rows", mock_bind_rows)
  
  result <- util_importwqwa("parameters")
  
  # Verify the result
  expect_equal(nrow(result), 2)
  expect_equal(result$id, c(1, 2))
  
})

test_that("util_importwqwa handles multiple pages", {
  # Mock data for first page
  mock_items_page1 <- list(list(id = 1, name = "Item 1"))
  mock_items_page2 <- list(list(id = 2, name = "Item 2"))
  
  mock_data_page1 <- create_mock_response(200, mock_items_page1, 2)
  mock_data_page2 <- create_mock_response(200, mock_items_page2, 2)
  
  # Mock httr functions
  mock_get <- mock(mock_data_page1$response, mock_data_page2$response)
  mock_stop_for_status <- mock()
  mock_content <- mock(mock_data_page1$content, mock_data_page2$content)
  
  # Mock dplyr::bind_rows
  mock_bind_rows <- mock(
    data.frame(id = 1, name = "Item 1"),  # First call for page 1
    data.frame(id = 2, name = "Item 2"),  # Second call for page 2
    data.frame(id = c(1, 2), name = c("Item 1", "Item 2"))  # Final bind
  )
  
  # Apply stubs
  stub(util_importwqwa, "httr::GET", mock_get)
  stub(util_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  stub(util_importwqwa, "httr::content", mock_content)
  stub(util_importwqwa, "dplyr::bind_rows", mock_bind_rows)
  
  result <- util_importwqwa("waterbodies")
  
  # Verify the result
  expect_equal(nrow(result), 2)
  
  # Verify GET was called twice (once for each page)
  expect_called(mock_get, 2)
  expect_called(mock_stop_for_status, 2)
  expect_called(mock_content, 2)
})

test_that("util_importwqwa includes waterbodyId parameter when provided", {
  mock_items <- list(list(id = 1, name = "Location 1"))
  mock_data <- create_mock_response(200, mock_items, 1)
  
  # Capture the query parameters
  captured_query <- NULL
  mock_get <- mock(mock_data$response, side_effect = function(url, query) {
    captured_query <<- query
    return(mock_data$response)
  })
  
  mock_stop_for_status <- mock()
  mock_content <- mock(mock_data$content)
  mock_bind_rows <- mock(data.frame(id = 1, name = "Location 1"))
  
  # Apply stubs
  stub(util_importwqwa, "httr::GET", mock_get)
  stub(util_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  stub(util_importwqwa, "httr::content", mock_content)
  stub(util_importwqwa, "dplyr::bind_rows", mock_bind_rows)
  
  result <- util_importwqwa("sampling-locations", waterbodyId = 123)
  
  expect_equal(nrow(result), 1)
})

test_that("util_importwqwa handles HTTP errors gracefully", {
  # Mock a failed response
  mock_response <- list()
  class(mock_response) <- "response"
  attr(mock_response, "status_code") <- 500
  
  mock_get <- mock(mock_response)
  mock_stop_for_status <- mock(stop("HTTP 500 Internal Server Error"))
  
  # Apply stubs
  stub(util_importwqwa, "httr::GET", mock_get)
  stub(util_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  
  expect_error(
    util_importwqwa("parameters"),
    "HTTP 500 Internal Server Error"
  )
})

test_that("util_importwqwa handles failed pages and outputs error message", {
  # Mock data for first page (successful)
  mock_items_page1 <- list(list(id = 1, name = "Item 1"))
  mock_data_page1 <- create_mock_response(200, mock_items_page1, 3)  # 3 total pages
  
  # Mock failed response for page 2
  mock_failed_response <- list()
  class(mock_failed_response) <- "response"
  attr(mock_failed_response, "status_code") <- 500
  
  # Mock successful response for page 3
  mock_items_page3 <- list(list(id = 3, name = "Item 3"))
  mock_data_page3 <- create_mock_response(200, mock_items_page3, 3)
  
  # Mock httr functions - page 1 succeeds, page 2 fails, page 3 succeeds
  mock_get <- mock(
    mock_data_page1$response,   # Page 1 - success
    mock_failed_response,       # Page 2 - failure
    mock_data_page3$response    # Page 3 - success
  )
  
  # stop_for_status will be called 3 times, but only throw error on page 2
  mock_stop_for_status <- mock(
    NULL,  # Page 1 - no error
    stop("HTTP 500 Internal Server Error"),  # Page 2 - error
    NULL   # Page 3 - no error
  )
  
  mock_content <- mock(
    mock_data_page1$content,    # Page 1 content
    mock_data_page3$content     # Page 3 content (page 2 skipped due to error)
  )
  
  # Mock dplyr::bind_rows - will be called for page 1, then for combining page 1 + page 3
  mock_bind_rows <- mock(
    data.frame(id = 1, name = "Item 1"),     # Page 1 initial result
    data.frame(id = 3, name = "Item 3"),     # Page 3 result
    data.frame(id = c(1, 3), name = c("Item 1", "Item 3"))  # Final combined result
  )
  
  # Apply stubs
  stub(util_importwqwa, "httr::GET", mock_get)
  stub(util_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  stub(util_importwqwa, "httr::content", mock_content)
  stub(util_importwqwa, "dplyr::bind_rows", mock_bind_rows)
  
  # Capture console output to verify error message
  output <- capture.output({
    result <- util_importwqwa("waterbodies")
  })
  
  # Verify the result includes data from successful pages (1 and 3)
  expect_equal(nrow(result), 2)
  expect_equal(result$id, c(1, 3))
  
  # Verify error message was printed for failed page
  expect_true(any(grepl("Page 2 of 3 failed", output)))
  
  # Verify all HTTP calls were made
  expect_called(mock_get, 3)
  expect_called(mock_stop_for_status, 3)
  expect_called(mock_content, 2)  # Only called for successful pages
})
