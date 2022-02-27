#' clean_sf
#'
#' @param .sf A sf object
#' @param .simplify Reduce memory usage
#' @param keep Size to keep
#'
#' @return A clean sf data
#' @export
#'
#' @examples
#' library(PeruData)
#' #clean_sf(map_peru_depa)
clean_sf <- function(.sf, .simplify = T, keep = .05){
    if(.simplify) .sf <- rmapshaper::ms_simplify(.sf, keep = .05)
    sf <-
        .sf |>
        # rmapshaper::ms_simplify() |>
        dplyr::rename_with(tidy_text) |>
        dplyr::select(!dplyr::contains('id')) |>
        dplyr::select(!dplyr::any_of(c("codccpp", "area", "fuente", "capital"))) |>
        plyr::rename(rename_geo, warn_missing = F) |>
        dplyr::mutate(dplyr::across(tidyselect:::where(is.character), tidy_text))
    return(sf)
}


#' Get centroid from a sf object
#'
#' @author Jhon Flores Rojas
#'
#' @details Create and add the coordinates (x, y) of the centroids to the dataframe
#'
#' @description Add columns from a sf object with centroids (x, y).
#'
#' @param .sf A sf object
#'
#' @return X Y columns with centroid
#' @export
#'
#' @examples
#' library(PeruData)
#' #map_peru_dist |>
#' #  filter(depa == "huanuco") |>
#' #   get_centroid()
get_centroid <- function(.sf){
    sf_c <- sf::st_centroid(.sf)
    .sf |>
        dplyr::bind_cols(
            x_center = sf::st_coordinates(sf_c)[, 1]
            ,y_center = sf::st_coordinates(sf_c)[, 2]
        ) |>
        dplyr::relocate(x_center, y_center, .before = geometry)
}

#' Tidy format for text
#'
#' @author Jhon Flores Rojas
#'
#' @description Tidy a text of special characters.
#'
#' @details Convert text into a tidy format
#'
#' @param .x Vector of characters
#'
#' @return Clean vector of characters
#' @export
#'
#' @examples
#' library(stringr)
#' #library('tidyverse')
#' library(PeruData)
#'
#' dirty <- c("    a ", "universo  ", "íóñ")
#' tidy_text(dirty)
tidy_text <- function(.x){
    .x |>
        stringr::str_to_lower() |>
        stringr::str_trim() |>
        stringi::stri_trans_general("Latin-ASCII")
}
