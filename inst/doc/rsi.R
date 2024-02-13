## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = rlang::is_installed("curl") && !is.null(curl::nslookup("r-project.org", error = FALSE)) && !(!interactive() && !isTRUE(as.logical(Sys.getenv("NOT_CRAN", "false"))))
)

## ----setup--------------------------------------------------------------------
#  library(rsi)

## -----------------------------------------------------------------------------
#  our_aoi <- sf::st_bbox(
#    c(xmin = 200000, ymin = 900000, xmax = 200100, ymax = 900100),
#    crs = 26986
#  )
#  our_aoi <- sf::st_as_sf(sf::st_as_sfc(our_aoi))
#  sf::st_area(our_aoi)
#  plot(sf::st_geometry(our_aoi))

## -----------------------------------------------------------------------------
#  our_imagery <- get_landsat_imagery(
#    our_aoi,
#    "2023-09-01",
#    "2023-09-30",
#    output_filename = tempfile(fileext = ".tif")
#  )
#  our_imagery

## -----------------------------------------------------------------------------
#  terra::rast(our_imagery) |>
#    terra::plot()

## -----------------------------------------------------------------------------
#  our_dem <- get_dem(our_aoi)
#  terra::rast(our_dem) |>
#    terra::plot()

## -----------------------------------------------------------------------------
#  spectral_indices() |>
#    head()

## -----------------------------------------------------------------------------
#  filter_platforms(platforms = "Landsat-OLI") |>
#    head()

## -----------------------------------------------------------------------------
#  filter_bands(bands = c("R", "B"))

## -----------------------------------------------------------------------------
#  our_indices <- calculate_indices(
#    our_imagery,
#    filter_bands(bands = names(terra::rast(our_imagery))),
#    "our_indices.tif"
#  )
#  terra::rast(our_indices) |>
#    terra::plot()

## -----------------------------------------------------------------------------
#  evil_index <- spectral_indices()[1, ]
#  evil_index$formula <- "base::system('echo OHNO')"
#  try(
#    calculate_indices(
#      our_imagery,
#      evil_index,
#      tempfile(fileext = ".tif")
#    )
#  )

## -----------------------------------------------------------------------------
#  combined_layers <- stack_rasters(
#    c(our_imagery, our_dem, our_indices),
#    tempfile(fileext = ".vrt")
#  )
#  
#  terra::rast(combined_layers) |>
#    terra::plot()

