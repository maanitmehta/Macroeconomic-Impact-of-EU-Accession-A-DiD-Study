# Macroeconomic Impact of EU Accession — A DiD Study

A dynamic, staggered Difference-in-Differences event study examining how EU membership affected key macroeconomic outcomes across 13 new member states, relative to 10 non-member control countries, over 1995–2022.

**University of Glasgow — MSc Financial Modelling & Investment**  
**Supervisor: Dr. Sisir Ramanan | Word Count: 9,249**

---

## What this project does

- Estimates Average Treatment Effects on the Treated (ATET) for 9 macroeconomic indicators across EU accession cohorts (2004, 2007, 2013)
- Applies a staggered DiD framework with country and year fixed effects to isolate accession effects from global shocks
- Tests pre-treatment parallel trends visually and via event-study coefficient plots
- Analyses cohort heterogeneity — comparing 2004, 2007, and 2013 entrants across all indicators
- Conducts cross-indicator robustness checks (e.g. exports as treatment, imports as outcome) to validate spillover effects

---

## Research Questions

1. Does EU accession accelerate macroeconomic growth among new member states?
2. How do indicators like exports, investment, and unemployment evolve in the years before and after EU membership?
3. To what extent do economic effects vary across accession waves (2004, 2007, 2013)?

---

## Data

| Source | Coverage |
|--------|----------|
| World Bank WDI (via `WDI` R package) | 1995–2022 |
| 13 treated countries | 2004, 2007, 2013 cohorts |
| 10 control countries | Albania, Bosnia, North Macedonia, Serbia, Turkey, Moldova, Ukraine, Belarus, Georgia, Montenegro |

### Indicators

- Exports & Imports (% of GDP)
- Gross Capital Formation (% of GDP)
- GDP Growth (Annual %)
- Unemployment (%)
- Government Consumption (% of GDP)
- Current Account Balance (% of GDP)
- Inflation (CPI %)
- Exchange Rate to USD

---

## Methodology

| Component | Description |
|-----------|-------------|
| Estimation Method | Dynamic Difference-in-Differences (Event Study) |
| Specification | `xthdidregress` (Stata 18) |
| Treatment Definition | EU Accession Year (2004, 2007, 2013) |
| Control Group | 10 non-EU countries (never treated) |
| Reference Year | k = −1 (year before accession) |
| Event Time Window | ±10 years around accession |
| Fixed Effects | Country and Year |
| Standard Errors | Clustered at country level |
| Software | R (`WDI` package for data), Stata (`xthdidregress` for estimation) |

---

## Key Findings

| Indicator | Observed Effect |
|-----------|----------------|
| Exports | Strong, persistent increase (~+7 pp by year 6); earlier cohorts benefit most |
| Imports | Largest effect of all indicators (~+10 pp by year 8); reflects consumption convergence |
| Gross Capital Formation | Delayed but substantial rise (~+4.5 pp by year 6); driven by structural fund absorption |
| GDP Growth | J-shaped pattern — initial dip, then strong recovery (~+4.5 pp by year 7) |
| Government Consumption | Sustained decline (~−2.5 pp by year 5); consistent with Maastricht fiscal discipline |
| Unemployment | Gradual post-accession decline (−2.2 pp by year 9) after initial adjustment |
| Current Account Balance | No consistent directional effect; offsetting trade flows dominate |
| Inflation | Mild disinflation trend; high volatility limits inference |
| Exchange Rate (USD) | No systematic accession effect; dominated by global factors |

---

## Cohort Heterogeneity

Earlier entrants consistently achieved **faster and larger** post-accession gains across nearly all indicators:

- **2004 cohort** — strongest effects on trade, investment, and growth; benefited from favourable global conditions and high institutional readiness
- **2007 cohort** — similar patterns with slight delays; partially confounded by the global financial crisis
- **2013 cohort** — most muted effects; post-crisis entry environment and more limited observation window

---

## Policy Implications

The findings are directly relevant to ongoing EU enlargement discussions involving **Ukraine, Moldova, and the Western Balkans**:

- Institutional and economic preparedness at the point of entry significantly shapes the speed and magnitude of post-accession benefits
- Structural fund absorption capacity matters — countries should invest in administrative and investment infrastructure ahead of entry
- EU enlargement policy should adopt a **differentiated** approach, tailoring conditionality and technical assistance to each candidate's readiness

---

## Limitations

- Accession timing may be endogenous to economic readiness
- EU candidacy may influence control group countries through anticipatory reforms
- The model assumes no spillovers between treated and control units
- Results are context-specific to the EU and may not generalise to other integration frameworks

---

## Repository Structure

```
├── data/               # Raw and cleaned WDI panel data (R)
├── scripts/            # Data collection, cleaning, and Stata DiD estimation
├── results/            # Event-study coefficient plots and regression tables
└── README.md
```

---

## About

**Maanit Mehta**  
MSc Financial Modelling & Investment, University of Glasgow  
Adam Smith Business School
