# ============================================================
# Data Collection: EU Accession DiD Study
# Author: Maanit Mehta
# MSc Financial Modelling & Investment, University of Glasgow
# Supervisor: Dr. Sisir Ramanan
# Description: Pulls macroeconomic panel data from World Bank
#              WDI API for 23 countries (1995-2022)
# ============================================================

if (!require("WDI")) install.packages("WDI")
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("haven")) install.packages("haven")

library(WDI)
library(dplyr)
library(tidyr)
library(haven)

# ── Country sample ───────────────────────────────────────────
treated_2004 <- c("CY","CZ","EE","HU","LV","LT","MT","PL","SK","SI")
treated_2007 <- c("BG","RO")
treated_2013 <- c("HR")
control      <- c("AL","BA","MK","ME","RS","TR","MD","UA","BY","GE")
all_countries <- c(treated_2004, treated_2007, treated_2013, control)

# ── WDI indicator codes ──────────────────────────────────────
indicators <- c(
  GDP_Growth              = "NY.GDP.MKTP.KD.ZG",
  Unemployment            = "SL.UEM.TOTL.ZS",
  Inflation               = "FP.CPI.TOTL.ZG",
  Current_Account_Balance = "BN.CAB.XOKA.GD.ZS",
  Exports                 = "NE.EXP.GNFS.ZS",
  Imports                 = "NE.IMP.GNFS.ZS",
  Gross_Capital_Formation = "NE.GDI.TOTL.ZS",
  Government_Consumption  = "NE.CON.GOVT.ZS",
  Exchange_Rate_USD       = "PA.NUS.FCRF"
)

# ── Pull from World Bank API ─────────────────────────────────
cat("Pulling data from World Bank WDI API...\n")
raw_data <- WDI(
  country   = all_countries,
  indicator = indicators,
  start     = 1995,
  end       = 2022,
  extra     = TRUE
)
cat("Rows pulled:", nrow(raw_data), "\n")

# ── Clean ────────────────────────────────────────────────────
panel_data <- raw_data %>%
  select(
    country_id = iso3c, country_name = country, year,
    GDP_Growth, Unemployment, Inflation,
    Current_Account_Balance, Exports, Imports,
    Gross_Capital_Formation, Government_Consumption, Exchange_Rate_USD
  ) %>%
  filter(year >= 1995, year <= 2022) %>%
  arrange(country_id, year)

# ── Add treatment variables ──────────────────────────────────
panel_data <- panel_data %>%
  mutate(
    accession_year = case_when(
      country_id %in% c("CYP","CZE","EST","HUN","LVA",
                         "LTU","MLT","POL","SVK","SVN") ~ 2004,
      country_id %in% c("BGR","ROU")                    ~ 2007,
      country_id %in% c("HRV")                          ~ 2013,
      TRUE                                               ~ 0
    ),
    Treated  = if_else(accession_year > 0 & year >= accession_year, 1, 0),
    Never_EU = if_else(accession_year == 0, 1, 0)
  )

cat("Treated obs:", sum(panel_data$Treated), "\n")
cat("Control obs:", sum(panel_data$Never_EU), "\n")

# ── Export ───────────────────────────────────────────────────
output_path <- "Data/eupanel.dta"
write_dta(panel_data, output_path)
cat("Saved to:", output_path, "\n")
cat("Rows:", nrow(panel_data), "| Countries:",
    n_distinct(panel_data$country_id), "| Years: 1995-2022\n")
