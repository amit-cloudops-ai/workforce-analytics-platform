# Team brief: Workforce Analytics & Org Intelligence Dashboard

**Repo:** https://github.com/amit-cloudops-ai/workforce-analytics-platform
**Team:** Amit (lead), Sushmitha M (@sush-kush), GopiKrishna (@dggk78)
**Timeline:** 4 weeks (adjustable) · **Budget:** $0 (AWS free tier) · **Region:** ap-south-1

## What we are building
A real, production-deployed analytics dashboard for HR and leadership: headcount trends (hires vs departures), leave utilisation, recruitment funnel, top-10 attrition risk with explanations, a live org chart, and a system-health panel. Data is dummy (80 employees). Everything is serverless on AWS free tier, built with Terraform, deployed with GitHub Actions, secured with Cognito.

## What "done" means
The checklist in `docs/12-definition-of-done.md`. We keep working until every box is ticked on prod.

## How the system works (30 seconds)
Seeded DynamoDB tables → daily Lambda aggregates metrics and scores attrition risk → results in an analytics table → API Gateway + Lambdas serve them (Cognito login required) → static dashboard on CloudFront/S3 draws charts (Chart.js) and the org chart (D3).

## Pick your workstream (claim it in `docs/07-team-and-workstreams.md`)
| | A. Platform & SRE | B. Data & Aggregation | C. API & Frontend |
|---|---|---|---|
| Flavour | Cloud/DevOps/SRE | Python/data | Backend API + UI |
| Builds | Terraform, CI/CD, Cognito, CloudFront, alarms, runbook, releases | Seed script, aggregator, risk scoring, golden tests | Shared lib, API Lambdas, contract tests, full dashboard |
| Good if you want | DevOps/Cloud job proof | Data/automation/AI-adjacent proof | Full-stack proof |

Amit remains lead and integration owner whichever you choose. If two people want the same workstream, we split its issues in the first sync.

## How we work
1. Read `AGENTS.md` once, fully. It is the rule book (also for ChatGPT).
2. Take one issue (they are in `docs/BACKLOG.md` and in the GitHub Issues tab). One issue = one branch = one PR.
3. Use ChatGPT the way `docs/CHATGPT_BUILDER_PLAYBOOK.md` says (paste the session-start prompt, give it only the issue).
4. Run `make verify` before and after. PR title: `WFA-<id>: summary`.
5. Never push to `main`. A code owner must approve.
6. If something is unclear, ask. Do not guess contracts (API shape, metric names, formulas).

## First 48 hours
- Everyone: accept the repo invite, read the charter, requirements, architecture, and your workstream section.
- Everyone: claim a workstream (PR to doc 07 + CODEOWNERS).
- Amit: AWS and GitHub bootstrap (`docs/09`), create issues/milestones.
- B and C: start Phase 1 issues (WFA-005, WFA-006, WFA-007).
