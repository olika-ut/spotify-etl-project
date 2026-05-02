# Spotify ETL and Data Visualization Project

## Project Overview

This project implements an ETL pipeline and data visualization analysis using the Spotify Tracks Dataset from Kaggle. The goal of the project is to explore how Spotify track popularity differs across genres and how audio features such as danceability, energy, valence, and acousticness relate to popularity.

The project extracts the raw CSV dataset, cleans and transforms the data using R, loads the cleaned data into a SQLite database, and generates visualizations using ggplot2.

## Research Question

How do genre and audio characteristics relate to Spotify track popularity?

## Data Source

The dataset used in this project is the Spotify Tracks Dataset from Kaggle.

- Dataset name: Spotify Tracks Dataset
- Source: Kaggle
- Original file: dataset.csv
- Format: CSV
- Rows in raw dataset: 114,000
- Columns in raw dataset: 21

The dataset includes track metadata and audio features such as popularity, duration, explicit status, danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, tempo, and genre.

Since Kaggle datasets are user-contributed, the results should be interpreted as exploratory and educational rather than official Spotify statistics.

## Project Structure

```text
spotify-etl-project/
│
├── data/
│   ├── raw/
│   │   └── dataset.csv
│   ├── processed/
│   │   ├── spotify_tracks_cleaned.csv
│   │   └── spotify_genre_summary.csv
│   └── database/
│       └── spotify_tracks.db
│
├── scripts/
│   ├── 01_extract_check.R
│   ├── 02_transform.R
│   ├── 03_load_database.R
│   └── 04_visualization.R
│
├── visualizations/
│   ├── top_15_genres_by_popularity_green.png
│   ├── energy_valence_popularity_by_genre_green.png
│   ├── average_popularity_by_audio_feature_level_green.png
│   ├── popularity_category_distribution_top_15_genres.png
│   └── correlation_heatmap_spotify_features.png
│
├── report/
│   └── final_report.md
│
├── README.md
├── requirements.txt
└── .gitignore
```

## How to Use the Pipeline

This section explains how to run the full ETL pipeline and generate the visualizations from start to finish.

### Prerequisites

Before running the project, make sure the following programs are installed:

- R
- RStudio

The project was developed using RStudio and R scripts.

### Installation Steps

First, open the project folder in RStudio.

Then install the required R packages by running the following command in the RStudio Console:

```r
install.packages(c("tidyverse", "DBI", "RSQLite", "ggplot2"))
```

These packages are used for reading data, cleaning data, working with SQLite databases, and creating visualizations.

### Dataset Setup

Download the Spotify Tracks Dataset from Kaggle and place the raw CSV file in the following folder:

```text
data/raw/
```

The file should be named:

```text
dataset.csv
```

The expected file path is:

```text
data/raw/dataset.csv
```

### Running the ETL Pipeline

Before running the scripts, make sure the working directory is the main project folder `spotify-etl-project`.

Run the R scripts in the following order.

#### Step 1: Extract and check the raw data

```r
source("scripts/01_extract_check.R")
```

This script loads the raw CSV file and checks the dataset structure, including rows, columns, column names, first records, and missing values.

#### Step 2: Transform and clean the data

```r
source("scripts/02_transform.R")
```

This script cleans the dataset by removing unnecessary columns, missing values, and duplicate tracks. It also creates new variables such as `duration_min` and `popularity_category`.

After this step, two processed CSV files are created:

```text
data/processed/spotify_tracks_cleaned.csv
data/processed/spotify_genre_summary.csv
```

#### Step 3: Load the data into SQLite

```r
source("scripts/03_load_database.R")
```

This script loads the cleaned data into a SQLite database.

The database is created here:

```text
data/database/spotify_tracks.db
```

The database contains two tables:

```text
spotify_tracks_cleaned
spotify_genre_summary
```

#### Step 4: Generate visualizations

```r
source("scripts/04_visualization.R")
```

This script reads the cleaned data from the SQLite database and generates the final visualizations using ggplot2.

The visualization files are saved in:

```text
visualizations/
```

### Expected Outputs

After running the full pipeline, the project should produce:

```text
data/processed/spotify_tracks_cleaned.csv
data/processed/spotify_genre_summary.csv
data/database/spotify_tracks.db
visualizations/top_15_genres_by_popularity_green.png
visualizations/energy_valence_popularity_by_genre_green.png
visualizations/average_popularity_by_audio_feature_level_green.png
visualizations/popularity_category_distribution_top_15_genres.png
visualizations/correlation_heatmap_spotify_features.png
```

### Full Pipeline Order

To run the complete project, use:

```r
source("scripts/01_extract_check.R")
source("scripts/02_transform.R")
source("scripts/03_load_database.R")
source("scripts/04_visualization.R")
```

The scripts must be run in this order because each step depends on the output of the previous step.

## ETL Process

### 1. Extract

The raw Spotify dataset was downloaded from Kaggle as a CSV file and placed in the `data/raw/` folder.

The script `01_extract_check.R` reads the raw dataset and checks:

- number of rows and columns,
- column names,
- first rows of the dataset,
- missing values.

This step confirms that the dataset can be successfully loaded into R.

### 2. Transform

The script `02_transform.R` cleans and prepares the dataset for analysis.

The transformation steps include:

- removing the unnecessary index column,
- removing rows with missing artist, album, track name, or genre values,
- removing duplicate tracks based on `track_id`,
- converting track duration from milliseconds to minutes,
- standardizing genre names,
- creating a `popularity_category` variable,
- creating a genre-level summary table.

The transformation process creates two cleaned output files:

```text
data/processed/spotify_tracks_cleaned.csv
data/processed/spotify_genre_summary.csv
```

### 3. Load

The load step stores the cleaned and transformed data in a SQLite database. After the transformation step, two processed CSV files are created:

- `data/processed/spotify_tracks_cleaned.csv`
- `data/processed/spotify_genre_summary.csv`

The script `03_load_database.R` reads these processed files and loads them into a SQLite database located at:

```text
data/database/spotify_tracks.db
```

The database contains two tables:

- `spotify_tracks_cleaned`
- `spotify_genre_summary`

The `spotify_tracks_cleaned` table contains the cleaned track-level data. The `spotify_genre_summary` table contains aggregated genre-level statistics, such as average popularity, average danceability, average energy, average valence, average tempo, average duration, and track count.

This step is important because it stores the cleaned data in a structured database, making the project more organized and allowing the visualization script to read data from the database instead of using the raw CSV file.

### 4. Visualization

The script `04_visualization.R` reads the processed data from the SQLite database and creates visualizations using ggplot2.

The visualizations explore:

- top genres by average popularity,
- energy and valence patterns by genre,
- popularity by audio feature level,
- popularity category distribution in top genres,
- correlations between Spotify audio features.

## Visualizations

The main visualizations created in this project are:

1. **Top 15 Spotify Genres by Average Popularity**  
   This chart shows which genres have the highest average popularity scores in the cleaned dataset.

2. **Spotify Genres by Energy, Valence, and Popularity**  
   This scatter plot shows how genres differ by average energy and valence, while point size and color represent average popularity.

3. **Average Popularity by Audio Feature Level**  
   This chart compares average popularity for tracks with low, medium, and high levels of acousticness, danceability, energy, and valence.

4. **Popularity Category Distribution in Top 15 Genres**  
   This stacked bar chart shows the percentage of low, medium, and high popularity tracks within the top 15 genres.

5. **Correlation Heatmap of Spotify Audio Features**  
   This heatmap shows the strength and direction of relationships between popularity and numerical audio features.

Together, these visualizations show that Spotify popularity in this dataset is related to both genre and audio characteristics, but no single audio feature fully explains popularity.

## Data Management and Engineering Practices

This project follows basic data management and engineering practices:

- raw data is stored separately from processed data,
- cleaned data is saved in a separate processed folder,
- transformed data is loaded into a SQLite database,
- scripts are numbered according to execution order,
- each ETL stage is separated into a different script,
- visualizations are generated from processed data rather than manually edited files,
- output charts are saved in a dedicated visualization folder,
- the README documents how to run the full pipeline from start to finish.

## Requirements

This project was created using R and RStudio.

Required R packages:

```text
tidyverse
DBI
RSQLite
ggplot2
```

Install the required packages in RStudio using:

```r
install.packages(c("tidyverse", "DBI", "RSQLite", "ggplot2"))
```

## Project Outputs

The project creates the following outputs:

### Processed Data

```text
data/processed/spotify_tracks_cleaned.csv
data/processed/spotify_genre_summary.csv
```

### SQLite Database

```text
data/database/spotify_tracks.db
```

### Visualization Files

```text
visualizations/top_15_genres_by_popularity_green.png
visualizations/energy_valence_popularity_by_genre_green.png
visualizations/average_popularity_by_audio_feature_level_green.png
visualizations/popularity_category_distribution_top_15_genres.png
visualizations/correlation_heatmap_spotify_features.png
```

## Limitations

The dataset comes from Kaggle and is not an official live Spotify dataset. Therefore, the findings should be interpreted as exploratory and educational rather than official Spotify statistics.

The popularity score is treated as a relative score from 0 to 100. It does not represent the exact number of streams, likes, or listeners.

The analysis is based only on the available dataset and may not represent current global Spotify listening patterns.

## Conclusion

This project demonstrates a complete ETL and visualization workflow. The raw Spotify dataset was extracted, cleaned, transformed, loaded into a SQLite database, and visualized using ggplot2.

The analysis shows that k-pop, pop-film, and metal have the highest average popularity scores in the dataset. However, the visualizations also suggest that popularity is not explained by genre alone. Tracks with medium levels of audio features such as danceability, energy, valence, and acousticness tend to have slightly higher average popularity, while the correlation heatmap shows that no single audio feature strongly explains popularity by itself.