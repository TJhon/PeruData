
#' Table from bcrp
#'
#' @param .html_locate
#'
#' @return
#' @export
#'
#' @examples
bcrp_table <- function(.html_locate) {
    .html_locate |>
        html_element(css = '.series') |>
        html_table() |>
        janitor::clean_names()
}


#' Get data BCRP by link
#'
#' @param .link
#'
#' @return
#' @export
#'
#' @examples
bcrp_get <- function(.link = NULL){#.period, .cod, ){
    # .p <- tidy_text(.period)
    # .pp <- c()
    # if(.p == 'a') .pp <- 'anuales' else if (.p == 't')
    #     .pp <- 'trimestrales' else if(.p == 'm')
    #         .pp <- 'mensuales' else if(.p == 'd')
    #             .pp <- 'diarias' else "Not support"
    # glue("https://estadisticas.bcrp.gob.pe/estadisticas/series/{.pp}")
    print("Getting data ...")
    bcrp_data <- map(.link , read_html)
    bcrp_data |> map(bcrp_table)
}
