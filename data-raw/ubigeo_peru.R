## code to prepare `ubigeo_peru` dataset goes here

ubi <- readxl::read_excel(dir(here::here("source-data"), full.names = T))
ubigeo_peru <-
    ubi |>
    janitor::clean_names() |>
    relocate(
        ubigeo
        , dep = departamento
        , prov = provincia
        , dist = distrito
        ) |>
    mutate(
        across(where(is.character), str_trim)
    )


usethis::use_data(ubigeo_peru, overwrite = TRUE)
