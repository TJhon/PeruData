#' Theme for location plot (subplot)
#' @author Jhon Flores Rojas
#' @param cl_borde plot border color
#'
#' @param fill_map plot fill color
#' @param ... adicional elements
#'
#' @export
#'
#' @examples
#' librarian::shell(tidyverse, sf, PeruData)
#' ggplo() +
#' geom_sf(data = map_peru_depa, fill = "white", color = "black") +
#' geom_sf(data = filter(map_peru_depa, depa == "piura", fill = "gray20", color = "gray20") +
#' theme_map_sp()
theme_map_sp <- function(cl_borde = "black", fill_map = "white", ...){
    ggplot2::theme_void() +
        ggplot2::theme(
            plot.background =
                ggplot2::element_rect(
                    color = cl_borde
                    , fill = fill_map
                )
        ) +
        ggplot2::theme(...)

}

#' Theme classic maps
#'
#' @param ... adicional elements
#' @param lt linetype
#' @param cl_line line color
#' @param title_font font title
#' @param title_size size title
#' @param caption_font caption font
#' @param legend_pst lenged position
#'
#' @author Jhon Flores Rojas
#' @export
#'
#' @examples
#' librarian::shell(tidyverse, sf, PeruData)
#' ggplot() +
#' geom_sf(data = map_peru_depa, fill = "gray90", color = "black") +
#' geom_sf(data = filter(map_peru_depa, depa == "piura"), fill = "steelblue") +
#' theme_map_classic()
theme_map_classic <-
    function(
        ..., lt = "dashed", cl_line = "gray80"
        , title_font = "serif", title_size = 14
        , caption_font = "serif", legend_pst = c(.9, .1)
    ){
        ggplot2::theme_bw() +
            ggplot2::theme(
                panel.grid.major = ggplot2::element_line(linetype = lt, color = cl_line)
                , plot.title =  ggplot2::element_text(family = title_font, hjust = .5, size = title_size)
                , plot.subtitle =  ggplot2::element_text(family = title_font, hjust = .5, size = 0.8*title_size)
                , plot.caption =  ggplot2::element_text(family = caption_font)
                , legend.position =  legend_pst
            ) +
            ggplot2::theme(...)
    }


#
