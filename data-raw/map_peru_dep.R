## code to prepare `map_peru_dep` dataset goes here

librarian::shelf(
    tidyverse
    , sf
    , here
    , raster
    , PeruData
)

zip_sf <- dir(here::here("source-data"), pattern = ".zip", recursive = T, full.names = T)

purrr::map(zip_sf, ~unzip(.x, exdir = here::here("source-data", "map")))


srp_shp <- function(name){
    if(name == "p") {
        shp_file <- "provincias"
    } else if (name == "d"){
        shp_file <- 'distritos'
    } else shp_file <- "departamentos"
    file_name <- paste0(shp_file, ".shp") |> stringr::str_to_upper()
    here::here('source-data', 'map', shp_file, file_name)
}



maps <- c('p', 'd', 'n')

maps1 <-
    purrr::map(maps, srp_shp) |>
    purrr::map(sf::read_sf)

maps1[[4]] <- read_rds(here::here("source-data", "map", "peru.rds")) |> st_as_sf()

maps2 <-
    maps1 |>
    map(clean_sf)
maps2[c(1, 3, 4)] <-
    maps2[c(1, 3, 4)] |>
    map(get_centroid)



maps2[[2]] |>
    filter()

map_peru_prov <- maps2[[1]]
map_peru_dist <- maps2[[2]]
map_peru_depa <- maps2[[3]]
map_peru_peru <- maps2[[4]]




usethis::use_data(map_peru_dist, overwrite = TRUE)
usethis::use_data(map_peru_prov, overwrite = TRUE)
usethis::use_data(map_peru_depa, overwrite = TRUE)
usethis::use_data(map_peru_peru, overwrite = TRUE)




fs::dir_delete(here::here('source-data', "map", c("departamentos", "distritos", "provincias")))


raster_peru_alt <-
    dir(here::here(), pattern = "grd", full.names = T, recursive = T) |>
    raster::raster()
usethis::use_data(raster_peru_alt, overwrite = T)


