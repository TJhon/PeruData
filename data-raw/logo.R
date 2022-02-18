## code to prepare `logo` dataset goes here

library(sf)
library(tidyverse)

img_dt <- png::readPNG("figs/dt.png")
img_dt1 <- png::readPNG("figs/dt1.png")



peru <- PeruData::map_peru_peru

x_min = -81.32931
y_min = -18.3518
x_max = -68.6534
y_max = -0.03747



# izq <- st_crop(peru, xmin = x_min, xmax = x_min + x_ran/4, ymin = y_min, ymax = y_max)
izq <- st_crop(peru, xmin = x_min, xmax = -76.8, ymin = y_min, ymax = y_max)
# centro <- st_crop(peru, xmin = x_min + x_ran / 4, xmax = x_min + x_ran/2, ymin = y_min, ymax = y_max)
centro <- st_crop(peru, xmin = -76.8, xmax = -72.8, ymin = y_min, ymax = y_max)
derecha <- st_crop(peru, xmin = -72.8, xmax = x_max, ymin = y_min, ymax = y_max)

# usethis::use_data(logo, overwrite = TRUE)

library(grid)
library(patchwork)

size_bd <- .4

peru_logo <-
    ggplot() +
    geom_sf(data = izq, fill = 'red', color = 'white', size = .1) +
    geom_sf(data = centro, fill = 'white', color = 'white', size = .1) +
    geom_sf(data = derecha, fill = 'red', color = 'white', size = .1) +
    theme_void() +
    ggpubr::theme_transparent()
    # theme(
    #     plot.background = element_rect(fill = "black", color = 'transparent')
    # )

peru_logo_wt <-
    ggplot() +
    geom_sf(data = izq, fill = 'red', color = 'white', size = .1) +
    geom_sf(data = centro, fill = 'white', color = 'white', size = .1) +
    geom_sf(data = derecha, fill = 'red', color = 'white', size = .1) +
    geom_sf(data = peru, fill = 'transparent', color = '#3a4459', size = .1) +
    theme_void() +
    # theme_dark()
    ggpubr::theme_transparent()

library(cowplot)

peru_log_1 <-
    ggdraw(peru_logo, xlim = c(0, 1.5)) +
    draw_image(img_dt1, x = .95, y = .051, width = .5) +
    theme_void() +
    theme(
        plot.background = element_rect(fill = 'transparent', color = 'transparent')
    )
peru_log_1
peru_log_wt <-
    ggdraw(peru_logo_wt, xlim = c(0, 1.5)) +
    draw_image(img_dt, x = .95, y = .051, width = .5) +
    theme_void() +
    theme(
        plot.background = element_rect(fill = 'transparent', color = 'transparent')
    )
peru_log_wt

hexSticker::sticker(
    peru_log_1
    , s_x = .93, s_y = .82
    , s_width = 1.8, s_height = 2.9
    # , p_size = 5.5
    , p_size = 16.4
    , p_y = 1.65 #s_x = 0.89
    # , h_fill = "#2574A9"
    , h_fill = "#1c1715"
    , h_color = "#3a4459"
    , p_family = "Aller_Lt"
    # , spotlight = TRUE
    # , l_y = 1
    , package = "PeruData"
    , filename = "figs/PeruData-night.png"
    , url = "github/tjhon/PeruData"
    , u_family = "Aller_Lt"
    , u_color = "white"
     ,u_size = 5.4
    # , white_around_sticker = T
    )


hexSticker::sticker(
    peru_log_wt
    , s_x = .93, s_y = .82
    , s_width = 1.8, s_height = 2.9
    # , p_size = 5.5 #pdf png
    , p_size = 16.4
    , p_y = 1.65 #s_x = 0.89
    # , h_fill = "#2574A9"
    , h_fill = "white"
    , h_color = "#3a4459"
    , p_family = "Aller_Lt"
    , p_color = "#3a4459"
    # , spotlight = TRUE
    # , l_y = 1
    , package = "PeruData"
    , filename = "figs/PeruData-wt.png"
    , url = "github/tjhon/PeruData"
    , u_family = "Aller_Lt"
    , u_color = "black"
    , u_size = 5.4 # png output
    # , white_around_sticker = T
)
# ggsave('figs/perudata.svg', plot = peru_logo, ")

