library(tidyverse)
library(data.table)


data <- read.csv("./Bionomia Stats/VAFunkCSV.csv", header = TRUE)

# Pie chart of countries where specimens collected
no_empty_country <- data.frame(data)
no_empty_country <- no_empty_country[!(no_empty_country$action == "identified"), ]
no_empty_country <- no_empty_country[!(no_empty_country$countryCode == ""), ]
freq_table <- table(no_empty_country$countryCode)
freq_table <- freq_table[order(freq_table)]

country_mapping <- c("MX" = "Mexico",
                     "AU" = "Australia",
                     "US" = "United States",
                     "CR" = "Costa Rica",
                     "VE" = "Venezuela",
                     "PE" = "Peru",
                     "MG" = "Madagascar",
                     "ZA" = "South Africa",
                     "BR" = "Brazil",
                     "EC" = "Ecuador",
                     "AR" = "Argentina",
                     "BO" = "Boliva",
                     "GT" = "Guatemala",
                     "CL" = "Chile",
                     "CO" = "Colombia",
                     "CN" = "China",
                     "GY" = "Guyana")

# Replace country codes with country names in the frequency table
freq_table_names <- freq_table
names(freq_table_names) <- country_mapping[names(freq_table_names)]

# Group categories with a frequency of 5 or lower into "Other" category
threshold <- 175
low_freq <- names(freq_table_names[freq_table_names <= threshold])

# Replace low-frequency categories with "Other" in the frequency table
freq_table_grouped <- freq_table_names
freq_table_grouped[low_freq] <- "Other"

# Calculate the sum of frequencies for the "Other" category
other_freq <- sum(freq_table_names[freq_table_names <= threshold])

# Subset the frequency table to exclude low-frequency categories
freq_table_excl <- freq_table_names[!(names(freq_table_names) %in% low_freq)]

# Add the "Other" category with the calculated frequency
freq_table_grouped <- c(freq_table_excl, Other = other_freq)

# Set the graphical parameters to move the graph to the left and make the legend taller
par(mar = c(1, 0, 5, 0))

# Generate pie chart with grouped categories
pie(freq_table_grouped, main = "Countries Where Specimens Were Collected by Vicki Funk", radius = 1, col = rainbow(length(freq_table_grouped)))

# Adjust the position of the legend
legend("topright", legend = names(freq_table_grouped), cex = 0.8, fill = rainbow(length(freq_table_grouped)), x.intersp = 0.5, y.intersp = .8, inset = c(-.12, 0.15))
