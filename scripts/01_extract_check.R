library(tidyverse)

# Extract: read raw CSV file
spotify_raw <- read_csv("data/raw/dataset.csv")

# Check if dataset was loaded
print("Dataset loaded successfully!")

# Show number of rows and columns
print(dim(spotify_raw))

# Show column names
print(names(spotify_raw))

# Show first 5 rows
print(head(spotify_raw, 5))

# Show missing values by column
missing_values <- colSums(is.na(spotify_raw))
print(missing_values)