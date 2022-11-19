#' Evaluate Habitat Master Plan progress for report card
#'
#' Evaluate Habitat Master Plan progress for report card
#'
#' @param acres \code{data.frame} for intertidal and supratidal land use and cover of habitat types for each year of data
#' @param subtacres \code{data.frame} for subtidal cover of habitat types for each year of data
#' @param hmptrgs \code{data.frame} of Habitat Master Plan targets and goals
#'
#' @return A summarized \code{data.frame} appropriate for creating a report card
#'
#' @concept analyze
#'
#' @details The relevant output columns are \code{targeteval} and \code{goaleval} that indicate numeric values as -1 (target not met, trending below), 0 (target met, trending below), 0.5 (target not met, trending above), and 1 (target met, trending above).
#'
#' @export
#'
#' @examples
#' # view summarized data for report card
#' anlz_hmpreport(acres, subtacres, hmptrgs)
anlz_hmpreport <- function(acres, subtacres, hmptrgs){

  # format datasets
  sub <- subtacres %>%
    dplyr::ungroup() %>%
    dplyr::rename(
      year = name,
      metric = HMPU_TARGETS
    )
  supra <- acres %>%
    dplyr::ungroup() %>%
    dplyr::rename(
      year = name,
      metric = HMPU_TARGETS
    )
  totinter <- supra %>%
    dplyr::filter(metric %in% c('Mangrove Forests', 'Salt Barrens', 'Salt Marshes')) %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(Acres = sum(Acres)) %>%
    dplyr::mutate(metric = 'Total Intertidal')
  supra <- bind_rows(supra, totinter)
  targets <- hmptrgs %>%
    dplyr::select(
      metric = HMPU_TARGETS,
      category = Category,
      Target = Target2030,
      Goal = Target2050
    ) %>%
    dplyr::mutate(
      metric = as.character(metric),
      category = gsub('tidal$', '', category)
    ) %>%
    dplyr::filter(
      !metric %in% c('Living Shoreline', 'Hard Bottom', 'Artificial Reefs')
    )

  # combine and sort
  allacres <- rbind(sub, supra) %>%
    dplyr::arrange(metric, year) %>%
    dplyr::mutate(
      lacres = dplyr::lag(Acres),
      yr = as.numeric(year),
      lyr = dplyr::lag(yr)
    ) %>%
    dplyr::group_by(metric) %>%
    dplyr::mutate(
      lacres = ifelse(dplyr::row_number() == 1, NA, lacres),
      lyr = ifelse(dplyr::row_number() == 1, NA, lyr)
    ) %>%
    dplyr::ungroup()

  # join with targets
  alldat <- allacres %>%
    dplyr::full_join(targets, by = "metric") %>%
    dplyr::mutate(
      acresdiff = Acres - lacres,
      yeardiff = yr - lyr,
      changerate = acresdiff / yeardiff,
      targetrate = (Target - Acres) / (2030 - yr),
      goalrate = (Goal - Acres) / (2050 - yr),
      targetprop = round(Acres / Target, 2),
      goalprop = round(Acres / Goal, 2)
    )

  # apply conditions
  out <- alldat %>%
    dplyr::mutate(
      targeteval = dplyr::case_when(
        Acres > Target & changerate > targetrate ~ 1,
        Acres > Target & !is.na(changerate) & changerate < targetrate ~ 0,
        Acres < Target & changerate > targetrate ~ 0.5,
        Acres < Target & !is.na(changerate) & changerate < targetrate ~ -1
      ),
      goaleval = dplyr::case_when(
        Acres > Goal & changerate > goalrate ~ 1,
        Acres > Goal & !is.na(changerate) & changerate < goalrate ~ 0,
        Acres < Goal & changerate > goalrate ~ 0.5,
        Acres < Goal & !is.na(changerate) & changerate < goalrate ~ -1
      )
    ) %>%
    dplyr::filter(!is.na(changerate))%>%
    dplyr::arrange(category, year, metric)

  return(out)

}
