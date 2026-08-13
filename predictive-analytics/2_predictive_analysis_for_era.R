
library(dplyr)
library(ggplot2)

head(analysis_data)


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

