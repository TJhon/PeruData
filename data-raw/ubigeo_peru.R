## code to prepare `ubigeo_peru` dataset goes here

ubi <- readxl::read_excel(dir(here::here("source-data"), full.names = T, pattern = "ubigeo"))
ubigeo_peru <-
    ubi |>
    janitor::clean_names() |>
    relocate(
        ubigeo
        , depa = departamento
        , prov = provincia
        , dist = distrito
        ) |>
    mutate(
        across(where(is.character), PeruData::tidy_text)
    )


usethis::use_data(ubigeo_peru, overwrite = TRUE)
