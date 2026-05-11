# --- 0. Install and load necessary packages ---
if (!requireNamespace("wbstats", quietly = TRUE)) {
  install.packages("wbstats")
}
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
if (!requireNamespace("haven", quietly = TRUE)) {
  install.packages("haven") # For exporting to Stata .dta format
}
if (!requireNamespace("did", quietly = TRUE)) {
  install.packages("did") # For Difference-in-Differences analysis
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2") # For plotting
}
if (!requireNamespace("showtext", quietly = TRUE)) {
  install.packages("showtext") # For custom fonts
}
library(wbstats)
library(tidyverse)
library(haven) # Load haven for .dta export
library(did) # Load did for DID analysis
library(ggplot2) # Load ggplot2 for plotting
library(showtext) # Load showtext for custom fonts

# Add Google Fonts (e.g., Inter)
font_add_google("Inter", "inter")
showtext_auto() # Automatically use showtext for rendering text

# --- Set a higher timeout for internet connections ---
options(timeout = 300) # Sets timeout to 300 seconds (5 minutes)

# --- 1. Define Countries and Indicators ---

# EU accession countries (2004, 2007, 2013) + 10 never-EU comparator countries
all_countries <- c(
  # EU accession countries
  "CYP", "CZE", "EST", "HUN", "LVA", "LTU", "MLT", "POL", "SVK", "SVN", # 2004
  "BGR", "ROU", # 2007
  "HRV",        # 2013
  # Never-EU comparator countries
  "ALB", # Albania
  "BIH", # Bosnia & Herzegovina
  "MKD", # North Macedonia
  "MNE", # Montenegro
  "SRB", # Serbia
  "TUR", # Turkey
  "MDA", # Moldova
  "UKR", # Ukraine
  "BLR", # Belarus
  "GEO"  # Georgia
)

# World Bank indicator codes
indicators <- c(
  "NE.IMP.GNFS.ZS",   # Imports of goods and services (% of GDP)
  "NE.EXP.GNFS.ZS",   # Exports of goods and services (% of GDP)
  "NE.GDI.TOTL.ZS",   # Gross capital formation (% of GDP)
  "NY.GDP.MKTP.KD.ZG",# GDP growth (annual %)
  "FP.CPI.TOTL.ZG",   # Inflation, consumer prices (annual %)
  "SL.UEM.TOTL.ZS",   # Unemployment, total (% of total labor force) (modeled ILO estimate)
  "BN.CAB.XOKA.GD.ZS",# Current account balance (% of GDP)
  "PA.NUS.FCRF",      # Exchange rate, LCU per USD, period average
  "NE.CON.GOVT.ZS"    # Government final consumption expenditure (% of GDP)
)

# Direct mapping from World Bank descriptive names to R-compatible names
wb_to_clean_names_map <- c(
  "Imports of goods and services (% of GDP)" = "Imports",
  "Exports of goods and services (% of GDP)" = "Exports",
  "Gross capital formation (% of GDP)" = "Gross_Capital_Formation",
  "GDP growth (annual %)" = "GDP_Growth",
  "Inflation, consumer prices (annual %)" = "Inflation",
  "Unemployment, total (% of total labor force) (modeled ILO estimate)" = "Unemployment",
  "Current account balance (% of GDP)" = "Current_Account_Balance",
  "Official exchange rate (LCU per US$, period average)" = "Exchange_Rate_USD",
  "General government final consumption expenditure (% of GDP)" = "Government_Consumption"
)

# Define the time period
start_year <- 1995
end_year <- 2015

# --- 2. Fetch Data from World Bank ---

cat("Fetching data from World Bank for", length(all_countries), "countries and", length(indicators), "indicators...\n")

raw_data <- wb_data(
  country = all_countries,
  indicator = indicators,
  start_date = start_year,
  end_date = end_year,
  return_wide = FALSE
)

if (is.null(raw_data) || nrow(raw_data) == 0) {
  stop("Error: No data was fetched from the World Bank API. Please check your internet connection, country codes, indicator codes, and the specified date range.")
}

cat("Data fetched successfully. Number of rows:", nrow(raw_data), "\n")

cat("\nUnique indicator codes fetched by wb_data:\n")
print(unique(raw_data$indicator))

# --- 3. Clean and Transform Data ---

panel_data <- raw_data %>%
  select(iso3c, date, indicator, value) %>%
  pivot_wider(
    names_from = indicator,
    values_from = value
  ) %>%
  rename(
    country_id = iso3c,
    year = date
  ) %>%
  rename_with(~ wb_to_clean_names_map[.x], .cols = names(wb_to_clean_names_map)) %>%
  mutate(year = as.numeric(year)) %>%
  arrange(country_id, year)

cat("Data transformed to wide panel format and columns renamed for R compatibility.\n")
print(head(panel_data))

# --- 4. Add Accession Year, Treated, and Post Variables ---

# Updated: includes never-EU comparator countries with Inf as accession_year
accession_years_map <- tribble(
  ~country_id, ~accession_year,
  "CYP", 2004,
  "CZE", 2004,
  "EST", 2004,
  "HUN", 2004,
  "LVA", 2004,
  "LTU", 2004,
  "MLT", 2004,
  "POL", 2004,
  "SVK", 2004,
  "SVN", 2004,
  "BGR", 2007,
  "ROU", 2007,
  "HRV", 2013,
  # Never-EU comparator countries
  "ALB", Inf,
  "BIH", Inf,
  "MKD", Inf,
  "MNE", Inf,
  "SRB", Inf,
  "TUR", Inf,
  "MDA", Inf,
  "UKR", Inf,
  "BLR", Inf,
  "GEO", Inf
)

panel_data <- panel_data %>%
  left_join(accession_years_map, by = "country_id") %>%
  mutate(
    Treated = ifelse(year >= accession_year, 1, 0),
    Post = ifelse(year >= accession_year, 1, 0),
    id_numeric = as.numeric(factor(country_id)),
    Never_EU = ifelse(is.infinite(accession_year), 1, 0) # 1 if never joined EU
  )

cat("Added 'accession_year', 'Treated', 'Post', 'id_numeric', and 'Never_EU' variables.\n")
print(head(panel_data))

# --- 5. Save the data to a Stata .dta file ---
write_dta(panel_data, "eu_accession_panel_data.dta")
cat("Data saved to eu_accession_panel_data.dta in your working directory.\n")

