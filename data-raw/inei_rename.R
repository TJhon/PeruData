## code to prepare `inei_rename` dataset goes here

enaho_rename <- c(
    'a_no' = "anio", 'ubi' = "ubigeo", 's1hog' = "hogar", 's1viv' = 'vivienda', 's1con' = "conglome", "poblacion" = 'pob'
    , "a_o" = 'anio'
    )


usethis::use_data(enaho_rename, overwrite = TRUE)
