library(tidyverse)
library(DBI)
library(RSQLite)

# Step 1: Read the transformed CSV files
spotify_clean <- read_csv("data/processed/spotify_tracks_cleaned.csv", show_col_types = FALSE)
genre_summary <- read_csv("data/processed/spotify_genre_summary.csv", show_col_types = FALSE)

# Step 2: Create/connect to SQLite database
con <- dbConnect(
  SQLite(),
  "data/database/spotify_tracks.db"
)

# Step 3: Load cleaned data into database tables
dbWriteTable(
  con,
  "spotify_tracks_cleaned",
  spotify_clean,
  overwrite = TRUE
)

dbWriteTable(
  con,
  "spotify_genre_summary",
  genre_summary,
  overwrite = TRUE
)

# Step 4: Check that tables were created
print("Tables in the database:")
print(dbListTables(con))

print("Preview of spotify_genre_summary table:")
print(dbGetQuery(con, "SELECT * FROM spotify_genre_summary LIMIT 5"))

print("Number of rows in spotify_tracks_cleaned:")
print(dbGetQuery(con, "SELECT COUNT(*) AS total_rows FROM spotify_tracks_cleaned"))

print("Number of rows in spotify_genre_summary:")
print(dbGetQuery(con, "SELECT COUNT(*) AS total_rows FROM spotify_genre_summary"))

# Step 5: Disconnect from database
dbDisconnect(con)

print("Data loaded into SQLite database successfully!")