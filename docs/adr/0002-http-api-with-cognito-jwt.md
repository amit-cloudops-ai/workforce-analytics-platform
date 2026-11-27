# ADR-0002: API Gateway HTTP API with Cognito JWT authorizer

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
Six read-only endpoints for a browser SPA, access limited to two groups, minimal cost.

## Decision
HTTP API (not REST API) with the native JWT authorizer pointing at the Cognito user pool. Each Lambda additionally checks `cognito:groups` contains `HR_Admin` or `Leadership` through `services/shared`.

## Alternatives considered
- REST API: more features (usage plans, WAF), higher cost, unneeded.
- Lambda authorizer: more code to maintain.
- Auth in Lambda only: unauthenticated traffic would still reach Lambda.

## Consequences
Defence in depth (gateway + Lambda). Groups are enforced twice, so `services/shared` auth helper has unit tests. CORS limited to the CloudFront domain.
