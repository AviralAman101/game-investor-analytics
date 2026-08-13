# ============================================
# 1. Create a sample data frame
# ============================================
set.seed(42)

n <- 500

genres     <- c("Action", "Sports", "Shooter", "RPG", "Racing", "Puzzle")
systems    <- c("PS4", "Xbox360", "PC", "Switch", "Wii", "PS3")
publishers <- c("EA", "Activision", "Nintendo", "Ubisoft", "Sony", "Take-Two")

df <- data.frame(
  Name             = paste0("Game_", 1:n),
  Gaming_System    = sample(systems, n, replace = TRUE),
  Year_of_Release  = sample(2000:2020, n, replace = TRUE),
  Genre            = sample(genres, n, replace = TRUE),
  Publisher        = sample(publishers, n, replace = TRUE),
  stringsAsFactors = FALSE
)

# Simulate Global_Sales with some genre/publisher effect + right skew
genre_effect <- c(Action = 1.5, Sports = 1.2, Shooter = 1.8,
                   RPG = 1.0, Racing = 0.8, Puzzle = 0.4)
pub_effect   <- c(EA = 1.3, Activision = 1.4, Nintendo = 1.6,
                   Ubisoft = 1.0, Sony = 1.1, `Take-Two` = 1.2)

base_rate <- genre_effect[df$Genre] * pub_effect[df$Publisher]
df$Global_Sales <- round(rgamma(n, shape = 2, rate = 2 / base_rate), 2)

head(df)

# ============================================
# 2. Train/test split
# ============================================
train_idx <- sample(seq_len(n), size = 0.8 * n)
train <- df[train_idx, ]
test  <- df[-train_idx, ]

# ============================================
# 3a. Regression: predict actual sales (Gamma GLM)
# ============================================
model_sales <- glm(
  Global_Sales ~ Genre + Gaming_System + Publisher + Year_of_Release,
  data   = train,
  family = Gamma(link = "log")
)

summary(model_sales)

test$Predicted_Sales <- predict(model_sales, newdata = test, type = "response")

# Check accuracy: RMSE
rmse <- sqrt(mean((test$Global_Sales - test$Predicted_Sales)^2))
cat("RMSE (Sales prediction):", round(rmse, 3), "\n")

head(test[, c("Name", "Genre", "Publisher", "Global_Sales", "Predicted_Sales")])

# ============================================
# 3b. Classification: predict "success" (logistic GLM)
# ============================================
# Define success threshold — e.g. above median sales
threshold <- median(df$Global_Sales)
train$Success <- ifelse(train$Global_Sales > threshold, 1, 0)
test$Success  <- ifelse(test$Global_Sales > threshold, 1, 0)

model_success <- glm(
  Success ~ Genre + Gaming_System + Publisher + Year_of_Release,
  data   = train,
  family = binomial(link = "logit")
)

summary(model_success)

test$Predicted_Prob    <- predict(model_success, newdata = test, type = "response")
test$Predicted_Success <- ifelse(test$Predicted_Prob > 0.5, 1, 0)

# Accuracy
accuracy <- mean(test$Predicted_Success == test$Success)
cat("Classification Accuracy:", round(accuracy * 100, 1), "%\n")

# Confusion matrix
table(Predicted = test$Predicted_Success, Actual = test$Success)

# ============================================
# 4. Predict on a brand-new unseen game
# ============================================
new_game <- data.frame(
  Name            = "Mystery_Game_X",
  Gaming_System   = "PS4",
  Year_of_Release = 2021,
  Genre           = "Shooter",
  Publisher       = "Activision"
)

predicted_sales_new <- predict(model_sales, newdata = new_game, type = "response")
predicted_prob_new  <- predict(model_success, newdata = new_game, type = "response")

cat("Predicted Global Sales:", round(predicted_sales_new, 2), "million\n")
cat("Predicted Success Probability:", round(predicted_prob_new * 100, 1), "%\n")