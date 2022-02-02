#' tidy_text
#'
#' @param .x A vector of type character
#'
#' @return Cleaning data from a vector or columns, removing unnecessary spaces or special characters
#' @export
#'
#' @examples
#' dirty <- c("    a ", "universo  ", "íóñ")
#' tidy_text(dirty)
tidy_text <- function(.x) {
    .x |>
        stringr::str_to_lower() |>
        stringr::str_trim() |>
        stringi::stri_trans_general("Latin-ASCII")
}

