# ADR-0003: DynamoDB with provisioned capacity

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
Free tier includes 25 RCU/25 WCU of provisioned capacity; on-demand is not covered the same way and can generate small charges.

## Decision
All tables provisioned, total at most 23 RCU / 23 WCU (see doc 03). No GSIs, no PITR. Seed script and aggregator use batching with exponential backoff.

## Alternatives considered
- On-demand: simpler but not reliably $0.
- RDS: not free-tier-safe for always-on and overkill.

## Consequences
Throttling is possible during seeding; code must retry. Raising capacity is a contract change (doc 03 table + lead approval).
