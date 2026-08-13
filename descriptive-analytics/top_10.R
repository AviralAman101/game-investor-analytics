top_10_games <- games_data %>%
  filter(
    !is.na(Global_Sales),
    !is.na(Name),
    !is.na(Genre),
    !is.na(Gaming_System)
  ) %>%
  arrange(desc(Global_Sales)) %>%
  slice_head(n = 10)

top_10_games