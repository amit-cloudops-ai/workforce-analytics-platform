# ADR-0008: Contract-first development with golden and contract tests

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
AI-assisted development can change one component and silently break another.

## Decision
OpenAPI, data model, scoring and Terraform outputs are contracts. Contract tests validate API responses against OpenAPI; golden tests pin aggregator output on deterministic seed data; CODEOWNERS enforces review on contracts; AGENTS.md defines blast-radius rules.

## Alternatives considered
- Trust-based review only: does not scale to AI-generated PRs.

## Consequences
Small extra effort per change; large reduction in cross-component regressions.
