## code to prepare `ipg` dataset goes here

librarian::shelf(
    tidyverse
    , readxl
    , janitor
    , lubridate
    , cran_repo = 'https://cran.r-project.org'
)

igp_begin <- read_excel("source-data/IGP_datos_sismicos.xlsx") |> clean_names()

igp_scrapped <- read_csv(
    "https://raw.githubusercontent.com/TJhon/summary/main/proyectos/ipg-scraping/data/igp_2022.csv"
    # "https://raw.githubusercontent.com/TJhon/summary/main/proyectos/ipg-scraping/data/igp_2022.csv"
    , show_col_types = F) |> clean_names()

head(igp_scrapped)
igp_scrapped_clean <-
    igp_scrapped |>
    separate(date, c("date", "hour"), sep = "-") |>
    mutate(
        across(
            where(is.character), str_trim
        ),
        m = parse_number(m)
        , date = dmy(date)
        , hour = hms(hour)
    ) |>
    relocate(m, .after = prof) |>
    rename(magn = m, intensi_km = prof) |>
    arrange(desc(date))

colnames(igp_begin) <- names(igp_scrapped_clean)
igp_begin_cl <-
    igp_begin |>
    mutate(
        date = dmy(date)
        , hour = hms(hour)
        , across(where(is.character), as.numeric)
    ) |>
    arrange(desc(date))

igp <-
    bind_rows(igp_scrapped_clean, igp_begin_cl) |>
    mutate(
        alert = case_when(
            magn < 4.5 ~ "Green"
            , magn > 6.0 ~ "Red"
            , T ~ "Yellow"
        )
    )


# igp <-
#     readr::read_csv("https://raw.githubusercontent.com/TJhon/summary/main/proyectos/ipg-scraping/output/igp.csv")

usethis::use_data(igp, overwrite = TRUE)
