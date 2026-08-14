
#install.packages("tidyverse")
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("caret")
#install.packages("corrplot")
#install.packages("prodlim")

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

games_data$Year_of_Release <- as.numeric(games_data$Year_of_Release)

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

# Since none of the columns which are used in ML models are empty or null, 
# so we do not eliminate null variables

# ============================================================
# 4. DUPLICATE ANALYSIS
# ============================================================

duplicate_rows <- sum(duplicated(games_data))

cat("Number of duplicate rows:", duplicate_rows, "\n")
# 0 duplicates

games_data <- games_data %>% distinct()

cat(
  "Rows after removing duplicates:",
  nrow(games_data),
  "\n"
)




analysis_data <- games_data


analysis_data <- analysis_data %>%
  filter(
    !is.na(Global_Sales),
    !is.na(Genre) & Genre != "",
    !is.na(Gaming_System) & Gaming_System != "",
    !is.na(Year_of_Release),
    !is.na(Publisher) & Publisher != ""
  )

dim(analysis_data)
# [number of rows, number of columns]
# [1] a    18

### Data cleaning done


##Start Transformation

#Encode and transoform 

#Encode existing columns
analysis_data$Genre <- as.factor(analysis_data$Genre)

analysis_data$Gaming_System <- as.factor(analysis_data$Gaming_System)
analysis_data$Publisher <- as.factor(analysis_data$Publisher)
analysis_data$Rating <- as.factor(analysis_data$Rating)



sales_threshold <- median(analysis_data$Global_Sales)

sales_threshold

analysis_data$Commercial_Success <- ifelse(
  analysis_data$Global_Sales >= sales_threshold,
  "Successful",
  "Not Successful"
)



# games_data <- games_data %>%
#   mutate(
#     Commercial_Success = ifelse(
#       Global_Sales >= 0.17,
#       "Successful",
#       "Not Successful"
#     )
#   )


analysis_data$Commercial_Success <- factor(
  analysis_data$Commercial_Success,
  levels = c("Not Successful", "Successful")
)

head(analysis_data)

table(analysis_data$Commercial_Success)



analysis_data <- analysis_data %>%
  mutate(
    Gaming_Era = case_when(
      Year_of_Release < 1995 ~ "Early Era",
      Year_of_Release < 2000 ~ "1995-1999",
      Year_of_Release < 2005 ~ "2000-2004",
      Year_of_Release < 2010 ~ "2005-2009",
      Year_of_Release < 2015 ~ "2010-2014",
      TRUE ~ "2015+"
    )
  )


analysis_data$Gaming_Era <- factor(
  analysis_data$Gaming_Era,
  levels = c("Early Era", "1995-1999", "2000-2004", "2005-2009", "2010-2014")
)