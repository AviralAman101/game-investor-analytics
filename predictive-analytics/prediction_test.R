# ============================================
# New data frame for prediction only
# ============================================
new_games <- data.frame(
  Name            = c("Game_A", "Game_B", "Game_C", "Game_D"),
  Gaming_System   = c("PS4", "Switch", "PC", "Xbox360"),
  Year_of_Release = c(2021, 2022, 2020, 2019),
  Genre           = c("Shooter", "RPG", "Puzzle", "Sports"),
  Publisher       = c("Activision", "Nintendo", "EA", "Ubisoft"),
  stringsAsFactors = FALSE
)

new_games

# ============================================
# Predict success probability using model_success
# ============================================
new_games$Predicted_Prob    <- predict(model_success, newdata = new_games, type = "response")
new_games$Predicted_Success <- ifelse(new_games$Predicted_Prob > 0.5, "Success", "Not Success")

new_games


