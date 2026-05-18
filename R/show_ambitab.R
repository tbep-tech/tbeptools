#' Create a summary table of AMBI category percentages by bay segment
#'
#' Create a summary table of AMBI category percentages by bay segment
#'
#' @param ambiscr input data frame as returned by \code{\link{anlz_ambiscr}}, the AMBI variant is detected automatically from the column names
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB", "TCB", "MR", "BCB"
#' @param yrrng numeric vector of length two indicating the year range to summarise
#'
#' @return A \code{\link[flextable]{flextable}} object showing the count and percentage of sites in each AMBI category by bay segment over the requested year range.  The bottom row ("All") summarises across all included bay segments.
#' 
#' @export
#'
#' @details
#' Only sampling funded by TBEP and as part of the routine EPC benthic monitoring program are included.  Azoic stations are excluded from counts and percentages.  The year range filter applies to all years from \code{yrrng[1]} through \code{yrrng[2]}.
#'
#' Column header colours match those used in \code{\link{show_ambimatrix}}: Unpolluted (dark green), Slightly Polluted (light green), Meanly Polluted (yellow), Heavily Polluted (orange), and Extremely Polluted (red).
#'
#' @concept show
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' ambiscr <- anlz_ambiscr(benthicdata)
#' show_ambitab(ambiscr)
show_ambitab <- function(ambiscr,
                         bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'),
                         yrrng = c(1993, 2024)) {

  if ('AMBICat' %in% names(ambiscr)) {
    cat_col <- 'AMBICat'
  } else if ('TBAMBICat' %in% names(ambiscr)) {
    cat_col <- 'TBAMBICat'
  } else {
    stop("ambiscr must contain an 'AMBICat' or 'TBAMBICat' column; run anlz_ambiscr() first.")
  }

  if (length(yrrng) == 1)
    yrrng <- rep(yrrng, 2)

  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] <= yrrng[2])

  cat_levs <- c('Extremely Polluted', 'Heavily Polluted', 'Meanly Polluted', 'Slightly Polluted', 'Unpolluted')
  cat_bg <- c(
    'Extremely Polluted' = '#CC3231',
    'Heavily Polluted'   = '#E07B39',
    'Meanly Polluted'    = '#E9C318',
    'Slightly Polluted'  = '#8DBE68',
    'Unpolluted'         = '#2DC938'
  )
  cat_txt <- c(
    'Extremely Polluted' = 'white',
    'Heavily Polluted'   = 'white',
    'Meanly Polluted'    = 'black',
    'Slightly Polluted'  = 'black',
    'Unpolluted'         = 'black'
  )

  segs_all <- c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')

  dat_filt <- ambiscr %>%
    dplyr::filter(AreaAbbr %in% segs_all) %>%
    dplyr::filter(FundingProject %in% 'TBEP') %>%
    dplyr::filter(ProgramID %in% 4) %>%
    dplyr::filter(!is.na(.data[[cat_col]])) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(AreaAbbr %in% bay_segment) %>%
    dplyr::rename(cat = dplyr::all_of(cat_col)) %>%
    dplyr::mutate(cat = dplyr::if_else(cat == 'Azoic', 'Extremely Polluted', cat))

  seg_rows <- dat_filt %>%
    dplyr::add_count(AreaAbbr, name = 'n_seg') %>%
    dplyr::count(AreaAbbr, cat, n_seg, name = 'cnt') %>%
    dplyr::mutate(per = cnt / n_seg * 100) %>%
    tidyr::pivot_wider(
      id_cols = c(AreaAbbr, n_seg),
      names_from = cat,
      values_from = per,
      values_fill = 0
    ) %>%
    dplyr::rename(Segment = AreaAbbr, n = n_seg)

  n_all <- nrow(dat_filt)
  all_row <- dat_filt %>%
    dplyr::group_by(cat) %>%
    dplyr::summarise(cnt = dplyr::n(), .groups = 'drop') %>%
    dplyr::mutate(per = cnt / n_all * 100) %>%
    dplyr::select(cat, per) %>%
    tidyr::pivot_wider(names_from = cat, values_from = per, values_fill = 0) %>%
    dplyr::mutate(Segment = 'All', n = n_all)

  for (lev in cat_levs) {
    if (!lev %in% names(seg_rows)) seg_rows[[lev]] <- 0
    if (!lev %in% names(all_row)) all_row[[lev]] <- 0
  }

  segs_present <- intersect(bay_segment, unique(seg_rows$Segment))
  seg_rows <- seg_rows %>%
    dplyr::mutate(Segment = factor(Segment, levels = segs_present)) %>%
    dplyr::arrange(Segment) %>%
    dplyr::mutate(Segment = as.character(Segment))

  col_order <- c('Segment', 'n', cat_levs)
  tab <- dplyr::bind_rows(
    dplyr::select(seg_rows, dplyr::any_of(col_order)),
    dplyr::select(all_row, dplyr::any_of(col_order))
  )

  cats_present <- cat_levs[cat_levs %in% names(tab)]

  ft <- flextable::flextable(tab) %>%
    flextable::colformat_int(j = 'n') %>%
    flextable::colformat_double(j = cats_present, digits = 2, suffix = '%') %>%
    flextable::bold(i = nrow(tab)) %>%
    flextable::align(align = 'center', part = 'all') %>%
    flextable::align(j = 'Segment', align = 'left', part = 'body') %>%
    flextable::autofit()

  for (cat in cats_present) {
    ft <- ft %>%
      flextable::bg(j = cat, bg = cat_bg[[cat]], part = 'header') %>%
      flextable::color(j = cat, color = cat_txt[[cat]], part = 'header')
  }

  return(ft)

}
