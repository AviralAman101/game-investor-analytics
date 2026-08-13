names(games_data)

df <- games_data


# ============================================
# 1. Create Success column (0/1) from Global_Sales
# ============================================
threshold <- median(df$Global_Sales, na.rm = TRUE)
df$Success <- ifelse(df$Global_Sales > threshold, 1, 0)

table(df$Success)  # check class balance

# ============================================
# 2. Keep only pre-release predictors + outcome columns
# ============================================

model_cols <- c("Success", "Global_Sales", "Genre", "Gaming_System",
                 "Publisher", "Year_of_Release", "Rating")

df_model <- df[complete.cases(df[, model_cols]), model_cols]

nrow(df)
nrow(df_model)




# ============================================
# 3a. Full model — predicting Success (logistic GLM)
# ============================================
model_success_full <- glm(
  Success ~ Genre + Gaming_System + Publisher + Year_of_Release + Rating,
  data = df_model,
  family = binomial(link = "logit")
)
Anova(model_success_full, type = "II", test.statistic = "LR")

test_df <- 

summary(model_success_full)

# Dropped Publisher and Rating
model_success_full <- glm(
  Success ~ Genre + Gaming_System + Year_of_Release,
  data = df_model,
  family = binomial(link = "logit")
)


install.packages("carData")

summary(model_success_full)
install.packages("car", dependencies = TRUE)
library(car)
Anova(model_success_full, type = "II", test.statistic = "LR")

model_no_genre <- glm(
  Success ~ Gaming_System + Year_of_Release,
  data = df_model,
  family = binomial(link = "logit")
)


anova(model_no_genre, model_success_full, test = "Chisq")

