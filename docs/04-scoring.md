# 04. Attrition risk scoring (contract)

A **transparent heuristic**, not a machine-learning model. Computed per ACTIVE employee by the aggregator.

## Formula
```
risk = 0.40 x P + 0.35 x L + 0.25 x T          (each component is 0-100)
```

| Component | Weight | Input | Definition |
|---|---|---|---|
| **P** performance | 0.40 | `performance_score` (1-5) | `P = (5 - score) / 4 x 100` (lower performance → higher risk) |
| **L** leave | 0.35 | `leave_days_12m` | `L = min(leave_days_12m / quota_12m, 1) x 100` where `quota_12m = 24 x min(max(tenure_months,1),12) / 12` (prorated for new joiners) |
| **T** tenure | 0.25 | `tenure_months` | lookup table below |

`leave_days_12m` = sum of `days` for leave records with `leave_start` in the 12 months up to and including `as_of`. `tenure_months` = whole months between `hire_date` and `as_of` (floor).

### Tenure lookup
| Tenure (months) | T |
|---|---|
| 0 to <6 | 70 |
| 6 to <12 | 90 |
| 12 to <24 | 70 |
| 24 to <36 | 50 |
| 36 to <60 | 30 |
| 60+ | 20 |

Rationale: attrition clusters just after the first year and tapers with tenure.

## Bands (thresholds)
| Band | Score |
|---|---|
| **Low** | 0.0 - 39.9 |
| **Medium** | 40.0 - 64.9 |
| **High** | 65.0 - 100.0 |

## Rounding and ties
Round half up to 1 decimal using `Decimal`. Component "points" (`weight x component`) are each rounded to 1 decimal for display and may differ from the total by ±0.1. Ranking: score desc, then `employee_id` asc.

## Contributing factors (what the UI shows)
For each employee: the three weighted points (`performance_points`, `leave_points`, `tenure_points`) with their raw inputs, e.g. "Performance 2/5 → 30.0 pts".

## Worked example
Performance 2, leave 20 days in 12 months, tenure 8 months:
- P = (5-2)/4 x 100 = 75.0 → 30.0 pts
- quota_12m = 24 x 8/12 = 16 → L = min(20/16, 1) x 100 = 100 → 35.0 pts
- T (6-12 months) = 90 → 22.5 pts
- **risk = 87.5 → High**

## Limitations (state these in the README/demo)
Dummy data; weights are judgement-based, not learned; high leave is a proxy, not proof of disengagement; scores must never be used for real employment decisions without human review.

## Changing the formula
Needs an ADR, updated unit tests in `tests/unit/test_risk.py`, and regenerated golden files in `tests/golden/`, all in one PR, approved by the lead.
