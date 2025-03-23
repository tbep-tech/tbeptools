library(mockery)

# Mock data for catchpixels
catchpixelsmock <- data.frame(
  station = c("station1", "station1", "station2"),
  pixel = c(1, 2, 3)
)

# Mock data for the downloaded file content
mock_data <- data.frame(
  V1 = c(1, 2, 3),
  V2 = c("01/01/2021", "01/02/2021", "01/03/2021"),
  V3 = c(0.1, 0.2, 0.3)
)

# Define the test case
test_that("read_importrain works correctly", {

  # Mock the download.file function
  mock_download <- mock()
  stub(read_importrain, "download.file", mock_download)

  # Mock the read.table function
  mock_read_table <- mock(return_value = mock_data)
  stub(read_importrain, "utils::read.table", mock_read_table)

  # Call the function with mocked dependencies
  result <- read_importrain(2021, catchpixelsmock, mos = 1, quiet = FALSE)

  # Define expected output
  expected_output <- tibble::tibble(
    station = c("station1", "station1", "station2"),
    date = as.Date(c("2021-01-01", "2021-01-02", "2021-01-03")),
    rain = c(0.1, 0.2, 0.3)
  )

  # Check if the result matches the expected output
  expect_equal(result, expected_output)

  # Verify that the mock functions were called as expected
  expect_called(mock_download, 1)
  expect_called(mock_read_table, 1)

})
