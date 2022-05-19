test_that("Checking read_dlcurrent", {

  xlsx <- 'exdata.xlsx'
  urlin <- 'https://epcbocc.sharepoint.com/:x:/s/Share/EWKgPirIkoxMp9Hm_wVEICsBk6avI9iSRjFiOxX58wXzIQ?e=kAWZXl&download=1'
  expect_message(read_dlcurrent(xlsx, urlin = urlin))

  file.remove(xlsx)

})
