% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/derive_streams.R
\name{watershed_memory}
\alias{watershed_memory}
\title{Calculate RAM needed for deriving the stream network from DEM}
\usage{
watershed_memory(dem)
}
\arguments{
\item{dem}{character; path to DEM raster file.}
}
\value{
MB of RAM needed to derive the stream network with \code{mem = F} in 
\code{\link{derive_streams}}.
}
\description{
See GRASS function \href{https://grass.osgeo.org/grass73/manuals/r.watershed.html}{r.watershed}.
}
\keyword{internal}
