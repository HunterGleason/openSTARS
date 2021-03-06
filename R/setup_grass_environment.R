#' Setup 'GRASS' environment.
#'
#' This function sets the 'GRASS' mapset to PERMANENT and sets its projection and extension.
#'
#' @param dem character; path to DEM.  
#' @param epsg integer (optional); EPSG code for the projection to use. If not given (default)
#'   the information is taken from the dem. This should ONLY be used if the \code{dem} does not 
#'   contain projection information and MUST be the correct one for the dem used.
#' @param sites (deprecated); not used any more. Only included for compatibility with previous version.
#'
#' @return Nothing, the 'GRASS' mapset is set to PERMANENT, the extent of the current location 
#'  is set to the one of the dem, and the projection is set to the one of the dem or to the 
#'  one provided in \code{epsg} .
#'
#' @note A 'GRASS' session must be initiated before, see \code{\link[rgrass7]{initGRASS}}. This function 
#'   uses \code{use_sp()} from the \code{rgrass7} package to support raster data.
#' 
#' @author Mira Kattwinkel, \email{mira.kattwinkel@@gmx.net}
#' @export
#'
#' @examples
#' \donttest{
#' # Initiate GRASS session
#' if(.Platform$OS.type == "windows"){
#'   gisbase = "c:/Program Files/GRASS GIS 7.6"
#'   } else {
#'   gisbase = "/usr/lib/grass74/"
#'   }
#' initGRASS(gisBase = gisbase,
#'     home = tempdir(),
#'     override = TRUE)
#'
#' # Load files into GRASS
#' dem_path <- system.file("extdata", "nc", "elev_ned_30m.tif", package = "openSTARS")
#' setup_grass_environment(dem = dem_path)
#' gmeta()
#' }

setup_grass_environment <- function(dem, epsg = NULL, sites = NULL) {
  if (nchar(get.GIS_LOCK()) == 0)
    stop("GRASS not initialised. Please run initGRASS().")
  message("Setting up GRASS Environment ...\n")
  
  if(!is.null(sites))
    message(writeLines(strwrap("'sites' is no longer a parameter of setup_grass_environment (see help). \nThe function will still execute normally. Please update your code.",
            width = 80)))
  
  use_sp()
  
  dem_raster <- raster::raster(dem)
  #dem_proj <- raster::projection(dem_raster)
  dem_extent <- raster::extent(dem_raster)
  #dem_extent <- as(dem_extent, 'SpatialPolygons')
  #dem_extent <- SpatialPolygonsDataFrame(dem_extent, data.frame(ID = 1))
  dem_res_x <- raster::xres(dem_raster)
  dem_res_y <- raster::yres(dem_raster)
  if(round(dem_res_x,10) != round(dem_res_y,10))
    warning("North-south and east-west resolution of dem differ. Please check!")
  dem_west <- dem_extent@xmin
  dem_east <- dem_extent@xmax
  dem_south <- dem_extent@ymin
  dem_north <- dem_extent@ymax
  # otherwise there might be strange cell sizes as extent seems to have priority
  remainder_x <- (dem_north - dem_south) %% dem_res_x
  if(remainder_x != 0)
    dem_south <- dem_south - (dem_res_x - remainder_x)
  remainder_y <- (dem_west - dem_east) %% dem_res_y
  if(remainder_y != 0)
    dem_west <- dem_west - (dem_res_y - remainder_y)
  
  execGRASS("g.mapset", flags = c("quiet"),
            parameters = list(
              mapset = "PERMANENT"))
  # g.proj must be executed before g.region, otherwise cell sizes etc. are overwritten
  if(!is.null(epsg)){
    message("WARNING: 'epsg' should only be used if the dem does not contain projection information. It must be the correct one for the dem.")
    execGRASS("g.proj", flags = c("c", "quiet"),
              parameters = list(
                epsg = epsg
              ))    
  }else {
    execGRASS("g.proj", flags = c("c", "quiet"),
              parameters = list(
                georef = dem
              ))
  }
  execGRASS("g.region", flags = c("verbose"),
            parameters = list(
              nsres = as.character(dem_res_y),
              ewres = as.character(dem_res_x),
              n = as.character(dem_north),
              s = as.character(dem_south),
              e = as.character(dem_east),
              w = as.character(dem_west)
            ))
}
