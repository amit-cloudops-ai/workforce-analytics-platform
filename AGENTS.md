# AGENTS.md: rules for every contributor (human or AI)

> If you are ChatGPT or any other AI assistant working on this repo: **read this file fully before every task.** These rules exist so that fixing one thing never breaks another.

## 0. Mission and finish line

Build and deploy the Workforce Analytics & Org Intelligence Dashboard on **AWS free tier**, in `ap-south-1`, exactly as specified in `docs/`. The project is finished only when every box in [`docs/12-definition-of-done.md`](docs/12-definition-of-done.md) is ticked. Keep working toward that list, one issue at a time.

## 1. Source-of-truth order

When documents disagree, the higher one wins. Fix the lower one in the same PR.

1. `docs/openapi.yaml` (API contract)
2. `docs/03-data-model.md` (tables, keys, metric names)
3. `docs/04-scoring.md` (risk formula)
4. `docs/02-architecture.md` (including **Terraform outputs contract** and **Lambda packaging contract**)
5. `docs/adr/*` (decisions)
6. Code

**Never change 1-4 casually.** A contract change needs: an ADR, updates to every producer and consumer, updated tests, and the owner's approval (see `.github/CODEOWNERS`), all in one PR.

## 2. Working rules

1. **One issue = one branch = one PR.** Branch name: `wfa-<issue-number>-<short-slug>`. PR title: `WFA-<id>: <summary>`.
2. **Touch only the paths listed in the issue.** If you believe another file must change, stop and write it in the PR description instead of editing it.
3. **No drive-by changes.** No renames, reformatting, refactors, dependency upgrades or "improvements" outside the issue.
4. **Test before and after.** Run `make verify` first (record the result), make the change, run it again. A change that turns anything red is not done.
5. **Smallest possible diff.** Prefer adding over modifying. Prefer new files over rewriting shared ones.
6. **Pin everything.** Exact versions for Terraform providers, GitHub Actions and CDN scripts (with SRI hashes).
7. **No secrets in the repo.** No AWS keys, passwords, tokens or account IDs in code. Deploys use GitHub OIDC only.
8. **Idempotent by default.** The aggregator, seed script and deploy must be safe to run twice.
9. **If a fix fails twice, stop.** Write what you tried, what failed and what you suspect in the issue. Do not keep patching.
10. **Never delete or replace stateful resources** (DynamoDB tables, S3 buckets, Cognito pools) without explicit approval written in the PR.

## 3. Free-tier hard rules

Never add: NAT Gateway, ALB/NLB, RDS/Aurora, WAF, Secrets Manager, custom KMS keys, VPC endpoints, Lambda in a VPC, DynamoDB on-demand mode, DynamoDB PITR, CloudWatch dashboards beyond 3, X-Ray, Cognito Plus tier, or any service not listed in `docs/08-free-tier-guardrails.md`.
DynamoDB provisioned capacity across **all** tables and GSIs must stay at or below **25 RCU and 25 WCU** (budget table in `docs/03-data-model.md`).

## 4. Code standards

- Python 3.12, `ruff` clean, type hints on public functions, no print debugging (use `logging`).
- Lambda handler entrypoint is always `handler.lambda_handler`.
- All API Lambdas use `services/shared` for auth, CORS, errors and response shape. Do not re-implement.
- All timestamps are UTC ISO-8601. Month keys are `YYYY-MM`. Department keys are lowercase slugs from `docs/03-data-model.md`.
- Frontend: plain HTML/CSS/JS modules, Chart.js and D3 from CDN (pinned + SRI). No build step.
- Terraform: `terraform fmt` clean, one module per concern, **module outputs and root outputs are a contract** (names in `docs/02-architecture.md`).

## 5. Definition of done for a PR

- [ ] Issue acceptance criteria all met
- [ ] Only allowed paths changed
- [ ] `make verify` green (before and after)
- [ ] Docs updated if behaviour or contract changed
- [ ] `terraform plan` reviewed: no unexpected destroy/replace
- [ ] PR template filled in honestly

## 6. When unsure

Ask the issue owner. Do not guess, and do not invent endpoints, fields, metric names or AWS resources that are not in the docs.
