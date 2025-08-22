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