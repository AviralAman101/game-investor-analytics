# ============================================
# 1. Gamma GLM — predicting Global_Sales
# ============================================
library(car)

model_sales_full <- glm(
  Global_Sales ~ Genre + Gaming_System + Year_of_Release,
  data   = df_model,
  family = Gamma(link = "log")
)

summary(model_sales_full)

# ============================================
# 2. Test whether Genre is significant (nested model comparison)
# ============================================
model_no_genre_sales <- update(model_sales_full, . ~ . - Genre)

anova(model_no_genre_sales, model_sales_full, test = "Chisq")

# Optional: full variable-by-variable table using car::Anova
Anova(model_sales_full, type = "II", test.statistic = "LR")