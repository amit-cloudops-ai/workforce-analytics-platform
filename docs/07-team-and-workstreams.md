# 07. Team and workstreams

Three workstreams, three people. **Everyone claims one in this file** by editing the "Owner" cell via a PR (`WFA-000: claim workstream X`) and then updating the matching `CODEOWNERS` lines. Amit stays **project lead and integration owner** regardless of workstream: approves contracts, runs releases, resolves conflicts.

| Workstream | Owner (claim me) | Paths |
|---|---|---|
| **A. Platform & SRE** | | `infra/`, `.github/`, `scripts/`, `docs/09*`, `docs/11*` |
| **B. Data & Aggregation** | | `data/`, `services/aggregator/`, `tests/golden/`, `tests/unit/test_risk*.py` |
| **C. API & Frontend** | | `services/shared/`, `services/api_*/`, `frontend/`, `tests/contract/` |

## A. Platform & SRE (cloud + DevOps heavy)
**You will build:** Terraform for all AWS resources, GitHub Actions CI/CD with OIDC, Cognito, API Gateway, CloudFront/S3, alarms/SNS/budgets, runbook, release.
**You will learn / show on your CV:** IaC modules, OIDC federation, least-privilege IAM, SRE (SLOs, alarms, game day), cost governance.
**Issues:** WFA-001..004, 008, 017, 018, 023, 025, 032, 034..038.

## B. Data & Aggregation (Python + data heavy)
**You will build:** data model validation, deterministic seed script, aggregation logic (headcount, leave, funnel), attrition risk scoring, golden tests.
**You will learn / show:** DynamoDB design and capacity planning, idempotent pipelines, testing with `moto`, scoring design and documentation.
**Issues:** WFA-005, 009..016.

## C. API & Frontend (backend API + UI heavy)
**You will build:** shared Lambda library (auth, errors), 3 API Lambdas, contract tests, the whole dashboard (Chart.js charts, sortable table, D3 org chart, health widget).
**You will learn / show:** secure API design, contract testing against OpenAPI, data visualisation, recursive tree algorithms.
**Issues:** WFA-006, 007, 019..022, 024, 026..031.

## Shared issues
WFA-033 (accessibility/responsive pass), WFA-039 (final diagram + README), WFA-040 (demo script) are done jointly; the lead assigns them in Week 4.

## Working agreements
- Daily 10-minute async update in the Google Space / chat: done, doing, blocked.
- Weekly 30-minute sync: demo what works, review the milestone checklist.
- PRs reviewed within 24 h. Review means: run it, check blast radius, check AGENTS.md rules.
- A contract change is proposed in an issue first and discussed with all three.
- Disagreement is settled by ADR; the lead decides if undecided after one discussion.

## Handoffs between workstreams (the integration points)
| From → To | Artifact | Where |
|---|---|---|
| A → B | Tables exist in dev | Terraform module `data`, names in doc 03 |
| B → C | Metric names + data in `analytics` | doc 03 |
| A → C | API URL, Cognito IDs, CloudFront domain | Terraform outputs contract (doc 02) → `config.json` |
| C → A | Lambda zip layout | `scripts/package.sh` contract (doc 02) |
| All | API shape | `docs/openapi.yaml` |
