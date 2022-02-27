#' Table from bcrp data
#' @author Jhon Flores Rojas
#' @description Create a table from BCRP data
#'
#' @param .html_locate Html file
#' @seealso
#' * PeruData::bcrp_get()
#'
#' @return Table from BCRP tables
#' @export
#'
bcrp_table <- function(.html_locate) {
    .html_locate |>
        rvest::html_element(css = '.series') |>
        rvest::html_table() |>
        janitor::clean_names()
}


#' Get data BCRP by link
#'
#' @author Jhon Flores Rojas
#' @description Create a tibble from BCRP data
#' @details Read table from links of BCRP data, and convert into tibbles.
#' @param .link Url from https://estadisticas.bcrp.gob.pe/estadisticas/series/
#'
#' @return A list with data from BCRP links
#' @export
#'
#' @examples
#' library(rvest)
#' library(purrr)
#' library(PeruData)
#'
#' down_load <- c(
#'  "https://estadisticas.bcrp.gob.pe/estadisticas/series/mensuales/resultados/PN01270PM/html"
#' , "https://estadisticas.bcrp.gob.pe/estadisticas/series/mensuales/resultados/PN01308PM/html"
#' )
#' dfs <- bcrp_get(down_load)
#' dfs
bcrp_get <- function(.link = NULL){#.period, .cod, ){
    # .p <- tidy_text(.period)
    # .pp <- c()
    # if(.p == 'a') .pp <- 'anuales' else if (.p == 't')
    #     .pp <- 'trimestrales' else if(.p == 'm')
    #         .pp <- 'mensuales' else if(.p == 'd')
    #             .pp <- 'diarias' else "Not support"
    # glue("https://estadisticas.bcrp.gob.pe/estadisticas/series/{.pp}")
    message("Getting data ...")
    bcrp_data <- purrr::map(.link , rvest::read_html)
    bcrp_data |> purrr::map(bcrp_table)
}
