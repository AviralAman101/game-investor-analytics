# ============================================================
# 7. ANALYTICAL DATASET
# ============================================================

library(dplyr)
library(tidyverse) 
library(ggplot2)



# Average Sales Chart
ggplot(
  genre_summary %>%
    filter(Genre != ""),
  aes(
    x = reorder(Genre, Average_Global_Sales),
    y = Average_Global_Sales
  )
) +
  geom_col() +
  geom_text(
    aes(label = round(Average_Global_Sales, 2)),
    hjust = -0.2
  ) 
  coord_flip() +
  labs(
    title = "Average Global Sales by Genre",
    x = "Genre",
    y = "Average Global Sales (Millions)"
  ) +
  theme_minimal()


# Total Sales Chart
ggplot(
  genre_summary %>%
    filter(Genre != ""),
  aes(
    x = reorder(Genre, Total_Global_Sales),
    y = Total_Global_Sales
  )
) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Total Global Sales by Genre",
    x = "Genre",
    y = "Total Global Sales (Millions)"
  ) +
  theme_minimal()


genre_summary <- analysis_data %>%
  group_by(Genre) %>%
  summarise(
    Number_of_Games = n(),
    Total_Global_Sales = sum(
      Global_Sales,
      na.rm = TRUE
    ),
    Average_Global_Sales = mean(
      Global_Sales,
      na.rm = TRUE
    ),
    Median_Global_Sales = median(
      Global_Sales,
      na.rm = TRUE
    )
  ) %>%
  arrange(desc(Average_Global_Sales))

(genre_summary)


#Median Sales Chart
ggplot(
  genre_summary %>%
    filter(Genre != ""),
  aes(
    x = reorder(Genre, Median_Global_Sales),
    y = Median_Global_Sales
  )
) +
  geom_col() +
  geom_text(
    aes(label = round(Median_Global_Sales, 2)),
    hjust = -0.1
  ) +
  coord_flip() +
  labs(
    title = "Median Global Sales by Genre",
    x = "Genre",
    y = "Median Global Sales (Millions)"
  ) +
  theme_minimal()
