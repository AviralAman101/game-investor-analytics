# Game Investor Analytics

Data-driven analytics for video game investment decisions. This project uses historical sales data from `games.csv` to help a hypothetical startup (**Sonic Gaming Systems**) answer strategic questions about genre, platform, regional launch, and expected commercial performance.

The analysis is implemented as a sequence of R scripts (run in order), culminating in predictive modeling with GLM. Visual outputs and business conclusions are documented in `Presentation Games Analytics.pptx`.

---

## Business Context

A new game publisher with limited resources must decide:

| Decision Area | Business Question |
|---|---|
| Product Strategy | Which genre should we invest in? |
| Platform Strategy | Which gaming system offers the highest reach and revenue potential? |
| Market Strategy | Which geographic markets should be prioritized? |
| Go-to-Market Strategy | Global launch or selected regional launch? |
| Forecasting | What commercial performance can reasonably be expected? |

Rather than relying on intuition alone, this project applies descriptive and predictive analytics to historical market data.

---

## Dataset

**Source file:** `games.csv` (~16,719 games after cleaning)

| Column | Description |
|---|---|
| `Name` | Game title |
| `Gaming_System` | Platform (e.g., Wii, PS3, NES) |
| `Year_of_Release` | Release year |
| `Genre` | Game genre |
| `Publisher` / `Developer` | Publishing and development studio |
| `NA_Sales`, `EU_Sales`, `JP_Sales`, `Other_Sales` | Regional sales (millions of units) |
| `Global_Sales` | Total global sales (millions of units) |
| `Critic_Score`, `Critic_Count` | Professional review metrics |
| `User_Score`, `User_Count` | User review metrics |
| `Rating` | Content rating (e.g., E, T, M) |

**Dataset snapshot (after cleaning):**

- **Games:** 16,719
- **Genres:** 13
- **Gaming systems:** 31
- **Publishers:** 582
- **Developers:** 1,697
- **Year range:** 1980–2020

---

## Project Structure

Scripts are numbered and intended to be run sequentially. Each script builds on variables and cleaned data from prior steps.

```
game-investor-analytics/
├── games.csv                              # Raw dataset
├── 1_data_cleaning.R                      # Load, inspect, and clean data
├── 2_dataset_analysis.R                   # Basic dataset statistics & charts
├── 3_sales_analytics.R                    # Genre-level sales analysis
├── 4_commercial_success_by_sales.R        # Success classification & decision tree
├── 5_regional_sale_analysis.R             # Regional market analysis
├── predictive_analysis.R                  # GLM predictive modeling
├── top_10.R                               # Top 10 games by global sales
└── Presentation Games Analytics.pptx      # Full analytics report & findings
```

---

## Analysis Pipeline

### 1. Data Cleaning (`1_data_cleaning.R`)

Prepares `games.csv` for analysis:

- Loads data and inspects structure, dimensions, and column types
- Summarizes missing values by column
- Removes duplicate rows
- Converts `"tbd"` user scores to `NA` and casts numeric columns
- Outputs a cleaned `games_data` object for downstream scripts

**Libraries:** `tidyverse`, `rpart`, `rpart.plot`, `caret`, `corrplot`, `dplyr`

---

### 2. Dataset Analysis (`2_dataset_analysis.R`)

Exploratory overview of the cleaned dataset:

- Counts games, genres, gaming systems, publishers, and developers
- Reports earliest and latest release years
- **Visualizations:**
  - Bar chart: number of games by genre
  - Lollipop chart: number of games by gaming system

---

### 3. Sales Analytics (`3_sales_analytics.R`)

Builds an analytical subset filtered on non-missing `Global_Sales`, `Genre`, and `Gaming_System`, then analyzes sales by genre:

- Total, average, and median global sales per genre
- **Visualizations:**
  - Average global sales by genre
  - Total global sales by genre
  - Median global sales by genre

**Key insight:** Total sales alone can be misleading because genres have different numbers of games; average and median sales provide a fairer per-game comparison.

---

### 4. Commercial Success by Sales (`4_commercial_success_by_sales.R`)

Classifies games as commercially successful or not, then explores drivers of success:

- **Success threshold:** median global sales (~0.17M units)
- Labels games as `"Successful"` or `"Not Successful"`
- Computes success rate (%) by genre
- Aggregates Genre × Gaming System combinations (minimum 10 games)
- Builds a **regression decision tree** (`rpart`) to model average global sales by genre and platform

**Visualizations:**

- Commercial success rate by genre
- Decision tree: Genre × Gaming System → expected global sales

**Key findings:**

- Platform, Sports, and Shooter genres show the highest historical success rates (~58–60%)
- Adventure, Strategy, and Puzzle show comparatively lower success rates
- A small subset of Genre × Platform combinations (8 of 207) shows dramatically higher average sales (~2.6M vs. overall ~0.57M)

---

### 5. Regional Sales Analysis (`5_regional_sale_analysis.R`)

Analyzes geographic market performance to inform launch strategy:

- Total, average, and median sales for North America, Europe, Japan, and Other regions
- Market share by region
- Genre-wise regional sales and priority market per genre
- **Visualizations:**
  - Pie chart: regional share of total sales
  - Bar chart: average sales per game by region
  - Heatmap: genre-wise regional sales

**Key findings:**

- North America contributes ~49.4% of total recorded regional sales
- North America and Europe are the strongest overall markets
- Japan shows a more distinct regional preference pattern
- Priority markets vary by genre, supporting targeted rather than uniform global launch

---

### 6. Predictive Analytics (`predictive_analysis.R`)

Moves from descriptive patterns to forecasting commercial success using **Generalized Linear Models (GLM)**:

**Feature engineering:**

- `Commercial_Success`: binary outcome (threshold = 0.17M global sales)
- `Gaming_Era`: release year grouped into eras (Early Era, 1995–1999, 2000–2004, 2005–2009, 2010–2014, 2015+)

**Model:**

```r
success_model <- glm(
  Commercial_Success ~ Gaming_System + Gaming_Era,
  data = regression_data,
  family = binomial
)
```

An initial model also explored `Global_Sales ~ Genre + Gaming_System + Year_of_Release`; findings showed **Gaming System** as the strongest predictor, with Genre dropped after controlling for platform and time effects.

**Outputs:**

- Scenario table: predicted success probability (%) for each Gaming System × Gaming Era combination
- Top 5 gaming systems by era ranked by success probability

**Approach:** Descriptive Analytics → Identify patterns → Predictive Model → Estimate future performance → Business decision

---

### Supplementary: Top 10 Games (`top_10.R`)

Ranks and displays the top 10 games by global sales (filtered for non-missing name, genre, and platform).

---

## Key Findings Summary

| Area | Finding |
|---|---|
| **Market size** | Action has the largest total global sales volume |
| **Per-game performance** | Median sales vary substantially by genre |
| **Commercial success** | Platform (~60%), Sports (~59.7%), and Shooter (~57.7%) lead success rates |
| **Genre × Platform** | 8 high-performing combinations average ~2.63M sales vs. ~0.57M overall |
| **Regional markets** | North America and Europe dominate; NA ~49.4% of total sales |
| **Predictive modeling** | Gaming System and Gaming Era are key predictors of commercial success |

---

## Presentation

`Presentation Games Analytics.pptx` contains the full analytics report, including:

- Business problem and scope
- Dataset overview and variable mapping
- Phase A: Descriptive analytics (sales, success rates, regional analysis, decision tree)
- Phase B: Predictive analytics (GLM models, scenario forecasts)
- Key findings and recommendations for Sonic Gaming Systems
- Suggested future work (interaction models, region-specific prediction, time-series forecasting)

**Author (from presentation):** Aviral Aman

---

## Requirements

### R Packages

Install dependencies before running the scripts:

```r
install.packages(c(
  "tidyverse",
  "ggplot2",
  "dplyr",
  "rpart",
  "rpart.plot",
  "caret",
  "corrplot",
  "knitr",
  "kableExtra",
  "flextable",
  "tidyr"
))
```

---

## How to Run

1. Clone or download this repository.
2. Ensure `games.csv` is in the project root directory.
3. Open R or RStudio and set the working directory to the project folder.
4. Run scripts in order:

```r
source("1_data_cleaning.R")
source("2_dataset_analysis.R")
source("3_sales_analytics.R")
source("4_commercial_success_by_sales.R")
source("5_regional_sale_analysis.R")
source("predictive_analysis.R")
source("top_10.R")   # optional
```

> **Note:** Scripts depend on in-memory objects (`games_data`, `analysis_data`, `genre_summary`, etc.) from prior steps. Run them sequentially in the same R session.

---

## Scope & Limitations

This study is limited to historical sales data available in `games.csv`. It does **not** include:

- Production or development costs
- Player engagement or retention metrics
- Real-time market trends beyond the dataset's 2020 cutoff
- Customer sentiment beyond available critic/user scores

Suggested extensions include Genre × Platform × Era interaction models, region-specific predictive models, and comparison of GLM with decision trees and other classification approaches.

---

## License

This repository is for academic and analytical use. Refer to your institution's guidelines for data usage and attribution.
