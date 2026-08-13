
# ============================================================
# 1. BASIC DATASET STATISTICS
# ============================================================
cat("Number of games:", nrow(analysis_data), "\n")

cat(
  "Number of genres:",
  length(unique(analysis_data$Genre)),
  "\n"
)

cat(
  "Number of Gaming_System:",
  length(unique(analysis_data$Gaming_System)),
  "\n"
)

cat(
  "Number of publishers:",
  length(unique(analysis_data$Publisher)),
  "\n"
)

cat(
  "Earliest year:",
  min(analysis_data$Year_of_Release, na.rm = TRUE),
  "\n"
)

class(analysis_data$Year_of_Release)
str(analysis_data$Year_of_Release)

cat(
  "Latest year:",
  max(analysis_data$Year_of_Release, na.rm = TRUE),
  "\n"
)


genre_summary <- analysis_data %>%
  group_by(Genre) %>%
  summarise(
    Number_of_Games = n(),
    Total_Global_Sales =
      sum(Global_Sales, na.rm = TRUE),
    Average_Global_Sales =
      mean(Global_Sales, na.rm = TRUE),
    Median_Global_Sales =
      median(Global_Sales, na.rm = TRUE)
  ) %>%
  arrange(desc(Average_Global_Sales))

print(genre_summary)



ggplot(
  genre_summary,
  aes(
    x = reorder(Genre, Number_of_Games),
    y = Number_of_Games
  )
) +
  geom_col() +
  geom_text(
    aes(label = Number_of_Games),
    hjust = -0.1
  ) +
  coord_flip() +
  labs(
    title = "Number of Games by Genre",
    x = "Genre",
    y = "Number of Games"
  ) +
  theme_minimal() +
  expand_limits(
    y = max(genre_summary$Number_of_Games) * 1.1
  )




Gaming_System_summary <- analysis_data %>%
  filter(
    !is.na(Gaming_System),
    Gaming_System != ""
  ) %>%
  group_by(Gaming_System) %>%
  summarise(
    Number_of_Games = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Number_of_Games))

Gaming_System_summary

library(ggplot2)

ggplot(
  Gaming_System_summary,
  aes(
    x = reorder(Gaming_System, Number_of_Games),
    y = Number_of_Games
  )
) +
  geom_segment(
    aes(
      xend = reorder(Gaming_System, Number_of_Games),
      y = 0,
      yend = Number_of_Games
    )
  ) +
  geom_point(size = 3) +
  geom_text(
    aes(label = Number_of_Games),
    vjust = -0.7,
    size = 3
  ) +
  labs(
    title = "Number of Games by Gaming_System",
    x = "Gaming_System",
    y = "Number of Games"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )