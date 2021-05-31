#################################################################################################################################
#
#   GeoSpace X Analytics.Gov Demo Contents
#
#   1. Installing and importing required libraries
#   2. Calling Onemap's tile service API using the leaflet package
#   3. Calling Onemap's tile service API using the leaflet package (Web Map Tile Service)
#   4. EPSG coordinate conversion
#   5. Reverse geocode
#   6. Search
#
#
#################################################################################################################################



#################################################################################################################################
#
#   1. Installing and importing the required libraries from the internet
#
#     1. leaflet -> Required to display the map widget
#     2. rgdal -> Required to read GeoJson file to plot custom polygons from GeoJson Files
#     3. sp -> Required to instantiate and map custom polygons
#     4. httr -> make HTTP calls
#     5. jsonlite -> parse json requests
#
#################################################################################################################################


# Install Packages
install.packages("leaflet")
install.packages("rmarkdown")
install.packages("mapview")
install.packages("httr")
install.packages("jsonlite")

# Import Packages
library(leaflet)
library(mapview)
library(webshot)
library(htmlwidgets)
library(httr)
library(jsonlite)


#################################################################################################################################
#
#   2. Calling Onemap's tile service API using the leaflet package (openlayers)
#
#     1. View the available map options at https://www.onemap.gov.sg/docs/maps/ You can choose between:
#        -	https://maps-a.onemap.sg/v3/Default/z/x/y.png
#        -  https://maps-b.onemap.sg/v3/Default/z/x/y.png
#        -  https://maps-c.onemap.sg/v3/Default/z/x/y.png
#     2. Choose the tiled map service you want to use. In this case, https://maps-a.onemap.sg/v3/Default/${z}/${x}/${y}.png
#     3. Instantiate a leaflet widget and add on the tiled map service using the addTiles function
#
#################################################################################################################################

leaflet() %>% setView(103.80,1.36,12) %>% addTiles(
  urlTemplate = "https://maps-c.onemap.sg/v3/Default/{z}/{x}/{y}.png"
  )

#################################################################################################################################
#
#   3. Calling Onemap's tile service API using the leaflet package (Web Map Tile Service)
#
#     1. View the available map options at https://www.onemap.gov.sg/docs/maps/
#     2. Investigate the Get Capabilities XML file at http://mapservices.onemap.sg/mapproxy/wmts/1.0.0/WMTSCapabilities.xml
#     3. Choose and form the URL of the WMTS you want to use using the template found in the xml file ie.
#        - https://mapservices.onemap.sg/mapproxy/wmts/singapore_landlot_wmts/EPSG3857/{z}/{x}/{y}.png
#        - https://mapservices.onemap.sg/mapproxy/wmts/Night/EPSG3857/{z}/{x}/{y}.png
#     4. Instantiate a leaflet widget and add on the tiled map service using the addTiles function
#
#################################################################################################################################

#leaflet() %>% setView(103.80,1.36,12) %>% addWMSTiles(
#  "https://mapservices.onemap.sg/mapproxy/wmts/",
#  layers = "Night",
#  options = WMSTileOptions( format = "image/png", transparent = TRUE, version= "1.0.0")
#)

leaflet() %>% addTiles(
  urlTemplate = "https://mapservices.onemap.sg/mapproxy/wmts/Night/EPSG3857/{z}/{x}/{y}.png"
) %>% setView(-60,60.36,4)

#################################################################################################################################
#
#   4. Calling Onemap's coordinate conversion rest api
#
#     1. Form the url request (https://www.onemap.gov.sg/docs/#4326-wgs84-to-3857) and use R Httr package to send a get request
#     2. Receive the request in json format
#     3. Assign x,y variables to a R array
#     4. use the coordinates in your map
# 
#################################################################################################################################

response <- httr::GET('https://developers.onemap.sg/commonapi/convert/3414to4326?X=28983.788791079794&Y=33554.5098132845',
                      accept_json()
                      )

jsonInfo <- content(response,type="application/json")

lat <- jsonInfo$latitude[1]
long <- jsonInfo$longitude[1]

CoordinatesIn4326 <- c(lat,long)

leaflet() %>% setView(103.80,1.36,12) %>% addTiles(
  urlTemplate = "https://maps-c.onemap.sg/v3/Default/{z}/{x}/{y}.png"
) %>%
  addMarkers(long,lat)

#################################################################################################################################
#
#   5. Calling Onemap's search rest api (Find tampines mall)
#
#     1. Form the url request (https://www.onemap.gov.sg/docs/#4326-wgs84-to-3857) and use R Httr package to send a get request
#     2. Receive the request in json format
#     3. Understand the json format to get the info you want
#     4. Assign lat,long variables to a R array
#     5. Convert string to numeric
#     6. use the coordinates in your map
# 
#################################################################################################################################

response <- httr::GET('https://developers.onemap.sg/commonapi/search?searchVal=tampines%20mall&returnGeom=Y&getAddrDetails=Y&pageNum=1',
                      accept_json()
)

jsonInfo <- content(response,type="application/json")

jsonInfo

lat <- as.numeric(jsonInfo$results[[1]]$LATITUDE)
long <- as.numeric(jsonInfo$results[[1]]$LONGITUDE)

CoordinatesIn4326 <- c(lat,long)


leaflet() %>% setView(103.80,1.36,12) %>% addTiles(
  urlTemplate = "https://maps-c.onemap.sg/v3/Default/{z}/{x}/{y}.png"
) %>%
  addMarkers(long,lat)