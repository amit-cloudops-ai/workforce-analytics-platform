# 01. Requirements

## Personas
- **HR_Admin:** monitors attrition risk and hiring, needs per-employee detail.
- **Leadership:** wants department-level health and the org structure at a glance.

## Functional requirements
| ID | Requirement | Acceptance |
|---|---|---|
| FR-1 | Daily job computes headcount, hires, departures per department per month | `analytics` has `headcount_<dept>`, `hires_<dept>`, `departures_<dept>` for last 12 months |
| FR-2 | Leave utilisation per department: current month vs 3-month average | `leave_util_<dept>` and `leave_util_3mo_avg_<dept>` present; chart renders both |
| FR-3 | Recruitment funnel: received → shortlisted → interviewed → offered → joined | `funnel_*` metrics for the month; funnel chart shows 5 stages in order |
| FR-4 | Attrition risk per employee, weighted formula | Scores per [`04-scoring.md`](04-scoring.md); stored in `attrition_risk` |
| FR-5 | Top 10 attrition risk table, sortable, with contributing factors | `/attrition/top10` returns 10 rows with factor breakdown; UI columns sort asc/desc |
| FR-6 | Org chart from `manager_id`, nested JSON, recursive traversal | `/org/tree` returns one root with nested `children`; handles orphans and cycles safely |
| FR-7 | Interactive org chart in separate tab | Expand/collapse, zoom/pan, search by name |
| FR-8 | Login gate for `HR_Admin` and `Leadership` only | Other users get 403 from API and an "access denied" screen |
| FR-9 | System health widget: API Gateway request count, Lambda error rate | `/system/health` returns series; widget shows last 60 min |
| FR-10 | Seed script creates realistic dummy data | ~80 employees, 8 departments, 12 months history, deterministic |

## Non-functional requirements
| ID | Requirement | Target |
|---|---|---|
| NFR-1 | Cost | $0 on free tier; budget alert at $1 |
| NFR-2 | Availability (dashboard API) | 99.5% monthly (SLO) |
| NFR-3 | Latency | p95 < 800 ms for API endpoints |
| NFR-4 | Freshness | Aggregates updated daily; health snapshot every 15 min |
| NFR-5 | Security | Private S3 + CloudFront OAC, JWT-authorised API, least-privilege IAM, HTTPS only, no secrets in repo |
| NFR-6 | Reproducibility | Whole stack from `terraform apply` + seed script |
| NFR-7 | Reliability of pipeline | Aggregator idempotent; failure raises alarm within 26 h |
| NFR-8 | Maintainability | CI gates, ADRs, runbook, contracts in repo |
| NFR-9 | Accessibility | Keyboard-usable tabs/table, colour not the only signal, responsive to 360 px |
