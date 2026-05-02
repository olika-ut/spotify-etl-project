library(tidyverse)

# Step 1: Extract raw data again
spotify_raw <- read_csv("data/raw/dataset.csv", show_col_types = FALSE)

# Step 2: Transform / clean the dataset
spotify_clean <- spotify_raw %>%
  # Remove unnecessary index column
  select(-...1) %>%
  
  # Remove rows with missing important values
  drop_na(track_id, artists, album_name, track_name, track_genre) %>%
  
  # Remove duplicate tracks based on track_id
  distinct(track_id, .keep_all = TRUE) %>%
  
  # Create new useful columns
  mutate(
    duration_min = round(duration_ms / 60000, 2),
    track_genre = str_to_lower(str_trim(track_genre)),
    popularity_category = case_when(
      popularity < 34 ~ "Low",
      popularity < 67 ~ "Medium",
      popularity >= 67 ~ "High"
    )
  )

# Step 3: Create a genre-level summary table
genre_summary <- spotify_clean %>%
  group_by(track_genre) %>%
  summarise(
    track_count = n(),
    avg_popularity = round(mean(popularity), 2),
    avg_danceability = round(mean(danceability), 2),
    avg_energy = round(mean(energy), 2),
    avg_valence = round(mean(valence), 2),
    avg_tempo = round(mean(tempo), 2),
    avg_duration_min = round(mean(duration_min), 2),
    .groups = "drop"
  )

# Step 4: Save transformed datasets
write_csv(spotify_clean, "data/processed/spotify_tracks_cleaned.csv")
write_csv(genre_summary, "data/processed/spotify_genre_summary.csv")

# Step 5: Print results
print("Transformation completed successfully!")

print("Cleaned dataset dimensions:")
print(dim(spotify_clean))

print("Genre summary dimensions:")
print(dim(genre_summary))

print("First 5 rows of cleaned dataset:")
print(head(spotify_clean, 5))

print("First 5 rows of genre summary:")
print(head(genre_summary, 5))