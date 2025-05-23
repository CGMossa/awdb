% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-references.R
\name{get_references}
\alias{get_references}
\title{Get Data Dictionary}
\usage{
get_references(reference_type = "elements")
}
\arguments{
\item{reference_type}{character scalar, the name of the reference. Potential
values include \code{dcos}, \code{durations}, \code{elements} (default), \code{forecastPeriods},
\code{functions}, \code{instruments}, \code{networks}, \code{physicalElements}, \code{states}, and
\code{units}.}
}
\value{
a data.frame with reference data
}
\description{
Get references from the USDA National Water and Climate Center Air and Water
Database REST API. References provide descriptions of all codes used in the
AWDB.
}
\examples{
get_references("elements")

}
