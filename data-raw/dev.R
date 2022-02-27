## code to prepare `dev` dataset goes here

library(usethis)


library(devtools)
pracma::tic()
devtools::load_all()

devtools::check()

devtools::build()
pracma::toc()
# usethis::use_data(dev, overwrite = TRUE)

# devtools::check()

