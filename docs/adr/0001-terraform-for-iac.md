# ADR-0001: Terraform for infrastructure as code

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
We need reproducible, reviewable infrastructure that an AI assistant can modify safely and that demonstrates production practice.

## Decision
Use Terraform (>= 1.10) with the AWS provider (>= 5.80, < 6.0), modules per concern, remote state in S3 with native locking (`use_lockfile`).

## Alternatives considered
- AWS SAM/CDK: fewer lines for Lambda but less transferable and weaker plan review.
- Console clicks: not reproducible.
- DynamoDB lock table: consumes free-tier capacity we need for data tables.

## Consequences
Plans are reviewable in PRs. State bucket is a manual bootstrap (doc 09). Provider major upgrade needs its own ADR.
