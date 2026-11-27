# 03. Data model (contract)

All tables: DynamoDB, **provisioned** capacity, AWS-owned-key encryption, no PITR, no GSIs (at ≤100 employees a Scan/Query is trivially cheap). Table names are `wfa-<env>-<name>`.

## Departments (fixed slugs)
`engineering`, `product`, `design`, `sales`, `marketing`, `hr`, `finance`, `operations`

Seed headcount (active at reference date): engineering 26, product 8, design 6, sales 14, marketing 8, hr 5, finance 6, operations 7 = **80 active**, plus ~14 employees terminated during the last 12 months.

## Capacity budget (free tier = 25 RCU + 25 WCU total, all tables)
| Table | RCU | WCU |
|---|---|---|
| employees | 5 | 5 |
| leave_records | 5 | 5 |
| recruitment_events | 4 | 4 |
| analytics | 6 | 6 |
| attrition_risk | 3 | 3 |
| **Total** | **23** | **23** |

Headroom of 2/2 is reserved. **Do not raise any value without updating this table and getting lead approval.** The seed script must use `batch_writer` with exponential backoff and tolerate throttling (a full seed may take a few minutes).

## `employees` (source)
| Attribute | Type | Notes |
|---|---|---|
| `employee_id` (PK) | S | `E0001` ... |
| `name` | S | Fake names |
| `title` | S | e.g. "Senior Engineer" |
| `department` | S | one of the slugs |
| `manager_id` | S | **omitted** for the single root (CEO) |
| `hire_date` | S | `YYYY-MM-DD` |
| `termination_date` | S | omitted if active |
| `status` | S | `ACTIVE` or `TERMINATED` |
| `performance_score` | N | integer 1-5 (5 best) |

Rules: exactly one root; every other `manager_id` exists; no cycles; managers are never terminated while they have active reports; max depth 6.

## `leave_records` (source)
PK `employee_id` (S), SK `leave_start` (S, `YYYY-MM-DD`). Attributes: `days` (N, whole days), `type` (`annual|sick|casual`). **A leave never spans two months** (seed guarantees it). Annual quota: **24 days per employee** (2 days/month accrual).

## `recruitment_events` (source)
PK `month` (S, `YYYY-MM` of application received), SK `candidate_id` (S, `C00001`...). Attributes: `department` (S), `stage_reached` (S: `received|shortlisted|interviewed|offered|joined`). ~25 candidates per month, 12 months.

## `analytics` (output)
PK `metric_name` (S), SK `date` (S), `value` (N), `updated_at` (S, UTC ISO), `ttl` (N, only on `sys_*` rows).

Monthly metrics use `date = YYYY-MM`:

| `metric_name` | Meaning |
|---|---|
| `headcount_<dept>` / `headcount_total` | Active at end of month |
| `hires_<dept>` / `hires_total` | `hire_date` in month |
| `departures_<dept>` / `departures_total` | `termination_date` in month |
| `leave_util_<dept>` | leave days taken in month ÷ (active headcount at month end × 2) × 100, 1 decimal |
| `leave_util_3mo_avg_<dept>` | mean of `leave_util_<dept>` for the 3 months **before** the month |
| `funnel_received`, `funnel_shortlisted`, `funnel_interviewed`, `funnel_offered`, `funnel_joined` | Cohort count of candidates received in month who reached **at least** that stage |
| `risk_band_low`, `risk_band_medium`, `risk_band_high` | Count of active employees per band at month's run |

System health rows, `date = YYYY-MM-DDTHH:MMZ`, `ttl` = now + 7 days:
- written by `health_snapshot` every 15 min: `sys_api_requests`, `sys_api_5xx`, `sys_lambda_errors`, `sys_lambda_invocations`
- written by `aggregator` after each successful run: `sys_aggregator_last_success` (value = epoch seconds)

`/system/health` reports aggregator status `ok` if the last success is < 26 h old, `stale` if older, `unknown` if no row exists.

**Idempotency:** every run overwrites with `PutItem`. Running the aggregator twice for the same `as_of` produces identical data. A run recomputes the last 12 months (backfill) so history is always consistent with source tables.

## `attrition_risk` (output)
PK `period` (S, `YYYY-MM`), SK `employee_id` (S). Only ACTIVE employees.
Attributes: `name`, `department`, `title` (denormalised for fast API), `risk_score` (N, 0-100, 1 decimal), `band` (`low|medium|high`), `performance_points`, `leave_points`, `tenure_points` (N), `performance_score`, `leave_days_12m`, `tenure_months` (N inputs), `computed_at`.
Top-10 = Query by `period`, sort by `risk_score` desc then `employee_id` asc, take 10.

## Access patterns
| Pattern | Table | Operation |
|---|---|---|
| Metric series for dept over months | analytics | `Query` PK=`headcount_engineering`, SK between months |
| Latest funnel / leave snapshot | analytics | `Query` per metric, latest SK |
| Top-10 risk | attrition_risk | `Query` PK=period |
| Org tree | employees | `Scan` (≤100 items) then build tree in Lambda |
| Health series | analytics | `Query` PK=`sys_api_requests`, SK >= now-60min |

## Seed determinism
`data/seed.py` uses `random.Random(42)` and reference date **2026-11-27**. Same inputs → same dataset. This is what makes `tests/golden/` possible.
