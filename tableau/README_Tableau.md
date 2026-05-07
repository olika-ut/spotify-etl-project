# Tableau Dashboard Documentation

## Overview

This document explains how the Tableau part of the Spotify ETL and Data Visualization Project was created.

The main ETL pipeline was created in RStudio using R. The raw Spotify dataset was cleaned, transformed, and loaded into a SQLite database. Some extra processed CSV files were also exported from R so they could be used in Tableau.

Tableau was used to try an interactive dashboard tool and to experiment with chart design, labels, colors, and layout. Screenshots of the Tableau dashboard are saved in the `tableau/screenshots/` folder.

## Tableau Installation

Tableau Desktop was installed from the Tableau website (https://www.tableau.com/products/desktop-free/download).

Steps:

1. Download Tableau Desktop.
2. Install it on the computer.
3. Open Tableau Desktop.
4. Start a new workbook.

Tableau was chosen because it supports interactive visualizations and dashboards.

## Data Files Used in Tableau

The raw dataset was not used directly in Tableau. Instead, Tableau used processed files created by the R ETL pipeline.

Files used:

```text
data/processed/spotify_genre_summary.csv
data/processed/feature_summary.csv
data/processed/popularity_distribution.csv
data/processed/correlation_long.csv
```

Short description:

- `spotify_genre_summary.csv` contains genre-level averages.
- `feature_summary.csv` contains average popularity by audio feature level.
- `popularity_distribution.csv` contains popularity category percentages for top genres.
- `correlation_long.csv` contains correlation values between numerical audio features.

## How Data Was Added to Tableau

Each CSV file was added as a separate text file data source.

Steps:

1. Open Tableau Desktop.
2. Click **Text file**.
3. Select a CSV file from `data/processed/`.
4. Create a worksheet.
5. Repeat this for the other processed CSV files.

Additional files were added through:

```text
Data → New Data Source → Text file
```

## Tableau Visualizations

### 1. Top 15 Spotify Genres by Average Popularity

Data source:

```text
spotify_genre_summary.csv
```

Main fields:

```text
Rows: track_genre
Columns: avg_popularity
Color: avg_popularity
Label: avg_popularity
Filter: Top 15 by avg_popularity
```

This chart shows which genres have the highest average popularity scores.

### 2. Spotify Genres by Energy, Valence, and Popularity

Data source:

```text
spotify_genre_summary.csv
```

Main fields:

```text
Columns: avg_energy
Rows: avg_valence
Detail: track_genre
Size: avg_popularity
Color: avg_popularity
```

This chart compares genres by energy and valence. Larger and darker points show higher average popularity.

### 3. Average Popularity by Audio Feature Level

Data source:

```text
feature_summary.csv
```

Main fields:

```text
Columns: audio_feature
Columns: feature_level
Rows: avg_popularity
Color: feature_level
Label: avg_popularity
```

This chart shows whether low, medium, or high audio feature levels have higher average popularity.

### 4. Popularity Category Distribution in Top 15 Genres

Data source:

```text
popularity_distribution.csv
```

Main fields:

```text
Rows: track_genre
Columns: percentage
Color: popularity_category
Label: percentage
```

This stacked bar chart shows the share of low, medium, and high popularity tracks inside the top 15 genres.

### 5. Correlation Heatmap of Spotify Audio Features

Data source:

```text
correlation_long.csv
```

Main fields:

```text
Columns: Feature1
Rows: Feature2
Color: Correlation
Label: Correlation
Marks type: Square
```

This heatmap shows relationships between numerical audio features. Values close to 1 show strong positive relationships, values close to -1 show strong negative relationships, and values close to 0 show weak relationships.

## Dashboard Creation

After the worksheets were created, they were combined into a Tableau dashboard.

Steps:

1. Click **New Dashboard**.
2. Drag selected sheets into the dashboard.
3. Add a title and short explanation.
4. Add source information.
5. Adjust chart sizes, spacing, and legends.
6. Save the workbook.

The dashboard was designed with a green color theme to match the Spotify style.

## Design Choices

The main design choices were:

- green colors were used to match the Spotify theme,
- labels were added to make values easier to read,
- numbers were formatted to two decimal places where needed,
- some charts were kept separate because they needed more space,
- tooltips were used to make the dashboard more interactive.

## Saving the Tableau Workbook

The Tableau workbook was saved as a packaged workbook:

```text
tableau/spotify_tableau_dashboard.twbx

This format was chosen because it keeps the workbook and data together, so the file can be opened and edited later.

Recommended saving step:

```text
File → Export Packaged Workbook
```

## Challenges

One challenge was that could not use the PNG charts created in RStudio as interactive charts. To solve this, the summary data behind the R charts was exported as additional CSV files, such as `feature_summary.csv`, `popularity_distribution.csv`, and `correlation_long.csv`.

The dashboard design was also challenging. The final dashboard does not look as professional or visually polished as intended. More time would be needed to make the layout more graphical, logical, and visually interesting. In this project, Tableau was mainly used to try a new visualization tool and learn how interactive dashboards work.

Formatting also took time. Some labels were too long, decimal numbers had to be adjusted, and axis scales had to be fixed manually.

## Dashboard Story

The Tableau dashboard tells a simple story.

First, it shows which genres have the highest average popularity. Then it compares genres by energy and valence to see whether popular genres share a similar sound profile. Next, it shows how average popularity changes across low, medium, and high audio feature levels. The popularity category chart gives more detail about the top genres, and the heatmap shows that no single audio feature strongly explains popularity by itself.

Overall, the Tableau dashboard suggests that Spotify popularity in this dataset is connected to both genre and audio characteristics, but there is no one simple formula for popularity.