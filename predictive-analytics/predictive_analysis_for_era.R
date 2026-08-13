
library(dplyr)
library(ggplot2)

games_data <- games_data %>%
  mutate(
    Commercial_Success = ifelse(
      Global_Sales >= 0.17,
      "Successful",
      "Not Successful"
    )
  )


games_data$Commercial_Success <- factor(
  games_data$Commercial_Success,
  levels = c("Not Successful", "Successful")
)

table(games_data$Commercial_Success)



games_data <- games_data %>%
  mutate(
    Gaming_Era = case_when(
      Year_of_Release < 1995 ~ "Early Era",
      Year_of_Release < 2000 ~ "1995-1999",
      Year_of_Release < 2005 ~ "2000-2004",
      Year_of_Release < 2010 ~ "2005-2009",
      Year_of_Release < 2015 ~ "2010-2014",
      TRUE ~ "2015+"
    )
  )


regression_data <- games_data %>%
  filter(
    !is.na(Global_Sales),
    !is.na(Gaming_System),
    !is.na(Gaming_Era),
    !is.na(Commercial_Success)
  )

scenario_data <- regression_data %>%
distinct(Gaming_System, Gaming_Era)

scenario_data

scenario_data <- scenario_data %>%
  mutate(
    Success_Probability = predict(
      success_model,
      newdata = scenario_data,
      type = "response"
    ),
    Success_Percentage = Success_Probability * 100
  )

head(scenario_data)
success_model <- glm(
  Commercial_Success ~ Gaming_System + Gaming_Era,
  data = regression_data,
  family = binomial
)




scenario_table <- scenario_data %>%
  mutate(
    Success_Percentage = round(Success_Percentage, 1)
  ) %>%
  select(
    Gaming_System,
    Gaming_Era,
    Success_Percentage
  ) %>%
  tidyr::pivot_wider(
    names_from = Gaming_Era,
    values_from = Success_Percentage,
    values_fill = NA
  )


scenario_table <- scenario_table %>%
  mutate(
    across(
      -Gaming_System,
      ~ ifelse(is.na(.), "-", paste0(.,"%"))
    )
  )


scenario_table

print(scenario_table, n = Inf)


top5_by_era <- scenario_data %>%
  arrange(Gaming_Era, desc(Success_Percentage)) %>%
  group_by(Gaming_Era) %>%
  slice_head(n = 5) %>%
  ungroup() %>%
  select(
    Gaming_Era,
    Gaming_System,
    Success_Percentage
  )

top5_by_era

print(top5_by_era, n = Inf)

