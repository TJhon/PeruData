## code to prepare `ipg` dataset goes here

igp <-
    readr::read_csv("https://raw.githubusercontent.com/TJhon/summary/main/proyectos/ipg-scraping/output/igp.csv")

usethis::use_data(igp, overwrite = TRUE)
