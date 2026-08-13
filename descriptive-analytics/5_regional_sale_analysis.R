install.packages("knitr")
install.packages("kableExtra")
library(knitr)
library(kableExtra)
install.packages("flextable")

library(flextable)
install.packages("flextable", dependencies = TRUE)
install.packages("openssl")
library(ggplot2)

regional_summary <- data.frame(
  Region = c(
    "North America",
    "Europe",
    "Japan",
    "Other"
  ),
  Total_Sales = c(
    sum(analysis_data$NA_Sales, na.rm = TRUE),
    sum(analysis_data$EU_Sales, na.rm = TRUE),
    sum(analysis_data$JP_Sales, na.rm = TRUE),
    sum(analysis_data$Other_Sales, na.rm = TRUE)
  ),
  Average_Sales = c(
    mean(analysis_data$NA_Sales, na.rm = TRUE),
    mean(analysis_data$EU_Sales, na.rm = TRUE),
    mean(analysis_data$JP_Sales, na.rm = TRUE),
    mean(analysis_data$Other_Sales, na.rm = TRUE)
  ),
  Median_Sales = c(
    median(analysis_data$NA_Sales, na.rm = TRUE),
    median(analysis_data$EU_Sales, na.rm = TRUE),
    median(analysis_data$JP_Sales, na.rm = TRUE),
    median(analysis_data$Other_Sales, na.rm = TRUE)
  )
)



regional_summary$Market_Share <- 
  regional_summary$Total_Sales /
  sum(regional_summary$Total_Sales) * 100

regional_summary






# Bar chart total sales we need to replace this with pie chart

ggplot(
  regional_summary,
  aes(
    x = "",
    y = Total_Sales,
    fill = Region
  )
) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  geom_text(
    aes(
      label = paste0(
        round(Market_Share, 1),
        "%"
      )
    ),
    position = position_stack(vjust = 0.5)
  ) +
  labs(
    title = "Regional Share of Total Global Sales",
    fill = "Geographic Market"
  ) +
  theme_void()


ggplot(
  regional_summary,
  aes(
    x = reorder(Region, Average_Sales),
    y = Average_Sales
  )
) +
  geom_col() +
  geom_text(
    aes(
      label = paste0(
        round(Average_Sales, 3),
        "M"
      )
    ),
    hjust = -0.1
  ) +
  coord_flip() +
  labs(
    title = "Average Sales per Game by Geographic Market",
    x = "Geographic Market",
    y = "Average Sales (Millions)"
  ) +
  theme_minimal() +
  expand_limits(
    y = max(regional_summary$Average_Sales) * 1.1
  )


genre_region_summary <- analysis_data %>%
  filter(
    !is.na(Genre),
    Genre != ""
  ) %>%
  group_by(Genre) %>%
  summarise(
    NA_Sales = sum(NA_Sales, na.rm = TRUE),
    EU_Sales = sum(EU_Sales, na.rm = TRUE),
    JP_Sales = sum(JP_Sales, na.rm = TRUE),
    Other_Sales = sum(Other_Sales, na.rm = TRUE),
    .groups = "drop"
  )

genre_region_summary

genre_region_summary$Priority_Market <- apply(
  genre_region_summary[, c(
    "NA_Sales",
    "EU_Sales",
    "JP_Sales",
    "Other_Sales"
  )],
  1,
  function(x) {
    names(x)[which.max(x)]
  }
)

genre_region_summary

priority_market_summary <- genre_region_summary %>%
  count(Priority_Market) %>%
  arrange(desc(n))

priority_market_summary


# library(tidyr)
# library(ggplot2)

# genre_region_long <- genre_region_summary %>%
#   select(
#     Genre,
#     NA_Sales,
#     EU_Sales,
#     JP_Sales,
#     Other_Sales
#   ) %>%
#   pivot_longer(
#     cols = c(
#       NA_Sales,
#       EU_Sales,
#       JP_Sales,
#       Other_Sales
#     ),
#     names_to = "Region",
#     values_to = "Sales"
#   )

# ggplot(
#   genre_region_long,
#   aes(
#     x = Region,
#     y = Genre,
#     fill = Sales
#   )
# ) +
#   geom_tile() +
#   geom_text(
#     aes(label = round(Sales, 1))
#   ) +
#   labs(
#     title = "Genre-wise Regional Sales",
#     x = "Geographic Market",
#     y = "Genre",
#     fill = "Sales (M)"
#   ) +
#   theme_minimal()