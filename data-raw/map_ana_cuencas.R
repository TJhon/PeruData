## code to prepare `map_ana_cuencas` dataset goes here

librarian::shelf(
    tidyverse
    , sf
)


# ana_zip_sf <- dir(here::here("source-data"), pattern = "ana", recursive = T, full.names = T)
#
# purrr::map(ana_zip_sf, ~unzip(.x, exdir = here::here("source-data", "map")))
#
#
# ana_shp <-
#     dir(here::here("source-data"), pattern = ".shp$", recursive = T, full.names = T)
#
#
# dir.create('source-data/map/ana')
#
# ana <-
#     map(ana_shp, read_sf)
#
# saveRDS(ana[[1]], 'source-data/map/ana/cuencas.rds')
# saveRDS(ana[[2]], 'source-data/map/ana/micro_cuencas.rds')

rename_geo <- c("departamen" = "depa", "provincia" = "prov", "distrito" = "dist")

rm(list = ls())


map_ana_cuencas <-
    read_rds('source-data/map/ana/cuencas.rds') |>
    rmapshaper::ms_simplify(keep = .5)
map_ana_microcuencas <-
    read_rds('source-data/map/ana/micro_cuencas.rds') |>
    rmapshaper::ms_simplify(keep = .5)


saveRDS(map_ana_cuencas,'source-data/map/ana/cuencas.rds')
saveRDS(map_ana_microcuencas,'source-data/map/ana/micro_cuencas.rds')

usethis::use_data(map_ana_cuencas, overwrite = TRUE)
usethis::use_data(map_ana_microcuencas, overwrite = TRUE)
use_data(rename_geo, overwrite = T)

