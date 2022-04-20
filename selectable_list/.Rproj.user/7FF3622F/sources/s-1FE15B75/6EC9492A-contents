shinyServer(function(input, output) {
  selected_area <- reactiveVal()

  # Return search list
  returned_list <- eventReactive(input$search_button, {
    regex_pattern <- paste0("(?i)", input$search_term)
    geography_list_dt[str_detect(name, regex_pattern), ]
  })

  # Table with search list
  output$search_results_table <- renderTable({
    returned_list()
  })

  # Update selected_area() based on selected element in the table
  observeEvent(input$search_results_table_selected, {
    selected_row <- geography_list_dt[input$search_results_table_selected, ]
    selected_area(selected_row$code)
  })

  # Update selected_area() based on selected element on map
  observeEvent(input$map_shape_click, {
    print(input$map_shape_click$id)

    selected_area(input$map_shape_click$id)
  })

  # Text to check selection
  output$selected_text <- renderPrint({
    selected_area()
  })

  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 5, maxZoom = 15, attributionControl = F)) %>%
      setView(lat = 54.00366, lng = -2.547855, zoom = 6) %>% # centre map on Whitendale Hanging Stones, the centre of GB: https://en.wikipedia.org/wiki/Centre_points_of_the_United_Kingdom
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        data = msoas_sf,
        group = "msoas",
        layerId = ~code,
        label = ~name,
        weight = 0.7,
        opacity = 0.8,
        color = "black",
        dashArray = "0.1",
        fillOpacity = 0.3,
        highlight = highlightOptions(
          weight = 4,
          #   color = "#666",
          dashArray = "",
          #  fillOpacity = 0.7,
          bringToFront = TRUE
        )
      ) |>
      addPolygons(
        data = lads_sf,
        group = "lads",
        layerId = ~code,
        label = ~name,
        weight = 0.7,
        opacity = 0.8,
        color = "black",
        dashArray = "0.1",
        fillOpacity = 0.3,
        highlight = highlightOptions(
          weight = 4,
          #    color = "#666",
          dashArray = "",
          #    fillOpacity = 0.7,
          bringToFront = TRUE
        )
      ) |>
      addPolygons(
        data = counties_sf,
        group = "counties",
        layerId = ~code,
        label = ~name,
        weight = 0.7,
        opacity = 0.8,
        color = "black",
        dashArray = "0.1",
        fillOpacity = 0.3,
        highlight = highlightOptions(
          weight = 4,
          #    color = "#666",
          dashArray = "",
          #    fillOpacity = 0.7,
          bringToFront = TRUE
        )
      ) |>
      addPolygons(
        data = counties_sf,
        group = ~name,
        layerId = ~code,
        label = ~name,
        weight = 0.7,
        fill = "red",
        fillOpacity = 0.5
      ) |>
      # Set the detail group to only appear when zoomed in: https://rdrr.io/cran/leaflet/man/groupOptions.html
      groupOptions("counties", zoomLevels = 6:7) |>
      groupOptions("lads", zoomLevels = 8:9) |>
      groupOptions("msoas", zoomLevels = 10:20) |>
      hideGroup(group = counties_sf$name) |>
      addLayersControl(
        overlayGroups = c("counties", "lads", "msoas"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })

  map_proxy <- leafletProxy("map")
})
