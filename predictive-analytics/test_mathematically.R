# test_games <- data.frame(
#   Genre = c("Fighting", "Platform", "Sports", "Shooter", "Role-Playing"),
#   Gaming_System = c("PS3", "PS4", "GB", "X360", "PC"),
#   Gaming_Era = c("2005-2009", "2010-2014", "1995-1999", "2005-2009", "2015+")
# )

test_games <- data.frame(
  Genre = c("Fighting"),
  Gaming_System = c("PS3"),
  Gaming_Era = c("2005-2009")
)

test_games


coef_table <- summary(model_success_full_without_publisher)$coefficients

coef_table

get_relevant_coefficients <- function(model, newdata) {
  
  coefficients <- coef(model)
  
  relevant <- c("(Intercept)")
  
  for (i in 1:nrow(newdata)) {
    
    genre_coef <- paste0("Genre", newdata$Genre[i])
    system_coef <- paste0("Gaming_System", newdata$Gaming_System[i])
    era_coef <- paste0("Gaming_Era", newdata$Gaming_Era[i])
    
    relevant <- c(
      relevant,
      genre_coef,
      system_coef,
      era_coef
    )
  }
  
  coefficients[
    names(coefficients) %in% relevant
  ]
}


relevant_coefficients <- get_relevant_coefficients(
  model_success_full_without_publisher,
  test_games[1, ]
)
relevant_coefficients
z_val <- 
  relevant_coefficients["(Intercept)"] +
  relevant_coefficients["GenreFighting"] +
  relevant_coefficients["Gaming_SystemPS3"] +
  relevant_coefficients["Gaming_Era2005-2009"]

z_val # 0.6928

success_probability <- 1 / (1 + exp(-z_val))

success_percentage <- success_probability * 100

success_probability
success_percentage


model_probability <- predict(
  model_success_full_without_publisher,
  newdata = test_games[1, ],
  type = "response"
)

model_probability
#0.6928