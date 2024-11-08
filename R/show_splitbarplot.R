#' Show a Split Bar Plot with Error Bars
#'
#' This function creates a bar plot with error bars based on two groups split by a year value.
#' It can optionally create an interactive plot and show individual data points.
#'
#' @param df A data frame containing the data to plot
#' @param period_col Name of the column containing values "before" and "after" as an ordered factor
#' @param year_col Name of the column containing year values
#' @param value_col Name of the column containing the values to plot
#' @param x_label_prefix Optional prefix for x-axis labels (default: "")
#' @param interactive Logical; if TRUE, creates an interactive plot using plotly (default: TRUE)
#' @param source if interactive is TRUE, the `source` argument to `plotly::ggplotly` for referencing with click events (default: "A")
#' @param exploded Logical; if TRUE, adds individual points with labels for min, max, and mean (default: FALSE)
#' @param bars_fill Fill color for bars (default: "lightblue")
#' @param bars_alpha Alpha transparency for bars (default: `c("#00BFC4", "#F8766D")`; teal and red)
#' @param label_points Character vector specifying which points to label in exploded view (default: c("min","max","median"))
#' @param label_color Color for labeled points in exploded view (default: "black")
#' @param label_template Glue expression for point labels (default: "{year}: {value} ({type})")
#' @param hover_template Glue expression for hover text (default: "{year}: {value}")
#' @param value_round Integer indicating number of decimal places for rounding values (default: 2)
#' @param text_size Size of text for labels and hover text (default: 14)
#'
#' @return A ggplot2 object or plotly object (if interactive = TRUE)
#'
#' @importFrom dplyr mutate group_by summarise filter sym n arrange desc case_when
#' @importFrom ggplot2 ggplot aes coord_cartesian geom_col geom_errorbar theme_minimal labs geom_point geom_text geom_jitter
#' @importFrom plotly ggplotly
#' @importFrom glue glue
#' @importFrom scales expand_range
#'
#' @export
#'
#' @concept show
#'
#' @examples
#' # Create example data
#' df <- data.frame(
#'   year = 2010:2020,
#'   value = rnorm(11, mean = 10, sd = 2)
#' )
#'
#' # Basic interactive plot
#' show_splitbarplot(df, "year", "value", 2015)
#'
#' # Custom colors and labels with 1 decimal place
#' show_splitbarplot(df, "year", "value", 2015,
#'             bar_fill = "steelblue",
#'             label_points = c("min", "max"),
#'             label_color = "darkred",
#'             value_round = 1)
#'
#' # Custom label templates
#' show_splitbarplot(df, "year", "value", 2015,
#'             label_template = "{year} ({type})",
#'             hover_template = "Year {year}",
#'             value_round = 0)
show_splitbarplot <- function(
    df,
    period_col,
    year_col,
    value_col,
    x_label_prefix = "",
    interactive    = TRUE,
    source         = "A",
    exploded       = FALSE,
    bars_fill      = c("#00BFC4", "#F8766D"),
    bars_alpha     = 0.7,
    label_points   = c("min", "max", "median"),
    label_color    = "black",
    label_template = "{year}: {value} ({type})",
    hover_template = "{year}: {value}",
    value_round    = 2,
    text_size      = 14) {

  # Input validation
  if (!is.data.frame(df)) {
    stop("df must be a data frame")
  }

  if (!all(c(year_col, value_col, period_col) %in% names(df))) {
    stop("Specified columns not found in data frame")
  }

  if (!is.numeric(df[[value_col]])) {
    stop("Year and value columns must be numeric")
  }

  if (!is.factor(df[[period_col]])) {
    stop("The period column must be factor")
  }

  if (!is.logical(interactive) || !is.logical(exploded)) {
    stop("interactive and exploded must be logical values")
  }

  if (!is.numeric(value_round) || value_round < 0) {
    stop("value_round must be a non-negative number")
  }

  valid_point_types <- c("min", "max", "median")
  if (!is.null(label_points) && !all(label_points %in% valid_point_types)) {
    stop("label_points must be NULL or contain only 'min', 'max', or 'median'")
  }

  # Create symbol objects for non-standard evaluation
  year_sym   <- dplyr::sym(year_col)
  value_sym  <- dplyr::sym(value_col)
  period_sym <- dplyr::sym(period_col)

  # Pull years into two groups
  lbl_before <- df |>
    dplyr::filter(!!period_sym == "before") |>
    dplyr::pull(!!year_sym) |>
    util_format_year_range(prefix = x_label_prefix)
  lbl_after  <- df |>
    dplyr::filter(!!period_sym == "after") |>
    dplyr::pull(!!year_sym) |>
    util_format_year_range(prefix = x_label_prefix)

  summary_data <- df |>
    dplyr::group_by(!!period_sym) |>
    dplyr::summarise(
      mean_val   = mean(!!value_sym),
      sd_val     = stats::sd(!!value_sym),
      n          = dplyr::n(),
      min_val    = min(!!value_sym),
      max_val    = max(!!value_sym),
      median_val = stats::median(!!value_sym),
      .groups = "drop") |>
    dplyr::mutate(
      sd_val = ifelse(n == 1, NA, sd_val))  # Remove SD for single-value groups
  y_rng <- with(
    summary_data,
    range(
      # mean_val - sd_val,
      # mean_val + sd_val)) |>
      min_val,
      max_val)) |>
    scales::expand_range(mul = 0.05)

  # Create base plot
  p <- ggplot2::ggplot(
    summary_data,
    ggplot2::aes(
      x    = !!period_sym,
      y    = mean_val,
      fill = !!period_sym)) +
    ggplot2::geom_col(alpha = bars_alpha) +
    ggplot2::scale_fill_manual(values = bars_fill) +
    ggplot2::geom_errorbar(
      ggplot2::aes(ymin = mean_val - sd_val, ymax = mean_val + sd_val),
      width = 0.2,
      na.rm = TRUE,
      color = "darkgray") +
    ggplot2::coord_cartesian(
      ylim = y_rng) + # expand_range
    # ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text       = element_text(size = text_size),
      axis.title      = ggplot2::element_blank(),
      legend.position = "none")

  # Add exploded view if requested
  if (exploded) {
    # Prepare individual points data with hover text
    points_data <- df |>
      dplyr::group_by(!!period_sym) |>
      dplyr::mutate(
        group_mean = mean(!!value_sym),
        dist_to_mean = abs(!!value_sym - group_mean),
        point_type = dplyr::case_when(
          !!value_sym == min(!!value_sym) ~ "min",
          !!value_sym == max(!!value_sym) ~ "max",
          dist_to_mean == min(dist_to_mean) ~ "median"
        ),
        value_round = round(!!value_sym, value_round),
        hover_text = glue::glue(
          hover_template,
          year = !!year_sym,
          value = value_round)
      ) |>
      dplyr::ungroup()

    # Create points plot to get jittered positions
    points_plot <- ggplot2::ggplot_build(
      ggplot2::ggplot() +
        ggplot2::geom_jitter(
          data = points_data,
          ggplot2::aes(x = as.numeric(!!period_sym), y = !!value_sym),
          height = 0,
          width = 0.2))

    # Extract jittered positions and combine with original data
    jittered_data <- points_data |>
      dplyr::mutate(
        x = points_plot$data[[1]]$x,
        x_orig = as.numeric(!!period_sym))

    # Add background points
    p <- p +
      suppressWarnings(
        ggplot2::geom_point(
          data = jittered_data, #|>
          # dplyr::filter(is.na(point_type) | !point_type %in% label_points),
          ggplot2::aes(x = x, y = !!value_sym, text = hover_text),
          alpha = 0.5))

    # Add labeled points if requested
    if (!is.null(label_points)) {
      labeled_data <- jittered_data |>
        dplyr::filter(point_type %in% label_points) |>
        # get single instance of each combination of period and point_type
        dplyr::distinct(!!period_sym, point_type, .keep_all = TRUE) |>
        dplyr::mutate(
          label = glue::glue(
            label_template,
            year  = !!year_sym,
            value = value_round,
            type  = point_type) )

      p <- p +
        ggplot2::geom_point(
          data = labeled_data,
          ggplot2::aes(x = x, y = !!value_sym),
          # color = label_color,
          size = 2) +
        ggplot2::geom_text(
          data = labeled_data,
          ggplot2::aes(x = x, y = !!value_sym, label = label),
          check_overlap = T,
          nudge_y = -0.5)
          # size = 2,
          # color = label_color)
    }
  }

  # Return interactive or static plot
  if (interactive) {
    return(plotly::ggplotly(p, tooltip = "text", source = source))
  } else {
    return(p)
  }
}

# df <- data.frame(
#   year = 1989:2020,
#   value = rnorm(length(1989:2020), mean = 10, sd = 2))
# show_splitbarplot(df, "year", "value", 2015)
# show_splitbarplot(df, "year", "value", 2015, interactive = F)
# show_splitbarplot(df, "year", "value", 2015, exploded = T)
# show_splitbarplot(
#   df, "year", "value", 2015)
#
# show_splitbarplot(
#   df, "year", "value", 2018,
#   exploded = T,
#   label_color = "black",
#   label_template = "{year}: {value}")
