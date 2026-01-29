library(mockery)

test_that("read_importrainmany works correctly", {
  # Create a mock version of read_importrain
  mock_read_importrain <- mock(
    tibble::tibble(
      station = c("station1", "station1", "station2"),
      date = as.Date(c("2021-01-01", "2021-01-02", "2021-01-03")),
      rain = c(0.1, 0.2, 0.3)
    )
  )

  # Use with_mocked_bindings
  with_mocked_bindings(
    read_importrain = mock_read_importrain,
    {
      # Call the function with mocked dependencies
      result <- read_importrainmany(2021, quiet = FALSE)

      # Define expected output
      expected_output <- tibble::tibble(
        station = c("station1", "station1", "station2"),
        date = as.Date(c("2021-01-01", "2021-01-02", "2021-01-03")),
        rain = c(0.1, 0.2, 0.3)
      )

      # Check if the result matches the expected output
      expect_equal(result, expected_output)

      # Verify that the mock read_importrain was called as expected
      expect_called(mock_read_importrain, 1)
    }
  )
})
