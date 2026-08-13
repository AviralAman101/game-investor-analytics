
# install.packages("tidyverse")
# install.packages("rpart")
# install.packages("rpart.plot")
# install.packages("caret")
# install.packages("corrplot")

# Load libraries
library(tidyverse)
library(rpart)
library(rpart.plot)
library(caret)
library(corrplot)
library(dplyr)

games_data <- read.csv(
  "./games.csv",
  stringsAsFactors = FALSE
)

head(games_data)
str(games_data)
names(games_data)
dim(games_data)

missing_count <- colSums(is.na(games_data))

missing_percentage <- 
  colSums(is.na(games_data)) / nrow(games_data) * 100

missing_summary <- data.frame(
  Column = names(games_data),
  Missing_Count = missing_count,
  Missing_Percentage = round(missing_percentage, 2)
)

missing_summary <- missing_summary %>%
  arrange(desc(Missing_Percentage))

print(missing_summary)

# ============================================================
# 4. DUPLICATE ANALYSIS
# ============================================================

duplicate_rows <- sum(duplicated(games_data))

cat("Number of duplicate rows:", duplicate_rows, "\n")

games_data <- games_data %>% distinct()

cat(
  "Rows after removing duplicates:",
  nrow(games_data),
  "\n"
)

# ============================================================
# 5. CHECK USER SCORE
# ============================================================

unique(games_data$User_Score)

games_data$User_Score[
  games_data$User_Score == "tbd"
] <- NA

games_data$User_Score <- as.numeric(
  games_data$User_Score
)

numeric_columns <- c(
  "Year_of_Release",
  "NA_Sales",
  "EU_Sales",
  "JP_Sales",
  "Other_Sales",
  "Global_Sales",
  "Critic_Score",
  "Critic_Count",
  "User_Count"
)

games_data[numeric_columns] <- lapply(
  games_data[numeric_columns],
  as.numeric
)

unique(games_data$User_Score)

str(games_data)

### Data cleaning done


##Start Transformation


analysis_data <- games_data


analysis_data <- analysis_data %>%
  filter(
    !is.na(Global_Sales),
    !is.na(Genre),
    !is.na(Gaming_System)
  )

dim(analysis_data)


analysis_data$Commercial_Success <- ifelse(
  analysis_data$Global_Sales >= sales_threshold,
  "Successful",
  "Not Successful"
)
