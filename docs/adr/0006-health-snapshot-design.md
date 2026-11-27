# ADR-0006: System health widget reads a stored snapshot, not CloudWatch per request

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
The dashboard must show API Gateway request counts and Lambda errors. `GetMetricData` is billed per metric requested and could exceed free tier if called per page view.

## Decision
A `health_snapshot` Lambda runs every 15 minutes, reads the last 60 minutes of metrics from CloudWatch, writes `sys_*` rows (TTL 7 days) into the analytics table. `/system/health` reads only DynamoDB.

## Alternatives considered
- Call CloudWatch from the API on each request: cost and latency risk.
- Embed a CloudWatch dashboard: needs sharing config and public exposure.

## Consequences
Health data is at most ~15 minutes stale (acceptable, NFR-4). Adds one Lambda and one schedule.
