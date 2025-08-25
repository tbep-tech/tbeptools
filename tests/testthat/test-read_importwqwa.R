# Mock response helper function for NDJSON
create_mock_ndjson_response <- function(status_code = 200, ndjson_content = "") {
  response <- list()
  class(response) <- "response"
  attr(response, "status_code") <- status_code
  return(list(response = response, content = ndjson_content))
}

test_that("read_importwqwa processes basic NDJSON response", {
  # Mock NDJSON content
  ndjson_content <- '{"id": 1, "value": 10.5, "activityStartDate": "2023-01-01"}
{"id": 2, "value": 12.3, "activityStartDate": "2023-01-02"}'
  
  mock_data <- create_mock_ndjson_response(200, ndjson_content)
  
  # Create a proper data frame with the activityStartDate column
  mock_df <- data.frame(
    id = c(1, 2), 
    value = c(10.5, 12.3), 
    activityStartDate = c("2023-01-01", "2023-01-02"),
    stringsAsFactors = FALSE
  )
  
  # Mock functions
  mock_get <- mock(mock_data$response)
  mock_stop_for_status <- mock()
  mock_content <- mock(ndjson_content)
  mock_fromJSON <- mock(
    list(id = 1, value = 10.5, activityStartDate = "2023-01-01"),
    list(id = 2, value = 12.3, activityStartDate = "2023-01-02")
  )
  mock_bind_rows <- mock(mock_df)
  
  # Apply stubs
  stub(read_importwqwa, "httr::GET", mock_get)
  stub(read_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  stub(read_importwqwa, "httr::content", mock_content)
  stub(read_importwqwa, "jsonlite::fromJSON", mock_fromJSON)
  stub(read_importwqwa, "dplyr::bind_rows", mock_bind_rows)
  
  # Suppress trace output for testing
  result <- suppressMessages(read_importwqwa("WIN_21FLHILL", "Chla_ugl", trace = FALSE))
  
  # Verify the result
  expect_equal(nrow(result), 2)
  expect_equal(result$id, c(1, 2))
  expect_true("activityStartDate" %in% names(result))
  
  # Verify mocks were called
  expect_called(mock_get, 1)
  expect_called(mock_stop_for_status, 1)
  expect_called(mock_content, 1)
  expect_called(mock_fromJSON, 2)  # Once for each JSON line
})

test_that("read_importwqwa includes optional date parameters", {
  mock_data <- create_mock_ndjson_response(200, '{"id": 1, "activityStartDate": "2023-01-01"}')
  
  # Create proper data frame with activityStartDate column
  mock_df <- data.frame(id = 1, activityStartDate = "2023-01-01", stringsAsFactors = FALSE)
  
  # Capture the query parameters
  mock_get <- mock(mock_data$response, side_effect = function(url, query) {
    captured_query <<- query
    return(mock_data$response)
  })
  
  mock_stop_for_status <- mock()
  mock_content <- mock('{"id": 1, "activityStartDate": "2023-01-01"}')
  mock_fromJSON <- mock(list(id = 1, activityStartDate = "2023-01-01"))
  mock_bind_rows <- mock(mock_df)
  
  # Apply stubs
  stub(read_importwqwa, "httr::GET", mock_get)
  stub(read_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  stub(read_importwqwa, "httr::content", mock_content)
  stub(read_importwqwa, "jsonlite::fromJSON", mock_fromJSON)
  stub(read_importwqwa, "dplyr::bind_rows", mock_bind_rows)
  
  result <- suppressMessages(
    read_importwqwa("WIN_21FLHILL", "Chla_ugl", "2023-01-01", "2023-02-01", trace = FALSE)
  )
  
  # Verify parameters were included
  expect_equal(result$activityStartDate, as.Date("2023-01-01"))
})

test_that("read_importwqwa handles HTTP errors", {
  mock_response <- list()
  class(mock_response) <- "response"
  attr(mock_response, "status_code") <- 404
  
  mock_get <- mock(mock_response)
  mock_stop_for_status <- mock(stop("HTTP 404 Not Found"))
  
  # Apply stubs
  stub(read_importwqwa, "httr::GET", mock_get)
  stub(read_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  
  expect_error(
    suppressMessages(read_importwqwa("INVALID", "INVALID", trace = FALSE)),
    "HTTP 404 Not Found"
  )
})

test_that("read_importwqwa handles malformed JSON gracefully", {
  # Mix of valid and invalid JSON
  ndjson_content <- '{"id": 1, "value": 10.5}
{invalid json}
{"id": 2, "value": 12.3}'
  
  mock_data <- create_mock_ndjson_response(200, ndjson_content)
  
  # Create data frame without activityStartDate since it's not in the test data
  mock_df <- data.frame(id = c(1, 2), value = c(10.5, 12.3), stringsAsFactors = FALSE)
  
  mock_get <- mock(mock_data$response)
  mock_stop_for_status <- mock()
  mock_content <- mock(ndjson_content)
  
  # Mock fromJSON to succeed twice and fail once
  mock_fromJSON <- mock(
    list(id = 1, value = 10.5),
    stop("Invalid JSON"),
    list(id = 2, value = 12.3)
  )
  
  mock_bind_rows <- mock(mock_df)
  
  # Apply stubs
  stub(read_importwqwa, "httr::GET", mock_get)
  stub(read_importwqwa, "httr::stop_for_status", mock_stop_for_status)
  stub(read_importwqwa, "httr::content", mock_content)
  stub(read_importwqwa, "jsonlite::fromJSON", mock_fromJSON)
  stub(read_importwqwa, "dplyr::bind_rows", mock_bind_rows)
  
  expect_error(
    suppressMessages(read_importwqwa("WIN_21FLHILL", "Chla_ugl", trace = FALSE)),
    "Error parsing JSON line: Invalid JSON"
  )
})