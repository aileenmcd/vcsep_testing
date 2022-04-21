shinyUI(fluidPage(
  fluidRow(
    textInput("search_term",
      "Search for an area",
      value = "",
    ),
    actionButton(
      "search_button",
      "Search"
    )
  ),
  fluidRow(
    selectableTableOutput("search_results_table",
      selection_mode = c("row")
    )
  ),
  fluidRow(
    leafletOutput("map")  |>
      withSpinner()
  ),
  fluidRow(
    tableOutput("selected_areas_table")
  ),
))
