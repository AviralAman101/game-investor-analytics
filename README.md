# Game Investor Analytics

Data-driven analytics for video game investment decisions. This project uses historical sales data from `games.csv` to help a hypothetical startup (**Sonic Gaming Systems**) answer strategic questions about genre, platform, regional launch, and expected commercial performance.

The analysis is organized into folders by phase: data cleaning, descriptive analytics, and predictive analytics. Visual outputs and business conclusions are documented in `presentation-and-docs/`.

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

**Source file:** `games.csv` (project root, ~16,719 games after cleaning)

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

```
game-investor-analytics/
├── games.csv                          # Raw dataset (project root)
├── README.md
│
├── data-cleaning/                     # Phase 0 — data preparation
│   └── 1_data_cleaning.R
│
├── descriptive-analytics/             # Phase A — exploratory & descriptive analysis
│   ├── 2_dataset_analysis.R
│   ├── 3_sales_analytics.R
│   ├── 4_commercial_success_by_sales.R
│   ├── 5_regional_sale_analysis.R
│   └── top_10.R
│
├── predictive-analytics/              # Phase B — GLM models & forecasting
│   ├── predictive_analysis.R
│   ├── predictive_analytics_2.R
│   ├── global_sales_prediction.R
│   ├── prediction_test.R
│   └── test_prediction.R
│
└── presentation-and-docs/             # Project deliverables & documentation
    ├── Presentation Games Analytics.pptx
    └── Group 7 - Strategic Game Publishing Decision Support Framework.docx
```

---

## Folder Guide

### `data-cleaning/`

Contains scripts that load, inspect, and prepare the raw dataset. This is the **first step** in the pipeline — all downstream analysis depends on the cleaned `games_data` object produced here.

| File | Description |
|---|---|
| `1_data_cleaning.R` | Loads `games.csv`, summarizes missing values, removes duplicates, cleans `User_Score`, and converts numeric columns |

---

### `descriptive-analytics/`

Contains scripts for **Phase A — Descriptive Analytics**. These explore historical patterns in the data: dataset overview, genre-level sales, commercial success rates, regional market performance, and top performers. Scripts are numbered `2`–`5` and should be run in order after data cleaning.

| File | Description |
|---|---|
| `2_dataset_analysis.R` | Basic dataset statistics; bar chart of games by genre; lollipop chart of games by gaming system |
| `3_sales_analytics.R` | Total, average, and median global sales by genre with visualizations |
| `4_commercial_success_by_sales.R` | Commercial success classification, success rate by genre, Genre × Platform analysis, decision tree (`rpart`) |
| `5_regional_sale_analysis.R` | Regional sales summary, market share pie chart, genre × region heatmap, priority market identification |
| `top_10.R` | Top 10 games ranked by global sales (supplementary) |

---

### `predictive-analytics/`

Contains scripts for **Phase B — Predictive Analytics**. These build GLM models to forecast commercial success and global sales, then apply those models to hypothetical game scenarios.

| File | Description |
|---|---|
| `predictive_analysis.R` | Primary binomial GLM (`Commercial_Success ~ Gaming_System + Gaming_Era`); scenario table and top-5 platforms by era |
| `predictive_analytics_2.R` | Model development: creates binary `Success` outcome, builds logistic GLM, tests whether Genre is statistically significant |
| `global_sales_prediction.R` | Gamma GLM for predicting `Global_Sales`; nested model comparison to test Genre significance |
| `prediction_test.R` | Applies fitted success model to 4 hypothetical new games |
| `test_prediction.R` | Applies both sales and success models to 10 hypothetical test games |

---

### `presentation-and-docs/`

Contains the **project deliverables** — the overall presentation and supporting documents. These summarize findings from both descriptive and predictive phases for stakeholders.

| File | Description |
|---|---|
| `Presentation Games Analytics.pptx` | Full analytics report with charts, key findings, GLM results, and business recommendations |
| `Group 7 - Strategic Game Publishing Decision Support Framework.docx` | Written project document outlining the strategic decision-support framework |

---

## Analysis Pipeline

### Phase 0 — Data Cleaning (`data-cleaning/1_data_cleaning.R`)

Prepares `games.csv` for analysis:

- Loads data and inspects structure, dimensions, and column types
- Summarizes missing values by column
- Removes duplicate rows
- Converts `"tbd"` user scores to `NA` and casts numeric columns
- Outputs a cleaned `games_data` object for downstream scripts

**Libraries:** `tidyverse`, `rpart`, `rpart.plot`, `caret`, `corrplot`, `dplyr`

---

### Phase A — Descriptive Analytics (`descriptive-analytics/`)

#### 2. Dataset Analysis (`2_dataset_analysis.R`)

Exploratory overview of the cleaned dataset:

- Counts games, genres, gaming systems, publishers, and developers
- Reports earliest and latest release years
- **Visualizations:** games by genre (bar chart), games by gaming system (lollipop chart)

#### 3. Sales Analytics (`3_sales_analytics.R`)

Builds an analytical subset filtered on non-missing `Global_Sales`, `Genre`, and `Gaming_System`:

- Total, average, and median global sales per genre
- **Visualizations:** average, total, and median global sales by genre

**Key insight:** Total sales alone can be misleading because genres have different numbers of games; average and median sales provide a fairer per-game comparison.

#### 4. Commercial Success by Sales (`4_commercial_success_by_sales.R`)

Classifies games as commercially successful or not, then explores drivers of success:

- **Success threshold:** median global sales (~0.17M units)
- Success rate (%) by genre; Genre × Gaming System aggregation (min. 10 games)
- **Regression decision tree** (`rpart`) for average global sales by genre and platform

**Key findings:**

- Platform, Sports, and Shooter genres show the highest historical success rates (~58–60%)
- A small subset of Genre × Platform combinations (8 of 207) shows dramatically higher average sales (~2.6M vs. overall ~0.57M)

#### 5. Regional Sales Analysis (`5_regional_sale_analysis.R`)

Analyzes geographic market performance to inform launch strategy:

- Total, average, and median sales by region; market share; priority market per genre
- **Visualizations:** regional share pie chart, average sales bar chart, genre × region heatmap

**Key findings:**

- North America contributes ~49.4% of total recorded regional sales
- North America and Europe are the strongest overall markets
- Priority markets vary by genre, supporting targeted rather than uniform global launch

---

### Phase B — Predictive Analytics (`predictive-analytics/`)

Moves from descriptive patterns to forecasting using **Generalized Linear Models (GLM)**.

**Feature engineering:**

- `Commercial_Success` / `Success`: binary outcome (threshold = 0.17M global sales)
- `Gaming_Era`: release year grouped into eras (Early Era, 1995–1999, 2000–2004, 2005–2009, 2010–2014, 2015+)

**Primary success model** (`predictive_analysis.R`):

```r
success_model <- glm(
  Commercial_Success ~ Gaming_System + Gaming_Era,
  data = regression_data,
  family = binomial
)
```

**Sales prediction model** (`global_sales_prediction.R`):

```r
model_sales_full <- glm(
  Global_Sales ~ Genre + Gaming_System + Year_of_Release,
  data = df_model,
  family = Gamma(link = "log")
)
```

An initial model also explored `Global_Sales ~ Genre + Gaming_System + Year_of_Release`; findings showed **Gaming System** as the strongest predictor, with Genre dropped after controlling for platform and time effects.

**Outputs:**

- Scenario table: predicted success probability (%) for each Gaming System × Gaming Era combination
- Top 5 gaming systems by era ranked by success probability
- Predicted sales and success probabilities for hypothetical test games

**Approach:** Descriptive Analytics → Identify patterns → Predictive Model → Estimate future performance → Business decision

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

## Presentation & Documentation

See `presentation-and-docs/` for the full project deliverables:

- **`Presentation Games Analytics.pptx`** — analytics report covering business problem, dataset overview, Phase A descriptive findings, Phase B GLM models and scenario forecasts, and recommendations for Sonic Gaming Systems
- **`Group 7 - Strategic Game Publishing Decision Support Framework.docx`** — written framework document for the strategic decision-support approach

**Authors (from presentation):** Aviral Aman, Bharat Chawla, Riya Setiya, Shreya Jalgaonkar

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
  "car",
  "knitr",
  "kableExtra",
  "flextable",
  "tidyr"
))
```

---

## How to Run

1. Clone or download this repository.
2. Ensure `games.csv` is in the **project root** directory.
3. Open R or RStudio and set the working directory to the project root:

```r
setwd("/path/to/game-investor-analytics")
```

4. Run scripts in order within the same R session:

```r
# Phase 0 — Data Cleaning
source("data-cleaning/1_data_cleaning.R")

# Phase A — Descriptive Analytics
source("descriptive-analytics/2_dataset_analysis.R")
source("descriptive-analytics/3_sales_analytics.R")
source("descriptive-analytics/4_commercial_success_by_sales.R")
source("descriptive-analytics/5_regional_sale_analysis.R")
source("descriptive-analytics/top_10.R")          # optional

# Phase B — Predictive Analytics
source("predictive-analytics/predictive_analytics_2.R")   # model setup & df_model
source("predictive-analytics/global_sales_prediction.R") # Gamma GLM for sales
source("predictive-analytics/predictive_analysis.R")      # binomial GLM for success
source("predictive-analytics/prediction_test.R")          # optional — test scenarios
source("predictive-analytics/test_prediction.R")          # optional — 10 test games
```

> **Note:** Scripts depend on in-memory objects (`games_data`, `analysis_data`, `df_model`, etc.) from prior steps. Run them sequentially in the same R session with the working directory set to the project root.

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
