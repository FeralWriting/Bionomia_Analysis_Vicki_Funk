library(ggplot2)
library(ggpubr)
library(dplyr)

# Read the data from CSV file
data <- read.csv("./Bionomia Stats/VAFunkCSV.csv")

# Filter the data for recorded and identified collections
recorded <- data %>%
  filter(grepl("recorded", action))

identified <- data %>%
  filter(grepl("recorded,identified", action))

# Count the number of recorded and identified collections by year
recorded_counts <- recorded %>%
  group_by(year) %>%
  summarize(count = n())

identified_counts <- identified %>%
  group_by(year) %>%
  summarize(count = n())

# Merge the recorded and identified counts
counts <- merge(recorded_counts, identified_counts, by = "year", all = TRUE)

# Remove years before 1955
counts <- counts[counts$year >= 1955 & counts$year <= 2030, ]

counts[is.na(counts)] <- 0

# Plot the bar plot
ggplot(counts) +
  geom_bar(aes(x = as.factor(year), y = count.x, fill = "Recorded"), stat = "identity", alpha = 1) +
  geom_bar(aes(x = as.factor(year), y = count.y, fill = "Recorded and Identified"), stat = "identity", alpha = 1) +
  labs(x = "Year", y = "Count") +
  scale_fill_manual(values = c("skyblue", "orange"), labels = c("Collected", "Collected and Identified")) +
  theme_pubr() +
  scale_x_discrete(breaks = seq(min(counts$year), max(counts$year), by = 10), labels = seq(min(counts$year), max(counts$year), by = 10)) +
  theme(legend.position = c(1, 1), legend.justification = c(1, 1), legend.box = "vertical", 
        legend.box.just = "right", 
        legend.box.margin = margin(10, 10, 10, 10), legend.background = element_rect(color = "black", fill = "transparent"),
        legend.key = element_rect(color = "black")) +
  guides(fill = guide_legend(title = "Legend", label.position = "right", label.theme = element_text(size = 12))) +
  ggtitle("Number of Collected and Identified Specimens by Year by Vicki Funk")

