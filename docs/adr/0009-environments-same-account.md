# ADR-0009: dev and prod in a single AWS account

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
Free tier is per account; a second account would split quotas and complicate bootstrap.

## Decision
Single account, resources prefixed `wfa-dev-` / `wfa-prod-`, separate Terraform state keys, separate GitHub Environments and IAM roles.

## Alternatives considered
- Two accounts: better isolation, but more setup and quota duplication.

## Consequences
Isolation is logical, not account-level. Be careful with shared-account limits (e.g. Cognito domain prefixes). Prod destroy requires explicit approval.
