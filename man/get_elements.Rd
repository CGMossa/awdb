% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-elements.R
\name{get_elements}
\alias{get_elements}
\title{Get Station Elements}
\usage{
get_elements(aoi = NULL, elements, awdb_options = set_options(), as_sf = FALSE)
}
\arguments{
\item{aoi}{\code{sfc} POLYGON scalar, the area of interest used for performing
a spatial filter on available stations in \code{network}. If \code{NULL} (the default),
no spatial filter is performed.}

\item{elements}{character vector, abbreviations or codes for variables of
interest (e.g., "SMS" for "Soil Moisture Percent"). See Details for available
elements and codes.}

\item{awdb_options}{an \code{awdb_options} list with additional query parameters.}

\item{as_sf}{boolean scalar, whether to return the data as an \code{sf} table.
Default is \code{FALSE}. Repeating the spatial data across each station element
and its time series can be costly.}
}
\value{
if \code{as_sf}, an \code{sf} table, otherwise a simple data.frame. The number
of rows depends on the number of stations and element parameters. Time series
data are included as a list column named \code{"element_values"}.
}
\description{
Get station elements from the  USDA National Water and Climate Center Air and
Water Database REST API. Elements are soil, snow, stream, and weather
variables measured at AWDB stations.
}
\details{
This endpoint will accept the following query parameters via \code{set_options()}:
\itemize{
\item \code{duration}
\item \code{begin_date}
\item \code{end_date}
\item \code{period_reference}
\item \code{central_tendency}
\item \code{return_flags}
\item \code{return_original_values}
\item \code{return_suspect_values}
}

The following can also be passed to filter stations:
\itemize{
\item \code{station_names}
\item \code{dco_codes}
\item \code{county_names}
\item \code{hucs}
\item \code{active_only}
}

You may also specify \code{networks} and \code{request_size}. The \code{networks} parameter
is used internally to build unique station triplet identifiers of the form
\code{station:state:network} which are then passed to the endpoint, so it serves
to filter stations to just those networks. The \code{request_size} parameter is
for handling rate limits, which are based on the number of elements - a hard
value to measure directly, so this parameter is more a rule of thumb than a
strict standard. If processing is slow for you, you may find experimenting
with this parameter useful.

See \code{set_options()} for more details.
\subsection{Element Format}{

Elements are specified as triplets of the form
\code{elementCode:heightDepth:ordinal}. Any part of the element triplet can
contain the \code{*} wildcard character. Both \code{heightDepth} and \code{ordinal} are
optional. The unit of \code{heightDepth} is inches. If \code{ordinal} is not specified,
it is assumed to be 1. Here are some examples:
\itemize{
\item \code{"WTEQ"} - return all snow water equivalent values.
\item \code{"SMS:-8"} - return soil moisture values observed 8 inches below the surface.
\item \code{"SMS:*"} - return soil moisture values for all measured depths.
}
}
}
\examples{
# get snow water equivalent values around Bear Lake
get_elements(bear_lake, elements = "WTEQ")

# return as sf table
get_elements(bear_lake, elements = "WTEQ", as_sf = TRUE)

}
