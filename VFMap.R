library(leaflet)
library(dplyr)
library(htmlwidgets)

# Load the data
v_funk_data <- read.csv("./Bionomia Stats/VAFunkCSV.csv", header = TRUE)

# Convert "decimalLongitude" and "decimalLatitude" to numeric and filter out invalid rows
data <- v_funk_data %>%
  mutate(decimalLongitude = as.numeric(decimalLongitude),
         decimalLatitude = as.numeric(decimalLatitude)) %>%
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude))
data <- data[(data$decimalLongitude>-180 & data$decimalLongitude<180),]

# Create a custom icon with a smaller size
smaller_icon <- makeIcon(iconUrl = "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png",
                         iconWidth = 15, iconHeight = 25)

# Create the leaflet map
map <- leaflet(data = data) %>%
  addTiles() %>%
  addMarkers(
    ~decimalLongitude, ~decimalLatitude,
    popup = ~paste("Latitude: ", decimalLatitude, "<br>",
                   "Longitude: ", decimalLongitude),
    icon = smaller_icon
  )

# Display the map
map