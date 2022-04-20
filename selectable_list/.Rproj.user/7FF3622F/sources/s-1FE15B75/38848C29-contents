library(shiny)
library(stringr)
library(sf)
library(leaflet)
library(data.table)
library(shinyjqui)
library(shinycssloaders)

geography_list <- readRDS("../clean_data/geography_list.rds")
geography_list_sf <- readRDS("../clean_data/geography_list_sf.rds")

# Create ordered datatable for quicker searching
geography_list_dt <- geography_list |>
  data.table() |> 
  setkey(name)

# geography_list_sf_dt <- geography_list_sf |>
#   data.table() 

msoas_sf <-  geography_list_sf |>
  dplyr::filter(type == "MSOA")

lads_sf <-  geography_list_sf |>
  dplyr::filter(type == "Local Authority")

counties_sf <-  geography_list_sf |>
  dplyr::filter(type == "County")
