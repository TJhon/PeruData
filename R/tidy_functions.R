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
#' clean_sf(map_peru_dep)
clean_sf <- function(.sf, .simplify = T, keep = .05){
    if(.simplify) .sf <- rmapshaper::ms_simplify(.sf, keep = .05)
    sf <-
        .sf |>
        # rmapshaper::ms_simplify() |>
        rename_with(tidy_text) |>
        select(!contains('id')) |>
        select(!any_of(c("codccpp", "area", "fuente", "capital"))) |>
        plyr::rename(rename_geo, warn_missing = F) |>
        mutate(across(where(is.character), tidy_text))
    return(sf)
}


#' get_centroid
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
    sf_c <- st_centroid(.sf)
    .sf |>
        bind_cols(
            x_center = st_coordinates(sf_c)[, 1]
            ,y_center = st_coordinates(sf_c)[, 2]
        ) |>
        relocate(x_center, y_center, .before = geometry)
}
