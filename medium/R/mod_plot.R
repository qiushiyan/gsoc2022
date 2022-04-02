#' plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom RColorBrewer brewer.pal.info brewer.pal
#' @import dygraphs
mod_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(12,
             includeMarkdown(app_sys("app/markdown/data.md")))
    ),
    sidebarLayout(
      sidebarPanel(
        selectInput(ns("palette"), "color palette", choices = rownames(brewer.pal.info)),
        textInput(ns("title"), "plot title", value = "Deaths from Lung Disease (UK)"),
        tags$div(
          tags$div(
            numericInput(ns("from"), "from", 1974, min = 1974, max = 1979),
            numericInput(ns("to"), "to", 1979, min = 1974, max = 1979),
          )
        ),
        br(),
        helpText("Click and drag to zoom in (double click to zoom back out).")
      ),
      mainPanel(
        dygraphOutput(ns("plot"))
      )
    )
  )
}

#' plot Server Functions
#'
#' @noRd
mod_plot_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    lungDeaths <- cbind(ldeaths, mdeaths, fdeaths)


    output$plot <- renderDygraph({
      p <-  dygraph(lungDeaths, input$title) |>
        dyOptions(colors = RColorBrewer::brewer.pal(3, input$palette))
      if (input$from >= input$to) {
        showNotification("Start date should be no later than the end, showing complete data.")
        updateNumericInput(session, "from", value = 1974)
        updateNumericInput(session, "to", value = 1979)
        p
      } else {
        dates <- to_date(c(input$from, input$to))
          dyRangeSelector(p, dateWindow = dates)
      }
    })
  })
}

## To be copied in the UI
# mod_plot_ui("plot_1")

## To be copied in the server
# mod_plot_server("plot_1")
