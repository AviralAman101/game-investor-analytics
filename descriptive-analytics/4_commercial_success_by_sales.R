
# ============================================================
# COMMERCIAL SUCCESS CLASSIFICATION
# ============================================================

sales_threshold <- median(
  analysis_data$Global_Sales,
  na.rm = TRUE
)

sales_threshold

cat(
  "Commercial success threshold:",
  sales_threshold,
  "million units\n"
)


analysis_data$Commercial_Success <- ifelse(
  analysis_data$Global_Sales >= sales_threshold,
  "Successful",
  "Not Successful"
)

analysis_data$Commercial_Success <- as.factor(
  analysis_data$Commercial_Success
)

table(analysis_data$Commercial_Success)


# Calcuate no of games by each Genre that are above Median sales 
#and get it as a percentage of total games in the Genre
genre_summary %>%
  arrange(desc(Median_Global_Sales))

genre_success <- analysis_data %>%
  group_by(Genre) %>%
  summarise(
    Number_of_Games = n(),
    Successful_Games = sum(
      Commercial_Success == "Successful",
      na.rm = TRUE
    ),
    Success_Rate = mean(
      Commercial_Success == "Successful",
      na.rm = TRUE
    ) * 100
  ) %>%
  arrange(desc(Success_Rate))

genre_success


# Success Rate Graph

ggplot(
  genre_success %>%
    filter(Genre != ""),
  aes(
    x = reorder(Genre, Success_Rate),
    y = Success_Rate
  )
) +
  geom_col() +
  geom_text(
    aes(label = round(Success_Rate, 2)),
    hjust = -0.1
  ) +
  coord_flip() +
  labs(
    title = "Commercial Success Rate by Genre",
    x = "Genre",
    y = "Successful Games (%)"
  ) +
  theme_minimal()



# Tree for Gaming_system x Genre comparison


# Grop genre X Gaming_system
genre_Gaming_System_data <- analysis_data %>%
  filter(
    !is.na(Genre),
    Genre != "",
    !is.na(Gaming_System),
    Gaming_System != "",
    !is.na(Global_Sales),
    !is.na(Commercial_Success)
  ) %>%
  group_by(Genre, Gaming_System) %>%
  summarise(
    Number_of_Games = n(),
    Total_Global_Sales = sum(Global_Sales, na.rm = TRUE),
    Average_Global_Sales = mean(Global_Sales, na.rm = TRUE),
    Median_Global_Sales = median(Global_Sales, na.rm = TRUE),
    Success_Rate = mean(
      Commercial_Success == "Successful"
    ) * 100,
    .groups = "drop"
  ) %>%
  filter(Number_of_Games >= 10)

head(genre_Gaming_System_data, 20)
nrow(genre_Gaming_System_data)


overall_median <- median(
  analysis_data$Global_Sales,
  na.rm = TRUE
)

overall_median



# Calculate Sale Band
genre_Gaming_System_data <- genre_Gaming_System_data %>%
  mutate(
    Sales_vs_Median =
      Average_Global_Sales / overall_median
  )
genre_Gaming_System_data

genre_Gaming_System_data <- genre_Gaming_System_data %>%
  mutate(
    Sales_Band = cut(
      Sales_vs_Median,
      breaks = c(
        -Inf,
        0.20,
        0.30,
        0.50,
        0.80,
        1.00,
        Inf
      ),
      labels = c(
        "<20% Median",
        "20–30% Median",
        "30–50% Median",
        "50–80% Median",
        "80–100% Median",
        ">100% Median"
      )
    )
  )


# Plot Tree
library(rpart.plot)


sales_tree <- rpart(
  Average_Global_Sales ~ Genre + Gaming_System,
  data = genre_Gaming_System_data,
  method = "anova",
  control = rpart.control(
    cp = 0.01,
    minsplit = 10,
    minbucket = 5,
    maxdepth = 5
  )
)

rpart.plot(
  sales_tree,
  type = 2,
  extra = 101,
  fallen.leaves = TRUE,
  main = "Genre × genre_Gaming_System_data — Expected Global Sales"
)





sales_tree$frame[, c("var", "n", "yval")]

tree_frame$node_id <- as.numeric(rownames(tree_frame))

node_8_row <- which(sales_tree$frame$n == 8)

node_8_row
terminal_nodes <- sales_tree$where

n8_data <- genre_Gaming_System_data[
  terminal_nodes == node_8_row,
]

n8_data

nrow(n8_data)


node_8_row <- which(
  sales_tree$frame$n == 8 &
  sales_tree$frame$var == "<leaf>"
)

n8_data <- genre_Gaming_System_data[
  sales_tree$where == node_8_row,
]

n8_data

n8_data %>%
  select(
    Genre,
    Gaming_System,
    Number_of_Games,
    Total_Global_Sales,
    Average_Global_Sales,
    Median_Global_Sales,
    Success_Rate
  ) %>%
  arrange(desc(Average_Global_Sales))