# ============================================
# Final models (confirmed)
# ============================================
model_success_full <- glm(
  Success ~ Genre + Gaming_System + Year_of_Release,
  data = df_model, family = binomial(link = "logit")
)

model_sales_full <- glm(
  Global_Sales ~ Genre + Gaming_System + Year_of_Release,
  data = df_model, family = Gamma(link = "log")
)

# ============================================
# 10 hypothetical test games
# ============================================
test_games <- data.frame(
  Name            = paste0("TestGame_", 1:10),
  Genre           = c("Racing", "Shooter", "Simulation", "Sports", "Platform",
                       "Racing", "Adventure", "Strategy", "Fighting", "Simulation"),
  Gaming_System   = c("PS4", "X360", "GBA", "PS3", "GB",
                       "Wii", "XOne", "PS2", "3DS", "Wii"),
  Year_of_Release = rep(2019, 10)
)

test_games$Predicted_Sales        <- predict(model_sales_full, newdata = test_games, type = "response")
test_games$Predicted_Success_Prob <- predict(model_success_full, newdata = test_games, type = "response")
test_games$Predicted_Success      <- ifelse(test_games$Predicted_Success_Prob > 0.5, "Success", "Not Success")
(df_model$Gaming_System)
test_games