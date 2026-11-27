# ADR-0004: S3 + CloudFront (OAC) for the SPA

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
Cognito Hosted UI callbacks and a production site need HTTPS; S3 website endpoints are HTTP only.

## Decision
Private S3 bucket, CloudFront distribution with Origin Access Control, HTTPS redirect, security-headers response policy. `config.json` is generated at deploy time from Terraform outputs.

## Alternatives considered
- S3 website hosting: HTTP only, public bucket.
- Amplify Hosting: extra service, outside guardrails.

## Consequences
Cache invalidation on each deploy (well within free monthly invalidation paths). Default CloudFront domain is used (no custom domain).
