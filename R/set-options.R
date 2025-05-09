#' Build List of Additional Query Parameters
#'
#' This is a helper function to make it easier to handle additional query
#' parameters. Provides defaults for each and does type checking.
#'
#' @param networks character vector, abbreviations or codes for station networks
#' of interest (e.g., "USGS" refers to all USGS soil monitoring stations).
#' Default is `*`, for "all networks". See Details for available networks and
#' codes.
#' @param duration character scalar, the temporal resolution of the element
#' measurements. Available values include `daily` (default), `hourly`,
#' `semimonthly`, `monthly`, `calendar_year`, and `water_year`.
#' @param begin_date character scalar, start date for time period of interest.
#' Date must be in format `"YYYY-MM-DD"`.
#' @param end_date character scalar, end date for time period of interest. Date
#' must be in format `"YYYY-MM-DD"`.
#' @param period_reference character scalar, reporting convention to use when
#' returning instantaneous data. Default is `"end"`.
#' @param central_tendency character scalar, the central tendency to return for
#' each element value. Available options include `NULL` (default, no central
#' tendency returned), `median` and `average`.
#' @param return_flags boolean scalar, whether to return flags with each element
#' value. Default is `FALSE`.
#' @param return_original_values boolean scalar, whether to return original
#' element values. Default is `FALSE`.
#' @param return_suspect_values boolean scalar, whether to return suspect element
#' values. Default is `FALSE`.
#' @param begin_publication_date character scalar, the beginning of the
#' publication period for which to retrieve data. Date must be in format
#' `YYYY-MM-DD`. If `NULL`, assumes start of the current water year.
#' @param end_publication_date character scalar, the end of the publication
#' period for which to retrieve data. Date must be in format `YYYY-MM-DD`. If
#' `NULL`, assumes current day.
#' @param exceedence_probabilities integer vector, the probability that
#' streamflow will exceed a specified level.
#' @param forecast_periods character vector, the time period over which to make
#' streamflow forecasts.
#' @param station_names character vector, used to subset stations by their
#' names. Default is `NULL`.
#' @param dco_codes character vector, used to subset stations to those that fall
#' in specified DCOs. Default is `NULL`.
#' @param county_names character vector, used to subset stations to those that
#' fall in specified counties. Default is `NULL`.
#' @param hucs integer vector, used to subset stations to those that fall in
#' specified hydrologic units. Default is `NULL`.
#' @param return_forecast_metadata boolean scalar, whether to return forecast
#' metadata with station locations. Will be included as a list column. Default
#' is `FALSE`.
#' @param return_reservoir_metadata boolean scalar, whether to return reservoir
#' metadata with station locations. Will be included as a list column. Default
#' is `FALSE`.
#' @param return_element_metadata boolean scalar, whether to return element
#' metadata with station locations. Will be included as a list column. Default
#' is `FALSE`.
#' @param active_only boolean scalar, whether to include only active stations.
#' Default is `TRUE`.
#' @param request_size integer scalar, number of individual stations to include
#' in each query. This helps to meet rate limits imposed by the API. If you are
#' getting a request error, you might try lowering this number. Default is
#' `10L`.
#'
#' @return an `awdb_options` list
#'
#' @export
#'
#' @name awdb_options
#'
#' @examples
#' set_options()
#'
set_options <- function(
  networks = "*",
  duration = "daily",
  begin_date = NULL,
  end_date = NULL,
  period_reference = "end",
  central_tendency = NULL,
  return_flags = FALSE,
  return_original_values = FALSE,
  return_suspect_values = FALSE,
  begin_publication_date = NULL,
  end_publication_date = NULL,
  exceedence_probabilities = NULL,
  forecast_periods = NULL,
  station_names = NULL,
  dco_codes = NULL,
  county_names = NULL,
  hucs = NULL,
  return_forecast_metadata = FALSE,
  return_reservoir_metadata = FALSE,
  return_element_metadata = FALSE,
  active_only = TRUE,
  request_size = 10L
) {
  check_character(networks)
  check_string(duration, allow_null = TRUE)
  check_date_format(begin_date)
  check_date_format(end_date)
  check_string(end_date, allow_null = TRUE)
  check_string(period_reference)
  check_string(central_tendency, allow_null = TRUE)
  check_bool(return_flags)
  check_bool(return_original_values)
  check_bool(return_suspect_values)
  check_date_format(begin_publication_date)
  check_date_format(end_publication_date)
  check_whole_number_vector(exceedence_probabilities)
  check_character(forecast_periods, allow_null = TRUE)
  check_character(station_names, allow_null = TRUE)
  check_character(dco_codes, allow_null = TRUE)
  check_character(county_names, allow_null = TRUE)
  check_character(hucs, allow_null = TRUE)
  check_bool(return_forecast_metadata)
  check_bool(return_reservoir_metadata)
  check_bool(return_element_metadata)
  check_bool(active_only)
  check_number_whole(request_size)

  # awdb has both a scalar and vector duration parameter, but for the sake of
  # keeping this api as simple as possible, we use only the scalar version
  if (!rlang::is_null(duration)) {
    rlang::arg_match(
      duration,
      values = c(
        "daily",
        "hourly",
        "semimonthly",
        "monthly",
        "calendar_year",
        "water_year"
      )
    )
  }

  # format queries
  duration <- if_not_null(duration, toupper)
  period_reference <- toupper(period_reference)
  central_tendency <- if_not_null(central_tendency, toupper)
  exceedence_probabilities <- if_not_null(exceedence_probabilities, collapse)
  forecast_periods <- if_not_null(forecast_periods, collapse)
  station_names <- if_not_null(station_names, collapse)
  dco_codes <- if_not_null(dco_codes, collapse)
  county_names <- if_not_null(county_names, collapse)
  hucs <- if_not_null(hucs, collapse)

  # build list
  parameters <- list(
    "networks" = networks,
    "duration" = duration,
    "begin_date" = begin_date,
    "end_date" = end_date,
    "period_reference" = period_reference,
    "central_tendency" = central_tendency,
    "return_flags" = return_flags,
    "return_original_values" = return_original_values,
    "return_suspect_values" = return_suspect_values,
    "begin_publication_date" = begin_publication_date,
    "end_publication_date" = end_publication_date,
    "exceedence_probabilities" = exceedence_probabilities,
    "forecast_periods" = forecast_periods,
    "station_names" = station_names,
    "dco_codes" = dco_codes,
    "county_names" = county_names,
    "hucs" = hucs,
    "return_forecast_metadata" = return_forecast_metadata,
    "return_reservoir_metadata" = return_reservoir_metadata,
    "return_element_metadata" = return_element_metadata,
    "active_only" = active_only,
    "request_size" = request_size
  )

  class(parameters) <- c("awdb_options", "list")

  parameters
}

#'
#' @param x an `awdb_options` list
#' @param ... ignored
#'
#' @rdname awdb_options
#' @export
#'
print.awdb_options <- function(x, ...) {
  parameters <- names(x)
  values <- unlist(as.character(x), use.names = FALSE)

  yes <- "[X]"
  no <- "[ ]"

  check_station <- ifelse(
    parameters %in% c(
      "station_names",
      "dco_codes",
      "county_names",
      "duration",
      "hucs",
      "return_forecast_metadata",
      "return_reservoir_metadata",
      "return_element_metadata",
      "active_only",
      "networks"
    ),
    yes,
    no
  )

  check_element <- ifelse(
    parameters %in% c(
      "station_names",
      "dco_codes",
      "county_names",
      "hucs",
      "active_only",
      "duration",
      "begin_date",
      "end_date",
      "period_reference",
      "central_tendency",
      "return_flags",
      "return_original_values",
      "return_suspect_values",
      "networks",
      "request_size"
    ),
    yes,
    no
  )

  check_forecast <- ifelse(
    parameters %in% c(
      "station_names",
      "dco_codes",
      "county_names",
      "hucs",
      "active_only",
      "begin_publication_date",
      "end_publication_date",
      "exceedence_probabilities",
      "forecast_periods",
      "networks",
      "request_size"
    ),
    yes,
    no
  )

  x[["networks"]] <- collapse(x[["networks"]])

  df <- data.frame(
    VALUE = unlist(as.character(x), use.names = FALSE),
    STATION = check_station,
    ELEMENT = check_element,
    FORECAST = check_forecast
  )

  rownames(df) <- names(x)

  cli::cli_h1("AWDB Query Parameter Set")
  cli::cli_text("Options passed to each endpoint.")
  cli::cli_text("")
  print(df, quote = FALSE)
}

#' Check For `awdb_options` List
#'
#' @keywords internal
#' @noRd
#'
check_awdb_options <- function(awdb_options, call = rlang::caller_call()) {
  if (!rlang::inherits_all(awdb_options, c("awdb_options", "list"))) {
    cli::cli_abort(
      c(
        "{.var awdb_options} must be an {.cls awdb_options} list.",
        "i" = "You can make sure it is by using `awdb_options = set_options()`."
      ),
      call = call
    )
  }
}

#' Check Date is in Proper Format
#'
#' Proper format is "YYYY-MM-DD."
#'
#' @keywords internal
#' @noRd
#'
check_date_format <- function(x, call = rlang::caller_call()) {
  check_string(x, allow_null = TRUE, call = call)

  arg <- rlang::caller_arg(x)

  if (!rlang::is_null(x) && !grepl("^\\d{4}-\\d{2}-\\d{2}$", x)) {
    cli::cli_abort(
      "{.arg {arg}} must be of the form `\"YYYY-MM-DD\"`.",
      call = call
    )
  }
}

#' Check Integers Vector
#'
#' Proper format is "YYYY-MM-DD."
#'
#' @keywords internal
#' @noRd
#'
check_whole_number_vector <- function(x, call = rlang::caller_call()) {
  arg <- rlang::caller_arg(x)

  if (!rlang::is_null(x) && !rlang::is_integer(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be an integer vector.",
      call = call
    )
  }
}

#' If Not NULL
#'
#' @param x an R object
#' @param .f a function to apply to `x`
#'
#' @keywords internal
#' @noRd
#'
if_not_null <- function(x, .f, ...) {
  check_function(.f, ...)

  if (!rlang::is_null(x)) x <- .f(x)

  x
}

#' @keywords internal
#' @noRd
#'
collapse <- function(x) {
  paste0(x, collapse = ",")
}
