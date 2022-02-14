

#' Download data from INEI survey ENDES
#'
#' @param .mod
#' @param .year
#' @param .tp
#'
#' @return
#' @export
#'
#' @examples
inei_endes <- function(
    .mod, .year, .tp = 'spss'#, .trash = c("tabla", "otro", "dic")
){
    if(.tp == 'spss') {
        .ext <- '.sav'
    } else .ext = '.csv'

    .tp <- stringr::str_to_upper(.tp)
    # .trash <- glue::glue_collapse(.trash, sep = "|")
    .mod_len = length(.mod)
    .year_len = length(.year)
    year_cod <- inei_db[['endes']] %>% .[['anio']]
    year_cod <- year_cod[.year]
    name_year <- names(year_cod)

    endes <- "endes"

    dir_files('endes', .mod, .mod_len)

    all_directories <-
        tibble::tibble(
            year = rep(year_cod, .mod_len), mod = rep(.mod, each = .year_len), name_year = rep(name_year, .mod_len)
        ) |>
        dplyr::mutate(
            to_link = glue::glue_col('http://iinei.inei.gob.pe/iinei/srienaho/descarga/{.tp}/{year}-Modulo{mod}.zip')
            , to_down = here::here(endes, "inei_down", glue::glue_col("modulo {mod}/{name_year}.zip"))
        ) |>
        dplyr::arrange(mod)

    to_link <- dplyr::pull(all_directories, to_link)
    to_down <- dplyr::pull(all_directories, to_down)

    print("Donwloading")

    purrr::walk2(to_link, to_down, ~try(download.file(.x, .y, quiet = T)))

    print("Unzip ...")

    zip0 <- dir(here::here('endes', 'inei_down'), recursive = T, pattern = '.zip', full.names = T)

    zip1 <- zip0 |>
        stringr::str_remove(".zip") |>
        stringr::str_replace("inei_down", "inei_unzip")
    fs::dir_create(zip1)

    purrr::walk2(zip0, zip1, ~unzip(.x, exdir = .y))

    files_sav <-  dir(here::here("endes", "inei_unzip"), recursive = T, pattern = ".[Ss][Aa][Vv]")
    full_sav <-  dir(here::here("endes", "inei_unzip"), recursive = T, pattern = "[Ss][Aa][Vv]", full.names = T)

    pre_mod <- (files_sav |> stringr::str_locate("/"))[, 1] - 1
    print("Moving data")
    pre_file <-
        files_sav |>
        stringr::str_locate_all("/") |>
        purrr::map_df(tibble::as_tibble, .id = "nn") |>
        dplyr::with_groups(nn, ~dplyr::filter(., start == max(start))) |>
        dplyr::select(!end) |>
        dplyr::rename(pre_file = start) |>
        tibble::add_column(
            pre_mod = pre_mod
            , sav_name = files_sav
            # , full_sav = full_sav
        ) |>
        dplyr::mutate(
            pre_file = pre_file + 1
            , new_name = here::here(
                "endes"
                , "solo-data"
                , paste0(
                    stringr::str_sub(sav_name, 1, pre_mod + 5)
                    , "_"
                    , stringr::str_sub(sav_name, pre_file, -1))
            )
        ) |>
        dplyr::pull(new_name)


    purrr::walk2(full_sav, pre_file, ~fs::file_copy(.x, .y, T))
    message("See the files with `fs::dir_tree('enaho)'")
}
#
# modulos <- c("64", "65")
# anios <- c("2015", "2004", "2019")
# unlink('endes', recursive = T)
#
# inei_endes(modulos, anios)
#
