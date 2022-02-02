#' dir_files
#'
#' @param .data create folders to sort data
#' @param .mod Module or survey
#' @param .mod_len Number of modules or surveys
#'
#' @return Folders created
#' @export
#'
#' @examples
#' #dir_files("enaho", c("01", "02"), 2)
dir_files <- function(.data,.mod, .mod_len){
    dir_files <- c('inei_down', 'inei_unzip', 'solo-data', 'transform_data')
    purrr::map(dir_files, ~here::here(.data, .x)) |>
        purrr::map(~rep(.x, .mod_len)) |>
        purrr::map(~here::here(.x, glue::glue('modulo {.mod}'))) |>
        purrr::walk(~try(fs::dir_create(.x)))
}
