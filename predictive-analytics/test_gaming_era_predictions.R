new_games_data <- data.frame(
  Gaming_System = c(
    "PS4",
    "XOne",
    "X360",
    "PS3",
    "PS2",
    "Wii",
    "WiiU",
    "PC",
    "2600",
    "PSV",
    "DS",
    "GB"
  ),
  Gaming_Era = "2015+"
)

new_games_data


new_games_data$Predicted_Success <- predict(
  success_model,
  newdata = new_games_data,
  type = "response"
)

new_games_data$Success_Percentage <- 
  round(new_games_data$Predicted_Success * 100, 1)

new_games_data