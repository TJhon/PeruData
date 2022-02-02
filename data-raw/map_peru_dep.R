## code to prepare `map_peru_dep` dataset goes here

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
maps2 <-
    maps1 |>
    map(janitor::clean_names) |>
    map(~mutate(., across(where(is.character), str_to_sentence))) |>
    map(~select(., !c(fuente))) |>
    map(rmapshaper::ms_simplify)

map_peru_depa <- maps2[[3]]
map_peru_prov <- maps2[[1]]
map_peru_dist <- maps2[[2]]

usethis::use_data(map_peru_depa, overwrite = TRUE)
usethis::use_data(map_peru_prov, overwrite = TRUE)
usethis::use_data(map_peru_dist, overwrite = TRUE)

unzip(a)
