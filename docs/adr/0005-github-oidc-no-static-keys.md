# ADR-0005: GitHub Actions authenticates to AWS with OIDC

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
Long-lived access keys in GitHub secrets are a leak risk, especially with AI contributors.

## Decision
IAM OIDC provider for GitHub; one role per environment (`wfa-github-deploy-dev`, `wfa-github-deploy-prod`) trusted only for the matching GitHub Environment `sub`; optional read-only plan role for PRs. Deploy roles start as AdministratorAccess and are tightened in WFA-035.

## Alternatives considered
- Access keys: rotation burden, leak risk.
- Self-hosted runners: cost and ops burden.

## Consequences
Prod deploys only from `v*` tags with manual approval. Admin-level deploy role is documented technical debt until WFA-035.
