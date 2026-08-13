
# ============================================================
# 1. BASIC DATASET STATISTICS
# ============================================================

cat("Number of games:", nrow(games_data), "\n")

cat(
  "Number of genres:",
  length(unique(games_data$Genre)),
  "\n"
)

cat(
  "Number of platforms:",
  length(unique(games_data$Platform)),
  "\n"
)

cat(
  "Number of publishers:",
  length(unique(games_data$Publisher)),
  "\n"
)

cat(
  "Number of developers:",
  length(unique(games_data$Developer)),
  "\n"
)

cat(
  "Earliest year:",
  min(games_data$Year, na.rm = TRUE),
  "\n"
)

cat(
  "Latest year:",
  max(games_data$Year, na.rm = TRUE),
  "\n"
)