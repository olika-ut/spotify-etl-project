library(tidyverse)
library(DBI)
library(RSQLite)
library(ggplot2)

# Spotify-style green palette
spotify_light_green <- "#B3F5C6"
spotify_medium_green <- "#1DB954"
spotify_dark_green <- "#0B6623"

# Step 1: Connect to SQLite database
con <- dbConnect(
  SQLite(),
  "data/database/spotify_tracks.db"
)

# Step 2: Read tables from database
genre_summary <- dbReadTable(con, "spotify_genre_summary")
spotify_clean <- dbReadTable(con, "spotify_tracks_cleaned")

# Step 3: Disconnect from database
dbDisconnect(con)

# ------------------------------------------------------------
# First visualization:
# Top 15 Spotify Genres by Average Popularity
# ------------------------------------------------------------

# Select top 15 genres by average popularity
top_15_genres <- genre_summary %>%
  arrange(desc(avg_popularity)) %>%
  slice_head(n = 15) %>%
  mutate(track_genre = reorder(track_genre, avg_popularity))

# Create green plot
top_15_plot <- ggplot(
  top_15_genres,
  aes(x = track_genre, y = avg_popularity, fill = avg_popularity)
) +
  geom_col(width = 0.8) +
  coord_flip() +
  geom_text(
    aes(label = round(avg_popularity, 1)),
    hjust = -0.15,
    size = 4
  ) +
  scale_fill_gradient(
    low = spotify_light_green,
    high = spotify_dark_green
  ) +
  labs(
    title = "Top 15 Spotify Genres by Average Popularity",
    subtitle = "Average popularity scores based on the cleaned Spotify Tracks Dataset",
    x = "Genre",
    y = "Average Popularity Score",
    caption = "Source: Kaggle Spotify Tracks Dataset | Processed in R and loaded into SQLite"
  ) +
  ylim(0, max(top_15_genres$avg_popularity) + 5) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 20),
    plot.subtitle = element_text(size = 13),
    axis.text.y = element_text(size = 12),
    axis.text.x = element_text(size = 11),
    axis.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

# Show plot
print(top_15_plot)

# Save plot
ggsave(
  filename = "visualizations/top_15_genres_by_popularity_green.png",
  plot = top_15_plot,
  width = 11,
  height = 7,
  dpi = 300
)

print("First visualization saved successfully!")

# ------------------------------------------------------------
# Second visualization:
# Average Energy vs Average Valence by Genre
# Point size and color show average popularity
# ------------------------------------------------------------

energy_valence_plot <- ggplot(
  genre_summary,
  aes(
    x = avg_energy,
    y = avg_valence,
    size = avg_popularity,
    color = avg_popularity
  )
) +
  geom_point(alpha = 0.75) +
  scale_size_continuous(range = c(3, 12)) +
  scale_color_gradient(
    low = spotify_light_green,
    high = spotify_dark_green
  ) +
  labs(
    title = "Spotify Genres by Energy, Valence, and Popularity",
    subtitle = "Each point represents one genre; larger and darker points have higher average popularity",
    x = "Average Energy",
    y = "Average Valence",
    size = "Average Popularity",
    color = "Average Popularity",
    caption = "Source: Kaggle Spotify Tracks Dataset | Processed in R and loaded into SQLite"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 20),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    legend.position = "right",
    panel.grid.minor = element_blank()
  )

# Display second plot
print(energy_valence_plot)

# Save second plot
ggsave(
  filename = "visualizations/energy_valence_popularity_by_genre_green.png",
  plot = energy_valence_plot,
  width = 10,
  height = 7,
  dpi = 300
)

print("Second visualization saved successfully!")

# ------------------------------------------------------------
# Third visualization:
# Average Popularity by Audio Feature Level
# ------------------------------------------------------------

# Create Low / Medium / High groups for selected audio features
feature_levels <- spotify_clean %>%
  mutate(
    danceability_level = ntile(danceability, 3),
    energy_level = ntile(energy, 3),
    valence_level = ntile(valence, 3),
    acousticness_level = ntile(acousticness, 3)
  ) %>%
  mutate(
    danceability_level = case_when(
      danceability_level == 1 ~ "Low",
      danceability_level == 2 ~ "Medium",
      danceability_level == 3 ~ "High"
    ),
    energy_level = case_when(
      energy_level == 1 ~ "Low",
      energy_level == 2 ~ "Medium",
      energy_level == 3 ~ "High"
    ),
    valence_level = case_when(
      valence_level == 1 ~ "Low",
      valence_level == 2 ~ "Medium",
      valence_level == 3 ~ "High"
    ),
    acousticness_level = case_when(
      acousticness_level == 1 ~ "Low",
      acousticness_level == 2 ~ "Medium",
      acousticness_level == 3 ~ "High"
    )
  )

# Reshape data into long format
feature_long <- feature_levels %>%
  select(
    popularity,
    danceability_level,
    energy_level,
    valence_level,
    acousticness_level
  ) %>%
  pivot_longer(
    cols = ends_with("_level"),
    names_to = "audio_feature",
    values_to = "feature_level"
  ) %>%
  mutate(
    audio_feature = recode(
      audio_feature,
      "danceability_level" = "Danceability",
      "energy_level" = "Energy",
      "valence_level" = "Valence",
      "acousticness_level" = "Acousticness"
    ),
    feature_level = factor(feature_level, levels = c("Low", "Medium", "High"))
  )

# Calculate average popularity for each feature level
feature_summary <- feature_long %>%
  group_by(audio_feature, feature_level) %>%
  summarise(
    avg_popularity = round(mean(popularity), 2),
    .groups = "drop"
  )
write_csv(feature_summary, "data/processed/feature_summary.csv") # For Tableau

# Create faceted green bar chart
feature_popularity_plot <- ggplot(
  feature_summary,
  aes(x = feature_level, y = avg_popularity, fill = feature_level)
) +
  geom_col(width = 0.7) +
  geom_text(aes(label = avg_popularity), vjust = -0.4, size = 4) +
  facet_wrap(~audio_feature, scales = "free_y") +
  labs(
    title = "Average Popularity by Audio Feature Level",
    subtitle = "Tracks were grouped into low, medium, and high levels for each audio feature",
    x = "Audio Feature Level",
    y = "Average Popularity Score",
    fill = "Level",
    caption = "Source: Kaggle Spotify Tracks Dataset | Processed in R and loaded into SQLite"
  ) +
  scale_fill_manual(
    values = c(
      "Low" = spotify_light_green,
      "Medium" = spotify_medium_green,
      "High" = spotify_dark_green
    )
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    strip.text = element_text(face = "bold", size = 12),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  )

# Show third plot
print(feature_popularity_plot)

# Save third plot
ggsave(
  filename = "visualizations/average_popularity_by_audio_feature_level_green.png",
  plot = feature_popularity_plot,
  width = 11,
  height = 7,
  dpi = 300
)

print("Third green visualization saved successfully!")

# ------------------------------------------------------------
# Fourth visualization:
# Popularity Category Distribution in Top 15 Genres
# ------------------------------------------------------------

# Get names of top 15 genres by average popularity
top_15_genre_names <- genre_summary %>%
  arrange(desc(avg_popularity)) %>%
  slice_head(n = 15) %>%
  pull(track_genre)

# Create percentage distribution of popularity categories
popularity_distribution <- spotify_clean %>%
  filter(track_genre %in% top_15_genre_names) %>%
  group_by(track_genre, popularity_category) %>%
  summarise(
    track_count = n(),
    .groups = "drop"
  ) %>%
  group_by(track_genre) %>%
  mutate(
    percentage = round(track_count / sum(track_count) * 100, 1)
  ) %>%
  ungroup() %>%
  mutate(
    popularity_category = factor(
      popularity_category,
      levels = c("Low", "Medium", "High")
    )
  )

# Order genres by average popularity
genre_order <- genre_summary %>%
  filter(track_genre %in% top_15_genre_names) %>%
  arrange(avg_popularity) %>%
  pull(track_genre)

popularity_distribution <- popularity_distribution %>%
  mutate(
    track_genre = factor(track_genre, levels = genre_order)
  )

write_csv(popularity_distribution, "data/processed/popularity_distribution.csv") # for Tableau

# Create 100% stacked bar chart
popularity_distribution_plot <- ggplot(
  popularity_distribution,
  aes(
    x = track_genre,
    y = percentage,
    fill = popularity_category
  )
) +
  geom_col(width = 0.8) +
  coord_flip() +
  geom_text(
    aes(label = paste0(percentage, "%")),
    position = position_stack(vjust = 0.5),
    size = 3.5,
    color = "white"
  ) +
  scale_fill_manual(
    values = c(
      "Low" = "#B3F5C6",
      "Medium" = "#1DB954",
      "High" = "#0B6623"
    )
  ) +
  labs(
    title = "Popularity Category Distribution in Top 15 Spotify Genres",
    subtitle = "Share of low, medium, and high popularity tracks within the most popular genres",
    x = "Genre",
    y = "Percentage of Tracks",
    fill = "Popularity Category",
    caption = "Source: Kaggle Spotify Tracks Dataset | Processed in R and loaded into SQLite"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    axis.text.y = element_text(size = 11),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom"
  )

# Show plot
print(popularity_distribution_plot)

# Save plot
ggsave(
  filename = "visualizations/popularity_category_distribution_top_15_genres.png",
  plot = popularity_distribution_plot,
  width = 11,
  height = 7,
  dpi = 300
)

print("Fourth visualization saved successfully!")



# ------------------------------------------------------------
# Fiftth visualization:
# Correlation Heatmap of Spotify Audio Features
# ------------------------------------------------------------

# Select numeric columns for correlation analysis
correlation_data <- spotify_clean %>%
  select(
    popularity,
    duration_min,
    danceability,
    energy,
    loudness,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo
  )

# Create correlation matrix
correlation_matrix <- cor(correlation_data, use = "complete.obs")

# Convert correlation matrix to long format
correlation_long <- as.data.frame(as.table(correlation_matrix))

# Rename columns
colnames(correlation_long) <- c("Feature1", "Feature2", "Correlation")

write_csv(correlation_long, "data/processed/correlation_long.csv") # For Tableau

# Create heatmap
correlation_heatmap <- ggplot(
  correlation_long,
  aes(x = Feature1, y = Feature2, fill = Correlation)
) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(Correlation, 2)), size = 3.5) +
  scale_fill_gradient2(
    low = "#0B6623",
    mid = "white",
    high = "#1DB954",
    midpoint = 0,
    limits = c(-1, 1)
  ) +
  labs(
    title = "Correlation Heatmap of Spotify Audio Features",
    subtitle = "Shows the strength and direction of relationships between popularity and audio features",
    x = "Audio Feature",
    y = "Audio Feature",
    fill = "Correlation",
    caption = "Source: Kaggle Spotify Tracks Dataset | Processed in R and loaded into SQLite"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()
  )

# Show heatmap
print(correlation_heatmap)

# Save heatmap
ggsave(
  filename = "visualizations/correlation_heatmap_spotify_features.png",
  plot = correlation_heatmap,
  width = 10,
  height = 8,
  dpi = 300
)

print("Fifth visualization saved successfully!")

# ------------------------------------------------------------
# Sixth visualization:
# Popularity Distribution by Top 15 Genres
# ------------------------------------------------------------
popularity_boxplot_data <- spotify_clean %>%

  filter(track_genre %in% top_15_genre_names) %>%

  mutate(track_genre = factor(track_genre, levels = genre_order))
  popularity_boxplot_data <- spotify_clean %>%

  filter(track_genre %in% top_15_genre_names) %>%

  mutate(track_genre = factor(track_genre, levels = genre_order))

popularity_boxplot <- ggplot(

  popularity_boxplot_data,

  aes(x = track_genre, y = popularity, fill = track_genre)

) +

  geom_boxplot(alpha = 0.8, outlier.alpha = 0.4) +

  coord_flip() +

  scale_fill_manual(

    values = rep(spotify_medium_green, length(top_15_genre_names))

  ) +

  labs(

    title = "Popularity Distribution in Top 15 Spotify Genres",

    subtitle = "Boxplots show median, spread, and outliers of track popularity by genre",

    x = "Genre",

    y = "Popularity Score",

    caption = "Source: Kaggle Spotify Tracks Dataset | Processed in R and loaded into SQLite"

  ) +

  theme_minimal(base_size = 14) +

  theme(

    legend.position = "none",

    plot.title = element_text(face = "bold", size = 18),

    plot.subtitle = element_text(size = 12),

    axis.title = element_text(face = "bold"),

    panel.grid.minor = element_blank()

  )

print(popularity_boxplot)

ggsave(

  filename = "visualizations/popularity_distribution_boxplot_top_15_genres.png",

  plot = popularity_boxplot,

  width = 11,

  height = 7,

  dpi = 300

)

print("Sixth visualization saved successfully!")