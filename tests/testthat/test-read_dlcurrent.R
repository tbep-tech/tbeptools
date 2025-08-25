test_that("read_dlcurrent returns early when download_latest is FALSE", {
  # This should return NULL and not call any other functions
  result <- read_dlcurrent(
    locin = "test.xlsx", 
    download_latest = FALSE, 
    urlin = "http://example.com/file.xlsx"
  )
  
  expect_null(result)
})

test_that("read_dlcurrent downloads file when local file does not exist", {
  # Mock all the functions we need
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", FALSE)
  stub(read_dlcurrent, "file.copy", TRUE)
  
  # Capture messages
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    ),
    "File test.xlsx does not exist, replacing with downloaded file..."
  )
})

test_that("read_dlcurrent replaces file when MD5 hashes are different", {
  # Mock functions
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", TRUE)
  
  # Mock MD5 sums to be different
  stub(read_dlcurrent, "tools::md5sum", function(file) {
    if (file == "temp_file.xlsx") {
      c("temp_file.xlsx" = "hash1")
    } else {
      c("test.xlsx" = "hash2")
    }
  })
  
  stub(read_dlcurrent, "file.copy", TRUE)
  
  # Should get replacement message
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    ),
    "Replacing local file with current..."
  )
})

test_that("read_dlcurrent keeps file when MD5 hashes are the same", {
  # Mock functions
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", TRUE)
  
  # Mock MD5 sums to be the same
  stub(read_dlcurrent, "tools::md5sum", function(file) {
    c("file" = "same_hash")
  })
  
  # Should get "current" message
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    ),
    "File is current..."
  )
})

test_that("read_dlcurrent calls download.file with correct parameters", {
  # Create a mock for download.file to capture arguments
  mock_download <- mock(TRUE)
  stub(read_dlcurrent, "download.file", mock_download)
  
  # Mock other functions
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "file.exists", FALSE)
  stub(read_dlcurrent, "file.copy", TRUE)
  
  # Call function
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    )
  )
  
  # Check that download.file was called with correct arguments
  expect_called(mock_download, 1)
  args <- mock_args(mock_download)[[1]]
  expect_equal(args$url, "http://example.com/file.xlsx")
  expect_equal(args$destfile, "temp_file.xlsx")
  expect_equal(args$method, "libcurl")
  expect_equal(args$mode, "wb")
  expect_equal(args$quiet, TRUE)
})

test_that("read_dlcurrent calls tempfile with correct file extension", {
  # Mock tempfile to capture arguments
  mock_tempfile <- mock("temp_file.xlsx")
  stub(read_dlcurrent, "tempfile", mock_tempfile)
  
  # Mock other functions
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", FALSE)
  stub(read_dlcurrent, "file.copy", TRUE)
  
  # Call function
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    )
  )
  
  # Check that tempfile was called with correct extension
  expect_called(mock_tempfile, 1)
  args <- mock_args(mock_tempfile)[[1]]
  expect_equal(args$fileext, "xlsx")
})

test_that("read_dlcurrent calls file.copy with overwrite when replacing", {
  # Mock file.copy to capture arguments
  mock_copy <- mock(TRUE)
  stub(read_dlcurrent, "file.copy", mock_copy)
  
  # Mock other functions
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", TRUE)
  
  # Mock MD5 sums to be different (trigger replacement)
  stub(read_dlcurrent, "tools::md5sum", function(file) {
    if (file == "temp_file.xlsx") {
      c("temp_file.xlsx" = "hash1")
    } else {
      c("test.xlsx" = "hash2")
    }
  })
  
  # Call function
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    )
  )
  
  # Check that file.copy was called with overwrite=TRUE
  expect_called(mock_copy, 1)
  args <- mock_args(mock_copy)[[1]]
  expect_equal(args[[1]], "temp_file.xlsx")  # from
  expect_equal(args[[2]], "test.xlsx")       # to
  expect_equal(args$overwrite, TRUE)
})

test_that("read_dlcurrent calls file.copy without overwrite for new file", {
  # Mock file.copy to capture arguments
  mock_copy <- mock(TRUE)
  stub(read_dlcurrent, "file.copy", mock_copy)
  
  # Mock other functions
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", FALSE)  # File doesn't exist
  
  # Call function
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    )
  )
  
  # Check that file.copy was called without overwrite parameter
  expect_called(mock_copy, 1)
  args <- mock_args(mock_copy)[[1]]
  expect_equal(args[[1]], "temp_file.xlsx")  # from
  expect_equal(args[[2]], "test.xlsx")       # to
  expect_null(args$overwrite)  # Should not have overwrite parameter
})

test_that("read_dlcurrent does not call file.copy when file is current", {
  # Mock file.copy
  mock_copy <- mock(TRUE)
  stub(read_dlcurrent, "file.copy", mock_copy)
  
  # Mock other functions
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", TRUE)
  
  # Mock MD5 sums to be the same (file is current)
  stub(read_dlcurrent, "tools::md5sum", function(file) {
    c("file" = "same_hash")
  })
  
  # Call function
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    ),
    "File is current..."
  )
  
  # Check that file.copy was NOT called
  expect_called(mock_copy, 0)
})

test_that("read_dlcurrent works with different file extensions", {
  # Test with .csv extension
  stub(read_dlcurrent, "tempfile", "temp_file.csv")
  stub(read_dlcurrent, "tools::file_ext", "csv")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", FALSE)
  stub(read_dlcurrent, "file.copy", TRUE)
  
  expect_message(
    read_dlcurrent(
      locin = "test.csv", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.csv"
    ),
    "File test.csv does not exist, replacing with downloaded file..."
  )
})

test_that("read_dlcurrent handles MD5 comparison correctly", {
  # Mock functions
  stub(read_dlcurrent, "tempfile", "temp_file.xlsx")
  stub(read_dlcurrent, "tools::file_ext", "xlsx")
  stub(read_dlcurrent, "download.file", TRUE)
  stub(read_dlcurrent, "file.exists", TRUE)
  
  # Create a proper mock function that returns different hashes based on filename
  stub(read_dlcurrent, "tools::md5sum", function(file) {
    if (file == "temp_file.xlsx") {
      c("temp_file.xlsx" = "temp_hash")
    } else if (file == "test.xlsx") {
      c("test.xlsx" = "local_hash") 
    } else {
      c("unknown_file" = "default_hash")
    }
  })
  
  stub(read_dlcurrent, "file.copy", TRUE)
  
  # Call function - should trigger replacement since hashes are different
  expect_message(
    read_dlcurrent(
      locin = "test.xlsx", 
      download_latest = TRUE, 
      urlin = "http://example.com/file.xlsx"
    ),
    "Replacing local file with current..."
  )
})
