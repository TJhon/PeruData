## code to prepare `dev` dataset goes here

library(usethis)


library(devtools)

devtools::load_all()

devtools::check()

# usethis::use_data(dev, overwrite = TRUE)

# devtools::check()

devtools::build()
