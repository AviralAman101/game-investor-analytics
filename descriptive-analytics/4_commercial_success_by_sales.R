
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


# library(ggplot2)

# ggplot(
#   genre_summary %>%
#     filter(Genre != ""),
#   aes(
#     x = reorder(Genre, Total_Global_Sales),
#     y = Total_Global_Sales
#   )
# ) +
#   geom_col() +
#   coord_flip() +
#   labs(
#     title = "Total Global Sales by Genre",
#     x = "Genre",
#     y = "Total Global Sales (Millions)"
#   ) +
#   theme_minimal()

# ggplot(
#   genre_summary %>%
#     filter(Genre != ""),
#   aes(
#     x = reorder(Genre, Average_Global_Sales),
#     y = Average_Global_Sales
#   )
# ) +
#   geom_col() +
#   coord_flip() +
#   labs(
#     title = "Average Global Sales per Game by Genre",
#     x = "Genre",
#     y = "Average Global Sales (Millions)"
#   ) +
#   theme_minimal()


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



genre_platform_data <- analysis_data %>%
  filter(
    !is.na(Genre),
    Genre != "",
    !is.na(Platform),
    Platform != "",
    !is.na(Global_Sales),
    !is.na(Commercial_Success)
  ) %>%
  group_by(Genre, Platform) %>%
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

head(genre_platform_data, 20)
nrow(genre_platform_data)


overall_median <- median(
  analysis_data$Global_Sales,
  na.rm = TRUE
)

overall_median

genre_platform_data <- genre_platform_data %>%
  mutate(
    Sales_vs_Median =
      Average_Global_Sales / overall_median
  )
genre_platform_data

genre_platform_data <- genre_platform_data %>%
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
library(rpart.plot)
sales_tree <- rpart(
  Average_Global_Sales ~ Genre + Platform,
  data = genre_platform_data,
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
  main = "Genre × Platform — Expected Global Sales"
)