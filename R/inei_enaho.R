
#' inei_enaho
#'
#' @param .mod Surveys (module) to download from the National Household Survey - Peru
#' @param .year Years of surveyss to download
#' @param .tp File extension `c("stata", "spss", "csv")` for years greater than 2019 csv is available
#' @param .trash Not relevant files
#'
#' @return A "solo-data" forder with the database sorted
#' @export
#'
#' @examples
#' library(PeruData)
#' years <- c("2010", "2019")
#' mod <- c("01", "03", "05", "85")
#' # inei_enaho(mod, years)
inei_enaho <- function(
    .mod, .year, .tp = 'stata', .trash = c("tabla", "otro", "dic")
    ){

    if(.tp == 'spss') {
        .ext <- '.sav'
        } else if (.tp == 'stata') {
            .ext <- '.dta'
            } else .ext = '.csv'
    .tp <- stringr::str_to_upper(.tp)
    .trash <- glue::glue_collapse(.trash, sep = "|")
    .mod_len = length(.mod)
    .year_len = length(.year)
    year_cod <- inei_db[['enaho']] %>% .[['anio']]
    year_cod <- year_cod[.year]
    name_year <- names(year_cod)

    enaho <- "enaho"

    dir_files('enaho', .mod, .mod_len)

    all_directories <-
        tibble::tibble(
            year = rep(year_cod, .mod_len), mod = rep(.mod, each = .year_len), name_year = rep(name_year, .mod_len)
        ) |>
        dplyr::mutate(
            to_link = glue::glue_col('http://iinei.inei.gob.pe/iinei/srienaho/descarga/{.tp}/{year}-Modulo{mod}.zip')
            , to_down = here::here(enaho, "inei_down", glue::glue_col("modulo {mod}/{name_year}.zip"))
            , to_unzip = here::here(enaho, 'inei_unzip', glue::glue_col("modulo {mod}"))
        ) |>
        dplyr::arrange(mod)


    to_link <- dplyr::pull(all_directories, to_link)
    to_down <- dplyr::pull(all_directories, to_down)
    to_unzip <- dplyr::pull(all_directories, to_unzip)

    ## download and unzip
    print("Downloading ...")
    purrr::walk2(.x = to_link, .y = to_down, ~try(download.file(.x, .y, quiet = T)))
    print("Unzip files ...")
    purrr::walk2(to_down, to_unzip, ~unzip(.x, exdir = .y))

    data_files <-
        tibble::tibble(
            full_path = dir(here::here(enaho, 'inei_unzip'), recursive = T, full.names = T, pattern = .ext)
            , name_path = dir(here::here(enaho, 'inei_unzip'), recursive = T, full.names = F, pattern = .ext)
        ) |>
        dplyr::filter(!stringr::str_detect(name_path, .trash)) |>
        dplyr::mutate(
            year = stringr::str_sub(
                name_path
                , stringr::str_locate_all(name_path, "-")[[1]][2] + 1
                #- 1
                , stringr::str_locate_all(name_path, "-")[[1]][3]
                ) |>
                stringr::str_remove_all("-") |>
                readr::parse_number()
            , mod = stringr::str_sub(name_path, 1, 10)
            , .enaho = enaho
            , ext = .ext
            , new_name = here::here(enaho, paste0("solo-data/", mod, .enaho, "_", year, .ext))
        ) |>
        dplyr::relocate(full_path, .after = year)
    move_file <- dplyr::pull(data_files, full_path)
    move_to <- dplyr::pull(data_files, new_name)
    print('Moving relevant files to "solo-data"')
    purrr::walk2(move_file, move_to, fs::file_move)
    print("-- End --")
    message("You can see the files via `fs::dir_tree('enaho')`")
}


#fs::dir_delete(c('inei_down', 'inei_unzip', 'solo-data', 'transform_data'))


#' enaho_clean
#'
#' @param .enaho_data ENAHO database
#'
#' @return Standard data cleaning
#' @export
#'
#' @examples
#' #enaho_2018 <- haven::read_dta("enaho/modulo 01/enaho_2018.dta")
#' #enaho_2018 |>
#' #    enaho_clean()
enaho_clean <- function(.enaho_data){
    .enaho_data |>
        janitor::clean_names() |>
        dplyr::mutate(
            ubigeo = ifelse(stringr::str_length(ubigeo) == 5, paste0("0", ubigeo), ubigeo)
        ) |>
        dplyr::left_join(ubigeo_peru) |>
        plyr::rename(
            replace = enaho_rename
            , warn_missing = F
        ) |>
        dplyr::rename_with(tidy_text) |>
        dplyr::mutate(
            dplyr::across(dplyr::contains("p20"), as.numeric)
            , dplyr::across(tidyselect:::where(is.character), tidy_text)
            , dplyr::across(tidyselect:::where(is.numeric), as.character)
            ) |>
        dplyr::relocate(tidyselect::any_of(c("depa", "prob", "dist"), .after = 'ubigeo'))
}


