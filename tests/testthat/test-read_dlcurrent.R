test_that("Checking read_dlcurrent", {

  xlsx <- 'exdata.xlsx'
  urlin <- 'https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1'
  expect_message(read_dlcurrent(xlsx, urlin = urlin))

  file.remove(xlsx)

})
