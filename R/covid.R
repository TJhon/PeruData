covid_last_casos_fallecidos <- function(
    datos = c('casos', "fallecidos"), sleep = 10, n_rows = Inf, load_data = F, r_restart = F){

    message("Downloading .... \n")

    covid_dir <- paste("covid-data", c("input", "output"), sep = "/")
    csv <- paste(covid_dir[1], paste0(names(covid_links), ".csv"), sep = "/")

    try(fs::dir_create(covid_dir))

    purrr::map2(covid_links[datos], csv, download.file)

    fs::dir_tree('covid-data')

    pracma::tic()

    message("Read source data \n")

    casos <- vroom::vroom('covid-data/input/casos.csv', delim = ";", n_max = n_rows, show_col_types = F)

    Sys.sleep(sleep)

    fall <- vroom::vroom('covid-data/input/fallecidos.csv', delim = ";", n_max = n_rows, show_col_types = F)

    Sys.sleep(sleep)

    message("\nClean source data \n")

    casos1 <-
        casos |>
        janitor::clean_names() |>
        drop_na(fecha_resultado) |>
        mutate(
            across(where(is.character), tidy_text)
            , fecha = lubridate::ymd(fecha_resultado)
        )  |>
        select(!contains("fecha_")) |>
        relocate(fecha) |>
        arrange(fecha) |>
        count(fecha, ubigeo, departamento, provincia, distrito, metododx, sexo) |>
        pivot_wider(names_from = metododx, values_from = n)

    Sys.sleep(sleep)

    fall1 <-
        fall |>
        janitor::clean_names() |>
        drop_na(fecha_fallecimiento) |>
        mutate(
            across(where(is.character), tidy_text)
            , fecha = lubridate::ymd(fecha_fallecimiento)
        ) |>
        mutate(clasificacion_def = str_replace_all(clasificacion_def, "[^[:alnum:]]", "_")) |>
        select(!contains("fecha_")) |>
        relocate(fecha) |>
        arrange(fecha) |>
        count(fecha, ubigeo, departamento, provincia, distrito, sexo, clasificacion_def, name = 'fallecidos') |>
        pivot_wider(names_from = clasificacion_def, values_from = fallecidos)

    fall1 |>
        mutate(across(contains('criterio'), replace_na, 0)) |>
        rowwise() |>
        mutate()

    # iconv(astr, from = 'UTF-8', to = 'ASCII//TRANSLIT')
    full_casos <-
        full_join(casos1, fall1, ) |>
        mutate(
            across(pr:ag, ~replace_na(., 0))
            , across(contains("criterio"), replace_na, 0)
        ) |>
        rowwise() |>
        mutate(
            total_casos = sum(pcr:ag)
            , total_fallecidos = sum(criterio_cla_nico:criterio_serola_gico)
            # , total_fallecidos = sum(contains("criterio"))
        ) |>
        relocate(total_casos, .after = ag) |>
        ungroup() |>
        replace_na(list(fallecidos = 0, clasificacion_def = "_")) |>
        arrange(desc(fecha))

    message("Write clean data \n")

    full_casos |>
        write.csv('covid-data/output/casos-fallecidos.csv', row.names = F)

    Sys.sleep(sleep)

    pracma::toc()
    message("Data in 'covid-data/output/casos-fallecidos.csv \n")
    fs::dir_tree("covid-data")

    if(r_restart){
        .rs.restartR()
    }
    if(load_data){
        datos_cl <- here::here('covid-data/output/casos-fallecidos.csv')
        return(read_csv(datos_cl))
    } else head(full_casos, 2)

}


