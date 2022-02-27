#' Get cases and death COVID data Peru
#' @author Jhon Flores rojas
#' @description Download, summarise and save data from cases and death
#' @param datos Name from data
#' @param sleep Time sleep
#' @param load_data Load data into actual R session
#' @param n_rows Rows to read from data. Default Inf (all data)
#' @param r_restart TRUE to restar Rstudio session
#' @export
#' @examples
#' library(dplyr)
#' library(tidyr)
#' library(PeruData)
#' library(purrr)
#' library(vroom)
#' library(fs)
#' library(readr)
#'
#' #covid_last_casos_fallecidos()
#' #fs::dir_tree('covid-data')
#' #covid_last <- read_csv("covid-data/output/casos-fallecidos.csv")
covid_last_casos_fallecidos <- function(
    datos = c('casos', "fallecidos"), sleep = 10, n_rows = Inf, load_data = F, r_restart = F){

    message("Downloading .... \n")

    covid_dir <- paste("covid-data", c("input", "output"), sep = "/")
    csv <- paste(covid_dir[1], paste0(names(covid_links), ".csv"), sep = "/")

    try(fs::dir_create(covid_dir))

    purrr::map2(covid_links[datos], csv, utils::download.file)

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
        tidyr::drop_na(fecha_resultado) |>
        dplyr::mutate(
            dplyr::across(tidyselect:::where(is.character), tidy_text)
            , fecha = lubridate::ymd(fecha_resultado)
        )  |>
        dplyr::select(!dplyr::contains("fecha_")) |>
        dplyr::relocate(fecha) |>
        dplyr::arrange(fecha) |>
        dplyr::count(fecha, ubigeo, departamento, provincia, distrito, metododx, sexo) |>
        tidyr::pivot_wider(names_from = metododx, values_from = n)

    Sys.sleep(sleep)

    fall1 <-
        fall |>
        janitor::clean_names() |>
        tidyr::drop_na(fecha_fallecimiento) |>
        dplyr::mutate(
            dplyr::across(tidyselect:::where(is.character), tidy_text)
            , fecha = lubridate::ymd(fecha_fallecimiento)
        ) |>
        dplyr::mutate(clasificacion_def = stringr::str_replace_all(clasificacion_def, "[^[:alnum:]]", "_")) |>
        dplyr::select(!dplyr::contains("fecha_")) |>
        dplyr::relocate(fecha) |>
        dplyr::arrange(fecha) |>
        dplyr::count(fecha, ubigeo, departamento, provincia, distrito, sexo, clasificacion_def, name = 'fallecidos') |>
        tidyr::pivot_wider(names_from = clasificacion_def, values_from = fallecidos)

    # iconv(astr, from = 'UTF-8', to = 'ASCII//TRANSLIT')
    full_casos <-
        dplyr::full_join(casos1, fall1, ) |>
        dplyr::mutate(
            dplyr::across(pr:ag, ~replace_na(., 0))
            , dplyr::across(dplyr::contains("criterio"), tidyr::replace_na, 0)
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
            total_casos = sum(pcr:ag)
            , total_fallecidos = sum(criterio_cla_nico:criterio_serola_gico)
            # , total_fallecidos = sum(contains("criterio"))
        ) |>
        dplyr::relocate(total_casos, .after = ag) |>
        dplyr::ungroup() |>
        tidyr::replace_na(list(fallecidos = 0, clasificacion_def = "_")) |>
        dplyr::arrange(desc(fecha))

    message("Write clean data \n")

    full_casos |>
        utils::write.csv('covid-data/output/casos-fallecidos.csv', row.names = F)

    Sys.sleep(sleep)

    pracma::toc()
    message("Data in 'covid-data/output/casos-fallecidos.csv \n")
    fs::dir_tree("covid-data")

    if(r_restart){
        .rs.restartR()
    }
    if(load_data){
        datos_cl <- here::here('covid-data/output/casos-fallecidos.csv')
        return(readr::read_csv(datos_cl))
    } else utils::head(full_casos, 2)

}


