## code to prepare `covid` dataset goes here

library(tidyverse)
library(PeruData)


covid_links <- c(
    "casos" = "https://cloud.minsa.gob.pe/s/AC2adyLkHCKjmfm/download"
    , "fallecidos" = "https://cloud.minsa.gob.pe/s/xJ2LQ3QyRW38Pe5/download"
)

covid_casos_fallecidos <- read_csv(
    'source-data/casos-fallecidos.csv'
)


usethis::use_data(covid_links, overwrite = TRUE)
usethis::use_data(covid_casos_fallecidos, overwrite = TRUE)


load(covid_casos_fallecidos)
