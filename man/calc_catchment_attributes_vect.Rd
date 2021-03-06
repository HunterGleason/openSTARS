% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_attributes_edges.R
\name{calc_catchment_attributes_vect}
\alias{calc_catchment_attributes_vect}
\title{calc_catchment_attributes_vect
Aggregate attributes for the total catchment of each stream segment.}
\usage{
calc_catchment_attributes_vect(dt, stat_vect, attr_name_vect, round_dig)
}
\arguments{
\item{dt}{data.table of stream topology and attributes per segment.}

\item{stat_vect}{name or character vector giving the statistics to be calculated,
must be one of: percent, sum.}

\item{attr_name_vect}{name or character vector of column names for the attribute(s)
to be calculated.}

\item{round_dig}{integer; number of digits to round results to. Can be a vector
of different values or just one value for all attributes.}
}
\value{
Nothing. The function changes the values of the columns attr_name_vect in dt.
}
\description{
This function aggregates the attributes of each segment for the total
catchment of each stream segment. It is called within \code{\link{calc_attributes_edges}}
and should not be called by the user.
}
