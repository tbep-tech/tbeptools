#' Download daily precip data and summarise by station catchment
#'
#' @param curyr numeric for year
#' @param catchpixels data.frame with columns named 'station' and 'pixel'. A data frame has been created for key Enterococcus stations, associating each station with all pixels in that station's catchment layer. This is the tbeptools object 'catchpixels'.
#' @param mos numeric vector for months to download
#' @param quiet logical for messages
#'
#' @details Data from the Southwest Florida Water Management District's (SWFWMD) ftp site: ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/
#' @return data.frame with station, date, rain columns as a daily average (inches) for all pixels in a catchment
#' @importFrom dplyr %>%
#'
#' @examples
#' \dontrun{
#' read_importrain(2021, catchpixels, quiet = F)
#' }
read_importrain <- function(curyr, catchpixels, mos = 1:12, quiet = T){

  ftp <- 'ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/'

  # all files to dl
  mos <- sprintf('%02d', mos)
  fls <- paste0(ftp, curyr, '/', 'daily_', curyr, '_', mos, '_txt.zip')

  # download, extract, subset, average
  out <- NULL
  for(fl in fls){

    if(!quiet)
      cat(basename(fl), '\n')

    # get the name of the file that will be in the zipped download
    txtflnm <- gsub('_txt.zip', '.txt', basename(fl))

    # download daily month data
    dl <- try({

      tmp1 <- tempfile(fileext = '.zip')
      download.file(url = fl, destfile = tmp1, method = 'curl', quiet = quiet)

    }, silent = quiet)

    # download error
    if(inherits(dl, 'try-error')){

      unlink(tmp1, recursive = T)

      next()

    }

    # import from the zipped file
    datall <- utils::read.table(unz(tmp1, txtflnm),
                         sep = ',', header = F)  %>%
      dplyr::rename(pixel = V1, date = V2, rain = V3)

    unlink(tmp1, recursive = T)


    # join with grd cells, average by date, station
    dat <- dplyr::left_join(catchpixels, datall, by = 'pixel',
                            relationship = 'many-to-many')  %>%
      dplyr::group_by(station, date) %>%
      dplyr::summarise(
        rain = mean(rain, na.rm = T)
      ) %>%
      dplyr::ungroup()

    # append to output
    out <- dplyr::bind_rows(out, dat)


  }

  # date as date
  out <- out |>
    dplyr::mutate(date = as.Date(date, format = '%m/%d/%Y')) %>%
    dplyr::arrange(station, date)

  return(out)

}
