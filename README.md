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
| Market Intelligence | What historical trends should influence future decisions? |

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
├── games.csv                                    # Raw dataset (project root)
├── README.md
├── Strategic Game Publishing Decision Support Framework.docx
│
├── data-cleaning/                               # Phase 0 — data preparation & feature engineering
│   └── 1_data_cleaning_transformation.R
│
├── descriptive-analytics/                       # Phase A — exploratory & descriptive analysis
│   ├── 2_dataset_analysis.R
│   ├── 3_sales_analytics.R
│   ├── 4_commercial_success_by_sales.R
│   ├── 5_regional_sale_analysis.R
│   └── top_10.R
│
├── predictive-analytics/                        # Phase B — GLM models & forecasting
│   ├── model_formulation.R
│   ├── predictive_analysis_for_era.R
│   ├── test_main_fromula.R
│   └── test_gaming_era_predictions.R
│
└── presentation-and-docs/                       # Project deliverables
    └── Presentation Games Analytics Final.pptx
```

---

## Folder Guide

### `data-cleaning/`

Contains scripts that load, inspect, clean, and transform the raw dataset. This is the **first step** in the pipeline — all downstream analysis depends on the cleaned `games_data` and `analysis_data` objects produced here.

| File | Description |
|---|---|
| `1_data_cleaning_transformation.R` | Loads `games.csv`, handles missing values and duplicates, cleans `User_Score`, converts numeric columns, filters the analytical subset, and engineers `Commercial_Success` and `Gaming_Era` features |

**Engineered features:**

- `Commercial_Success` — binary label (`"Successful"` / `"Not Successful"`) based on a 0.17M global sales threshold
- `Gaming_Era` — release year grouped into industry periods: Early Era, 1995–1999, 2000–2004, 2005–2009, 2010–2014, 2015+
- `analysis_data` — filtered subset with non-missing `Global_Sales`, `Genre`, and `Gaming_System`

---

### `descriptive-analytics/`

Contains scripts for **Phase A — Descriptive Analytics**. These explore historical patterns: dataset overview, genre-level sales, commercial success rates, regional market performance, and top performers. Scripts are numbered `2`–`5` and should be run in order after data cleaning.

| File | Description |
|---|---|
| `2_dataset_analysis.R` | Basic dataset statistics; bar chart of games by genre; lollipop chart of games by gaming system |
| `3_sales_analytics.R` | Total, average, and median global sales by genre with visualizations |
| `4_commercial_success_by_sales.R` | Commercial success classification, success rate by genre, Genre × Platform analysis, decision tree (`rpart`) |
| `5_regional_sale_analysis.R` | Regional sales summary, market share pie chart, genre × region heatmap, priority market identification |
| `top_10.R` | Top 10 games ranked by global sales (supplementary) |

---

### `predictive-analytics/`

Contains scripts for **Phase B — Predictive Analytics**. These build and evaluate GLM models, then apply them to hypothetical game scenarios.

| File | Description |
|---|---|
| `model_formulation.R` | Builds the primary logistic GLM (`Success ~ Genre + Gaming_System + Gaming_Era`) and the secondary era model (`Commercial_Success ~ Gaming_System + Gaming_Era`); tests and drops `Publisher` due to sparsity/overfitting |
| `predictive_analysis_for_era.R` | Generates the Gaming System × Gaming Era scenario table and top-5 platforms by era using the secondary model |
| `test_main_fromula.R` | Applies the primary model to 10 hypothetical Genre × Platform × Era combinations (2015+ scenarios) |
| `test_gaming_era_predictions.R` | Applies the secondary model to 12 gaming systems in the 2015+ era |

---

### `presentation-and-docs/`

Contains the **final project presentation** summarizing descriptive and predictive findings for stakeholders.

| File | Description |
|---|---|
| `Presentation Games Analytics Final.pptx` | Full analytics report — business problem, dataset overview, Phase A findings, Phase B GLM models, test predictions, and recommendations |

**Supporting document (project root):**

| File | Description |
|---|---|
| `Strategic Game Publishing Decision Support Framework.docx` | Written framework document outlining the strategic decision-support approach |

---

## Analysis Pipeline

### Phase 0 — Data Cleaning & Transformation (`data-cleaning/1_data_cleaning_transformation.R`)

Prepares `games.csv` and engineers features for modeling:

- Loads data; inspects structure, dimensions, and missing values
- Removes duplicate rows
- Converts `"tbd"` user scores to `NA` and casts numeric columns
- Filters `analysis_data` for complete sales, genre, and platform records
- Creates `Commercial_Success` and `Gaming_Era` on `games_data`

**Libraries:** `tidyverse`, `rpart`, `rpart.plot`, `caret`, `corrplot`, `dplyr`

---

### Phase A — Descriptive Analytics (`descriptive-analytics/`)

#### 2. Dataset Analysis (`2_dataset_analysis.R`)

- Counts games, genres, gaming systems, publishers, and developers
- Reports earliest and latest release years
- **Visualizations:** games by genre (bar chart), games by gaming system (lollipop chart)

#### 3. Sales Analytics (`3_sales_analytics.R`)

- Total, average, and median global sales per genre
- **Visualizations:** average, total, and median global sales by genre

**Key insight:** Total sales alone can be misleading because genres have different numbers of games; average and median sales provide a fairer per-game comparison.

#### 4. Commercial Success by Sales (`4_commercial_success_by_sales.R`)

- **Success threshold:** 0.17M global sales (~median)
- Success rate (%) by genre; Genre × Gaming System aggregation (min. 10 games)
- **Regression decision tree** (`rpart`) for average global sales by genre and platform

**Key findings:**

- Platform (60%), Sports (59.7%), and Shooter (57.7%) lead historical success rates
- Adventure, Strategy, and Puzzle show comparatively lower rates
- 8 Genre × Platform combinations average ~2.63M sales vs. ~0.57M overall (~4.6× higher)
- Historical sales are highly skewed — a small number of blockbusters drive totals, reinforcing the importance of Genre–Platform selection

#### 5. Regional Sales Analysis (`5_regional_sale_analysis.R`)

- Total, average, and median sales by region; market share; priority market per genre
- **Visualizations:** regional share pie chart, average sales bar chart, genre × region heatmap

**Key findings:**

- North America contributes ~49.4% of total recorded regional sales
- North America and Europe are the strongest overall markets
- Japan shows a more distinct regional preference pattern
- Priority markets vary by genre, supporting targeted rather than uniform global launch

---

### Phase B — Predictive Analytics (`predictive-analytics/`)

Moves from descriptive patterns to forecasting commercial success using **Generalized Linear Models (GLM)**.

#### Feature Engineering — `Gaming_Era`

`Year_of_Release` (1980–2020, 40+ values) is grouped into `Gaming_Era` to reflect console-generation shifts rather than assuming a smooth year-by-year trend. This reduces sparsity and overfitting compared to using raw year or high-cardinality categorical variables like `Publisher`.

#### Two-Model Approach

**Primary model** — predicts success from genre, platform, and era (`model_formulation.R`):

```r
model_success_full_without_publisher <- glm(
  Success ~ Genre + Gaming_System + Gaming_Era,
  data = df_model,
  family = binomial(link = "logit")
)
```

`Publisher` was tested and dropped — too many levels relative to observations per level, causing unstable estimates and overfitting.

**Secondary model** — ranks platform performance by era (`model_formulation.R`):

```r
success_model <- glm(
  Commercial_Success ~ Gaming_System + Gaming_Era,
  data = regression_data,
  family = binomial
)
```

Used to compare historical success probabilities of gaming systems across industry eras.

#### Test Predictions

**Primary model scenarios** (`test_main_fromula.R`) — 10 Genre × Platform combinations in the 2015+ era:

| Scenario | Predicted Success |
|---|---|
| Sports + XOne | 52.8% |
| Role-Playing + PS4 | 52.3% |
| Shooter + PS4 | 52.2% |
| Action + PS4 | 51.1% |
| Platform + Wii | 40.4% |
| Role-Playing + PC | 15.2% |

**Secondary model — top platforms by era** (`predictive_analysis_for_era.R`):

| Era | Top performers |
|---|---|
| Early Era | NES (96.9%), 2600 (96.7%), GB (92.4%) |
| 1995–1999 | GB (89.7%), WS (85.2%), N64 (70.0%) |
| 2000–2004 | GB (87.7%), WS (82.4%), PS2 (65.9%) |
| 2005–2009 | PS3 (69.4%), X360 (68.9%), Wii (57.3%) |
| 2010–2014 | XOne (67.4%), PS4 (67.3%), PS3 (65.1%) |
| 2015+ | XOne (67.4%), PS4 (67.3%) — interpret cautiously due to limited observations |

**Approach:** Descriptive Analytics → Identify patterns → Feature engineering → GLM models → Scenario forecasts → Business decision

---

## Key Findings Summary

| Area | Finding |
|---|---|
| **Market size** | Action has the largest total global sales volume |
| **Per-game performance** | Median sales vary substantially by genre |
| **Commercial success** | Platform (~60%), Sports (~59.7%), and Shooter (~57.7%) lead success rates |
| **Genre × Platform** | 8 high-performing combinations average ~2.63M sales vs. ~0.57M overall |
| **Sales distribution** | Heavily right-skewed — blockbusters dominate; Genre–Platform choice matters more than genre alone |
| **Regional markets** | North America and Europe dominate; NA ~49.4% of total sales |
| **Primary model** | Genre + Gaming System + Gaming Era predict commercial success; Publisher dropped |
| **2015+ predictions** | PS4 and XOne combinations reach ~51–53%; PC + Role-Playing lowest at ~15.2% |
| **Era dependency** | Platform performance is strongly era-dependent — different systems lead in different periods |

---

## Presentation & Documentation

- **`presentation-and-docs/Presentation Games Analytics Final.pptx`** — final analytics report covering business problem, dataset overview, feature engineering rationale, Phase A descriptive findings, Phase B GLM models (primary and secondary), test prediction results, and recommendations for Sonic Gaming Systems
- **`Strategic Game Publishing Decision Support Framework.docx`** (project root) — written decision-support framework document

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
  "carData",
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
# Phase 0 — Data Cleaning & Transformation
source("data-cleaning/1_data_cleaning_transformation.R")

# Phase A — Descriptive Analytics
source("descriptive-analytics/2_dataset_analysis.R")
source("descriptive-analytics/3_sales_analytics.R")
source("descriptive-analytics/4_commercial_success_by_sales.R")
source("descriptive-analytics/5_regional_sale_analysis.R")
source("descriptive-analytics/top_10.R")                    # optional

# Phase B — Predictive Analytics
source("predictive-analytics/model_formulation.R")
source("predictive-analytics/predictive_analysis_for_era.R")
source("predictive-analytics/test_main_fromula.R")          # optional — primary model scenarios
source("predictive-analytics/test_gaming_era_predictions.R") # optional — 2015+ platform rankings
```

> **Note:** Scripts depend on in-memory objects (`games_data`, `analysis_data`, `df_model`, `success_model`, etc.) from prior steps. Run them sequentially in the same R session with the working directory set to the project root.

---

## Scope & Limitations

This study is limited to historical sales data available in `games.csv`. It does **not** include:

- Production or development costs
- Player engagement or retention metrics
- Real-time market trends beyond the dataset's 2020 cutoff
- Customer sentiment beyond available critic/user scores

**Suggested extensions:**

- Genre × Gaming System × Era interaction terms for more granular predictions
- Region-specific predictive models for geographic launch optimization
- Time-series forecasting for emerging market trends
- Model comparison (GLM vs. decision trees) with formal performance metrics
- Incorporation of additional pre-launch variables

---

## License

This repository is for academic and analytical use. Refer to your institution's guidelines for data usage and attribution.
