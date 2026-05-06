# Macroeconomic Impact of EU Accession — A DiD Study

**MSc Financial Modelling & Investment | University of Glasgow**  
**Supervisor: Dr. Sisir Ramanan | Word Count: 9,249**

A dynamic, staggered Difference-in-Differences event study examining the macroeconomic consequences of EU accession for new member states, using World Bank data spanning 1995–2022.

---

## What this project does

- Estimates Average Treatment Effects on the Treated (ATET) for 9 macroeconomic indicators across EU accession waves (2004, 2007, 2013)
- Applies a staggered DiD design using `xthdidregress` in Stata 18 to accommodate heterogeneous treatment timing
- Tests parallel trends assumptions via pre-treatment event-study coefficients
- Conducts cohort-level heterogeneity analysis across the 2004, 2007, and 2013 enlargement waves
- Runs cross-indicator robustness checks (e.g. exports as treatment, imports as outcome)

---

## Research Questions

1. Does EU accession accelerate macroeconomic growth among new member states?
2. How do key indicators evolve in the years preceding and following EU membership?
3. To what extent do effects vary across different accession waves (2004, 2007, 2013)?

---

## Data

| Source | Coverage |
|--------|----------|
| World Bank WDI (via `WDI` R package) | 1995–2022 |
| 13 treated countries (EU accession 2004/2007/2013) | Cyprus, Czech Republic, Estonia, Hungary, Latvia, Lithuania, Malta, Poland, Slovakia, Slovenia, Bulgaria, Romania, Croatia |
| 10 control countries (never treated) | Albania, Bosnia & Herzegovina, North Macedonia, Serbia, Turkey, Moldova, Ukraine, Belarus, Georgia, Montenegro |

---

## Indicators Analysed

| Indicator | Unit |
|-----------|------|
| Government Consumption | % of GDP |
| Exports | % of GDP |
| Imports | % of GDP |
| Gross Capital Formation | % of GDP |
| GDP Growth | Annual % |
| Unemployment | % |
| Current Account Balance | % of GDP |
| Inflation (CPI) | % |
| Exchange Rate to USD | Local currency units |

---

## Methodology

### Empirical Strategy

Dynamic event-study Difference-in-Differences with staggered treatment adoption:

```
Y_it = α_i + λ_t + Σ β_k · D_{i,t+k} + ε_it
```

where:
- `α_i` = country fixed effects
- `λ_t` = year fixed effects
- `D_{i,t+k}` = event-time indicators (k ∈ {−10, ..., +10}, k ≠ −1)
- `β_k` = dynamic ATET coefficients of interest
- Reference year: **k = −1** (one year before accession)

### Tools

| Component | Detail |
|-----------|--------|
| Estimation | `xthdidregress` (Stata 18) |
| Data collection | `WDI` package (R) |
| Fixed effects | Country + Year |
| Standard errors | Clustered at country level |
| Event window | 10 years before and after accession |

---

## Key Findings

| Indicator | Direction | Timing | Cohort Heterogeneity |
|-----------|-----------|--------|----------------------|
| Exports | ↑ +7 pp | Immediate | Stronger for 2004 cohort |
| Imports | ↑ +10 pp | Immediate | Strongest overall effect |
| Gross Capital Formation | ↑ +4.5 pp | Lagged (~year 3) | Driven by structural funds |
| Government Consumption | ↓ −2.5 pp | Persistent from year 3 | Earlier cohorts more pronounced |
| GDP Growth | ↑ +4.5 pp | J-shaped (year 4+) | 2004 cohort largest premium |
| Unemployment | ↓ −2.2 pp | Delayed (year 5+) | Gradual structural improvement |
| Current Account Balance | ≈ 0 | No consistent effect | Dominated by offsetting flows |
| Inflation | ↓ slight | Cohort-specific | Most clear for 2004 cohort |
| Exchange Rate (USD) | ≈ 0 | No systematic effect | Driven by global factors |

---

## Cohort Heterogeneity Summary

Earlier accession cohorts consistently achieved larger and faster post-accession gains across trade, investment, growth, and labour market indicators. The 2013 cohort (Croatia) showed the most muted responses, likely reflecting post-crisis entry conditions and lower structural readiness.

---

## Policy Implications

- **Candidate countries** (Ukraine, Moldova, Western Balkans): institutional and trade readiness at point of entry shapes both speed and magnitude of benefits
- **EU policymakers**: enlargement conditionality and structural fund allocation should be tailored to the economic maturity of each candidate
- **International integration**: EU accession offers transferable lessons for other blocs (ASEAN, AfCFTA), particularly around deep institutional alignment

---

## Repository Structure

```
├── data/               # Raw and processed WDI panel data
├── scripts/
│   ├── R/              # Data collection via WDI package
│   └── stata/          # xthdidregress estimation & event study plots
├── results/            # Coefficient plots and regression output tables
└── README.md
```

---

## References

Key methodological references:
- Callaway & Sant'Anna (2021) — DiD with multiple time periods
- Goodman-Bacon (2021) — DiD with variation in treatment timing
- de Chaisemartin & D'Haultfœuille (2020) — Two-way FE with heterogeneous effects

Full bibliography available in the dissertation.
