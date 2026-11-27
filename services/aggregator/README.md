# aggregator (Workstream B)

Reads `employees`, `leave_records`, `recruitment_events`; writes `analytics` and `attrition_risk`. Contracts: docs/03 and docs/04. Must be idempotent (PutItem overwrite) and accept `{}` or `{"as_of": "YYYY-MM-DD"}`.

Planned modules: `metrics_headcount.py`, `metrics_leave.py`, `metrics_funnel.py`, `risk.py`, `io.py`, `handler.py`. Issues WFA-011..016.
