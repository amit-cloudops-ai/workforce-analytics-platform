# health_snapshot (Workstream A)

Every 15 minutes: one `GetMetricData` call for API Gateway (`Count`, `5xx`) and Lambda (`Errors`, `Invocations`) over the last 60 minutes; writes `sys_*` rows to `analytics` with 7-day TTL. See ADR-0006. Issue WFA-025.
