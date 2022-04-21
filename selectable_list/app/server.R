shinyServer(function(input, output) {
  selected_areas <- reactiveValues(groups = vector())

  # Return search list
  returned_list <- eventReactive(input$search_button, {
    regex_pattern <- paste0("(?i)", input$search_term)
    geography_list_dt[str_detect(name, regex_pattern), ]
  })

  # Table with search list
  output$search_results_table <- renderTable({
    validate(need(nrow(returned_list()) < 30, "Please use more specific search term or select from map"))
    returned_list()
  })

  # Update selected_area() based on selected element in the table
  observeEvent(input$search_results_table_selected, {
    selected_row <- returned_list()[input$search_results_table_selected, ]

    # if not already selected then add to selected list, otherwise remove from list
    # i.e. clicked twice to remove
    # currently doesn't work with multiselect (when hold down control and select many) (TO DO)
    if (!selected_row$name %in% selected_areas$groups) {
      selected_areas$groups <- c(selected_areas$groups, selected_row$name)
      proxy |> showGroup(group = selected_row$name)
    } else {
      selected_areas$groups <- setdiff(selected_areas$groups, selected_row$name)
      proxy |> hideGroup(group = selected_row$name)
    }
  })

  # Update selected_area() based on selected element on map
  observeEvent(input$map_shape_click, {

    #   if(!input$map_shape_click$group %in% c("msoas", "lads", "counties")) {browser()}

    if (input$map_shape_click$group %in% c("msoas", "lads", "counties")) {
      selected_areas$groups <- c(selected_areas$groups, input$map_shape_click$id)
      proxy |> showGroup(group = input$map_shape_click$id)
    } else {
      selected_areas$groups <- setdiff(selected_areas$groups, input$map_shape_click$group)
      proxy |> hideGroup(group = input$map_shape_click$group)
    }
  })


  # Table with selected elements
  output$selected_areas_table <- renderTable({
    selected_areas$groups
  })

  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 5, maxZoom = 15, attributionControl = F)) |>
      setView(lat = 54.00366, lng = -2.547855, zoom = 6) |> 
      addProviderTiles(providers$CartoDB.Positron) |>
      addPolygons(
        data = msoas_sf,
        group = "msoas",
        layerId = ~name,
        label = ~name,
        weight = 0.7,
        color = "black",
        dashArray = "0.1",
        fillOpacity = 0.1,
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
        layerId = ~name,
        label = ~name,
        weight = 0.7,
        color = "black",
        dashArray = "0.1",
        fillOpacity = 0.1,
        highlight = highlightOptions(
          weight = 4,
          dashArray = "",
          bringToFront = TRUE
        )
      ) |>
      addPolygons(
        data = counties_sf,
        group = "counties",
        layerId = ~name,
        label = ~name,
        weight = 0.7,
        color = "black",
        dashArray = "0.1",
        fillOpacity = 0.1,
        highlight = highlightOptions(
          weight = 4,
          dashArray = "",
          bringToFront = TRUE
        )
      ) |>
      addPolygons(
        data = msoas_sf,
        fillColor = "red",
        fillOpacity = 1,
        weight = 1,
        color = "black",
        stroke = TRUE,
        layerId = ~code,
        group = ~name
      ) |>
      addPolygons(
        data = lads_sf,
        fillColor = "red",
        fillOpacity = 1,
        weight = 1,
        color = "black",
        stroke = TRUE,
        layerId = ~code,
        group = ~name
      ) |>
      addPolygons(
        data = counties_sf,
        fillColor = "red",
        fillOpacity = 1,
        weight = 1,
        color = "black",
        stroke = TRUE,
        layerId = ~code,
        group = ~name
      ) |>
      # Set the detail group to only appear when zoomed in: https://rdrr.io/cran/leaflet/man/groupOptions.html
      groupOptions("counties", zoomLevels = 6:7) |>
      groupOptions("lads", zoomLevels = 8:9) |>
      groupOptions("msoas", zoomLevels = 10:20) |>
      
      hideGroup(group = c(msoas_sf$name, lads_sf$name, counties_sf$name)) |>
      
      addLayersControl(
        baseGroups = c("counties", "lads", "msoas"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })

  proxy <- leafletProxy("map")
  
})
