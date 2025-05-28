library(mockery)

test_that("util_importwqwin constructs correct URL and handles successful response", {

  # mock response
  mock_response <- list(status_code = 200)

  # Mock the content that would be returned
  mock_content <- '{"content": [{"resultKey": "001", "activityStartDate": "2025-01-01"}], "totalElements": 1}'

  # Mock parsed JSON result
  mock_parsed <- list(
    content = data.frame(resultKey = "001", activityStartDate = "2025-01-01"),
    totalElements = 1
  )

  # Create mock functions
  m_get <- mock(mock_response)
  m_content <- mock(mock_content)
  m_fromJSON <- mock(mock_parsed)

  local_mocked_bindings(
    GET = m_get,
    content = m_content,
    .package = 'httr'
  )

  local_mocked_bindings(
    fromJSON = m_fromJSON,
    .package = 'jsonlite'
  )

  result <- util_importwqwin("2025-01-01", "21FLMANA", 1)

  # Verify the correct URL was called
  expect_called(m_get, 1)
  expect_equal(
    mock_args(m_get)[[1]][[1]],
    "https://prodapps.dep.state.fl.us/dear-watershed/result-activities?ActivityStartDateFrom%20%28%3E%3D%29=2025-01-01&Organization%20ID=21FLMANA&page=1&size=100&sort=resultKey%2CASC"
  )

  # Verify result structure
  expect_type(result, "list")
  expect_equal(result$totalElements, 1)

})

test_that("util_importwqwin handles error", {

  # mock response
  mock_response <- list(status_code = 200)

  # Mock the content that would be returned
  mock_content <- '{"content": [{"resultKey": "001", "activityStartDate": "2025-01-01"}], "totalElements": 1}'

  # Mock parsed JSON result
  mock_parsed <- list(
    content = list()
  )

  # Create mock functions
  m_get <- mock(mock_response)
  m_content <- mock(mock_content)
  m_fromJSON <- mock(mock_parsed)

  local_mocked_bindings(
    GET = m_get,
    content = m_content,
    .package = 'httr'
  )

  local_mocked_bindings(
    fromJSON = m_fromJSON,
    .package = 'jsonlite'
  )

  expect_error(util_importwqwin("2025-01-01", "test", 1),
               "No data found for the specified parameters.",
               fixed = TRUE)

})
