library(mockery)

# Mock station data
df_stations_mock <- data.frame(
  station_id = c(123456, 654321),
  station_name = c("Station A", "Station B")
)

# Mock CSV path
mock_csv_path <- tempfile(fileext = ".csv")

# Mock API response data
mock_api_response <- "year,month,msl\n2023,01,1.5\n2023,02,1.6"

# Mock httr2::req_perform to return a predefined response
mock_req_perform <- function(...) {
  structure(list(content = charToRaw(mock_api_response)), class = "httr2_response")
}

# Mock readr::read_csv to return a predefined dataframe
mock_read_csv <- function(file, ...) {
  data.frame(year = c(2023, 2023), month = c(1, 2), msl = c(1.5, 1.6))
}

test_that("read_importsealevels writes and reads CSV correctly", {
  mockery::stub(read_importsealevels, "httr2::req_perform", mock_req_perform)
  mockery::stub(read_importsealevels, "readr::read_csv", mock_read_csv)
  mockery::stub(read_importsealevels, "file.exists", function(...) FALSE)

  result <- read_importsealevels(
    path_csv = mock_csv_path,
    download_latest = TRUE,
    df_stations = df_stations_mock
  )

  expect_true("year" %in% colnames(result))
  expect_true("month" %in% colnames(result))
  expect_true("msl" %in% colnames(result))
  expect_equal(nrow(result), 2)
})

test_that("read_importsealevels handles API errors without mockery", {
  expect_error(
    read_importsealevels(
      path_csv = mock_csv_path,
      download_latest = TRUE,
      df_stations = df_stations_mock,
      api_url = "https://invalid.api.url/doesnotexist"
    ),
    "Error in httr2::request"
  )
})
