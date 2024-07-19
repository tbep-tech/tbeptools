library(tidyverse)
library(here)

# load the catchpixels data file
load(here('data/catchpixels.RData'))


# set up function to loop through several years
read_importrain_many <- function(yrs,
                                 quiet = FALSE){
  yrs <- yrs
  prcp_out <- list()

  for(i in seq_along(yrs)){
    yr = yrs[[i]]
    prcptmp <- read_importrain(curyr = yr,
                               catchpixels = catchpixels,
                               quiet = quiet)
    prcp_out[[i]] <- prcptmp
    rm(prcptmp)
    # pause for 5 seconds between years
    Sys.sleep(5)
  }

  prcpdat <- dplyr::bind_rows(prcp_out)
  return(prcpdat)
}

# loop through 10 years at a time, pausing for a few seconds in between

prcp_1995.2004 <- read_importrain_many(yrs = 1995:2004, quiet = FALSE)
Sys.sleep(5)
prcp_2005.2014 <- read_importrain_many(yrs = 2005:2014, quiet = FALSE)
Sys.sleep(5)
prcp_2015.2023 <- read_importrain_many(yrs = 2015:2023, quiet = FALSE)


# bind it all together
catchprecip <- dplyr::bind_rows(prcp_1995.2004,
                             prcp_2005.2014,
                             prcp_2015.2023)


save(catchprecip, file = here('data/catchprecip.RData'), compress = 'xz')
