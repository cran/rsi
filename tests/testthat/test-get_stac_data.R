test_that("get_landsat_imagery() is stable", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_landsat_imagery(
      aoi,
      "2022-06-01",
      "2022-06-30",
      output_filename = tempfile(fileext = ".tif")
    )
  )
  expect_no_error(terra::rast(out))
  expect_true(
    all(
      names(terra::rast(out)) %in%
        as.vector(landsat_band_mapping$planetary_computer_v1)
    )
  )
})

test_that("get_sentinel1_imagery() is stable", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_sentinel1_imagery(
      aoi,
      "2022-06-01",
      "2022-06-30",
      output_filename = tempfile(fileext = ".tif")
    )
  )
  expect_no_error(terra::rast(out))
  expect_true(
    all(
      names(terra::rast(out)) %in%
        as.vector(sentinel1_band_mapping$planetary_computer_v1)
    )
  )
})

test_that("get_sentinel2_imagery() is stable", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_sentinel2_imagery(
      aoi,
      "2022-06-01",
      "2022-06-30",
      output_filename = tempfile(fileext = ".tif"),
      mask_function = sentinel2_mask_function
    )
  )
  expect_no_error(terra::rast(out))
  expect_true(
    all(
      names(terra::rast(out)) %in%
        as.vector(sentinel2_band_mapping$planetary_computer_v1)
    )
  )
})

test_that("get_dem() is stable", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_dem(
      aoi,
      output_filename = tempfile(fileext = ".tif")
    )
  )
  expect_no_error(terra::rast(out))
  expect_true(
    all(
      names(terra::rast(out)) %in%
        as.vector(dem_band_mapping$planetary_computer_v1)
    )
  )
})

test_that("non-default mappings work", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_sentinel2_imagery(
      aoi,
      "2022-06-01",
      "2022-06-30",
      output_filename = tempfile(fileext = ".tif"),
      asset_names = sentinel2_band_mapping$aws_v1
    )
  )
  expect_no_error(terra::rast(out))
  expect_true(
    all(
      names(terra::rast(out)) %in%
        as.vector(sentinel2_band_mapping$aws_v1)
    )
  )
})

test_that("can download RTC products", {
  skip_if(Sys.getenv("rsi_pc_key") == "", "Environment variable `rsi_pc_key` not set")
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_sentinel1_imagery(
      aoi,
      "2022-06-01",
      "2022-06-30",
      output_filename = tempfile(fileext = ".tif"),
      collection = "sentinel-1-rtc"
    )
  )
  expect_no_error(terra::rast(out))
  expect_true(
    all(
      names(terra::rast(out)) %in%
        as.vector(sentinel1_band_mapping$planetary_computer_v1)
    )
  )
})

test_that("hidden arguments work", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_landsat_imagery(
      aoi,
      "2022-06-01",
      "2022-06-30",
      output_filename = tempfile(fileext = ".tif"),
      query_function = default_query_function,
      mask_function = landsat_mask_function
    )
  )
  expect_no_error(terra::rast(out))
  expect_true(
    all(
      names(terra::rast(out)) %in%
        as.vector(landsat_band_mapping$planetary_computer_v1)
    )
  )
})

test_that("simple merge method works", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_no_error(
    out <- get_stac_data(
      aoi,
      "2021-01-01",
      "2021-12-31",
      asset_names = "lcpri",
      stac_source = "https://planetarycomputer.microsoft.com/api/stac/v1",
      collection = "usgs-lcmap-conus-v13",
      query_function = default_query_function,
      sign_function = rsi::sign_planetary_computer,
      output_filename = tempfile(fileext = ".tif")
    )
  )
  expect_no_error(terra::rast(out))
})

test_that("warning (but not error) fires if `mask_band` is not NULL with NULL `mask_function`", {
  skip_on_cran()
  aoi <- sf::st_point(c(-74.912131, 44.080410))
  aoi <- sf::st_set_crs(sf::st_sfc(aoi), 4326)
  aoi <- sf::st_buffer(sf::st_transform(aoi, 3857), 1000)

  expect_snapshot(
    x <- get_landsat_imagery(
      aoi = aoi,
      start_date = "2022-06-01",
      end_date = "2022-08-01",
      mask_function = NULL,
      rescale_bands = FALSE,
      output_filename = tempfile(fileext = ".tif")
    )
  )
})

test_that("get_*_data works with mapply() (#17)", {
  skip_on_cran()
  san_antonio = sf::st_point(c(-98.491142, 29.424349))
  san_antonio = sf::st_sfc(san_antonio, crs = "EPSG:4326")
  san_antonio = sf::st_buffer(sf::st_transform(san_antonio, "EPSG:3081"), 1000)

  expect_no_error(
    mapply(
      get_landsat_imagery,
      start_date = c("2023-09-01", "2023-10-01"),
      end_date = c("2023-09-30", "2023-10-31"),
      output_filename = replicate(2, tempfile(fileext = ".tif")),
      MoreArgs = c(aoi = list(san_antonio))
    )
  )
})