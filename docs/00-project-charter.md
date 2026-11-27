# 00. Project charter

## Goal
Build and deploy, to production on AWS free tier, a **Workforce Analytics & Org Intelligence Dashboard** that gives HR and leadership a live view of workforce health: headcount, attrition risk, hiring funnel, leave utilisation and a live org chart.

## Why this exists
Raw HR data is not decision-ready. This is the intelligence layer on top of HRMS data: aggregation pipeline, scoring, secured API, visual dashboard, observability and CI/CD, built the way a real production system would be.

## Finish line (the project is DONE when)
All items in [`12-definition-of-done.md`](12-definition-of-done.md) are ticked. Headlines:
1. Live HTTPS dashboard; only Cognito groups `HR_Admin` and `Leadership` can use it.
2. At least 4 chart types plus sortable attrition table, org chart tab and health widget.
3. Daily EventBridge → Lambda aggregation writes to the analytics table; attrition scores computed.
4. Seed script produces realistic data for ~80 employees with 12 months of history.
5. Scoring formula, architecture diagram and runbook documented.
6. Everything created by Terraform; deployed by GitHub Actions via OIDC; prod deploy gated by approval.
7. AWS bill is $0 and budget alerts are active.

## Scope
**In:** pipeline, analytics tables, scoring, 6 read-only API endpoints, Cognito auth, static SPA on CloudFront/S3, CloudWatch-based health widget, alarms, IaC, CI/CD, docs.
**Out (non-goals):** real HRMS integration, write APIs, ML models, multi-account setup, custom domain, SSO federation, mobile app, real employee data.

## Constraints
- AWS free tier only, region `ap-south-1`. See [`08-free-tier-guardrails.md`](08-free-tier-guardrails.md).
- Team of 3; ChatGPT writes much of the code under the rules in [`../AGENTS.md`](../AGENTS.md).
- Dummy data only.

## Team
| Person | GitHub | Role |
|---|---|---|
| Amit | @amit-cloudops-ai | Project lead, integration owner, reviewer of all contracts |
| Sushmitha M | @sush-kush | Workstream owner (claim in doc 07) |
| GopiKrishna | @dggk78 | Workstream owner (claim in doc 07) |

## Risks and mitigations
| Risk | Mitigation |
|---|---|
| AI-generated change breaks another part | Contract-first, CODEOWNERS, golden-file tests, one-issue-per-PR, `make verify` gate |
| Free tier overrun | Budget alerts, provisioned DynamoDB within 25/25, banned-services list, monthly cost check |
| Free plan expires (new accounts) | Note expiry date in Billing; decide upgrade/teardown before it; `terraform destroy` path in runbook |
| Parallel work collides | Path ownership per workstream; frontend builds against mock JSON until API is live |
| Credentials leak | OIDC only, gitleaks in CI, no secrets in repo |
