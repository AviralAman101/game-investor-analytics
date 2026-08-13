
# ============================================================
# 1. BASIC DATASET STATISTICS
# ============================================================
analysis_data <- games_data
cat("Number of games:", nrow(games_data), "\n")

cat(
  "Number of genres:",
  length(unique(games_data$Genre)),
  "\n"
)

cat(
  "Number of Gaming_System:",
  length(unique(games_data$Gaming_System)),
  "\n"
)

cat(
  "Number of publishers:",
  length(unique(games_data$Publisher)),
  "\n"
)

cat(
  "Number of developers:",
  length(unique(games_data$Developer)),
  "\n"
)

cat(
  "Earliest year:",
  min(games_data$Year, na.rm = TRUE),
  "\n"
)

cat(
  "Latest year:",
  max(games_data$Year, na.rm = TRUE),
  "\n"
)


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