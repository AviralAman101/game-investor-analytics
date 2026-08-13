install.packages("car", dependencies = TRUE)
library(car)


regression_data <- analysis_data %>%
  filter(
    !is.na(Global_Sales),
    !is.na(Gaming_System),
    !is.na(Gaming_Era),
    !is.na(Commercial_Success)
  )

names(analysis_data)

df <- analysis_data



# Mode to get the top performing Systems in various eras
success_model <- glm(
  Commercial_Success ~ Gaming_System + Gaming_Era,
  data = regression_data,
  family = binomial
)



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
                 "Publisher", "Gaming_Era", "Rating")

df_model <- df[complete.cases(df[, model_cols]), model_cols]

nrow(df)
nrow(df_model)




# ============================================
# 3a. Full model — predicting Success (logistic GLM)
# ============================================
model_success_full <- glm(
  Success ~ Genre + Gaming_System + Publisher + Gaming_Era,
  data = df_model,
  family = binomial(link = "logit")
)
Anova(model_success_full, type = "II", test.statistic = "LR")

summary(model_success_full)

# Dropped Publisher
model_success_full_without_publisher <- glm(
  Success ~ Genre + Gaming_System + Gaming_Era,
  data = df_model,
  family = binomial(link = "logit")
)


install.packages("carData")

summary(model_success_full)
Anova(model_success_full_without_publisher, type = "II", test.statistic = "LR")

anova(model_success_full, model_success_full_without_publisher, test = "Chisq")

