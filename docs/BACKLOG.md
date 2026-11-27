# Backlog

Source of truth for planned work. `scripts/create_github_issues.py` turns this into GitHub milestones, labels and issues (one task = one PR).

Workstreams: **A** Platform & SRE · **B** Data & Aggregation · **C** API & Frontend · **ALL** shared.

## M1 Foundation & Design (Wk1)

| ID | WS | Title | Depends on |
|---|---|---|---|
| WFA-001 | A | Repo governance: ruleset, collaborators, environments, variables | - |
| WFA-002 | A | AWS account bootstrap: budgets, MFA, state bucket, OIDC provider and roles | WFA-001 |
| WFA-003 | A | Terraform skeleton for dev and prod | WFA-002 |
| WFA-004 | A | Deploy workflow works end to end for dev (empty stack) | WFA-003 |
| WFA-005 | B | Validate and finalise data model with fixtures and schemas | - |
| WFA-006 | C | Mock API responses from the OpenAPI contract | - |
| WFA-007 | C | UI design direction proposal (needs lead approval before building) | - |

## M2 Data & Compute (Wk2)

| ID | WS | Title | Depends on |
|---|---|---|---|
| WFA-008 | A | Terraform module `data`: five DynamoDB tables | WFA-003, WFA-005 |
| WFA-009 | B | Deterministic seed script | WFA-005, WFA-008 |
| WFA-010 | B | Seed validation tests | WFA-009 |
| WFA-011 | B | Aggregator: headcount, hires, departures | WFA-005 |
| WFA-012 | B | Aggregator: leave utilisation and 3-month average | WFA-005 |
| WFA-013 | B | Aggregator: recruitment funnel | WFA-005 |
| WFA-014 | B | Attrition risk scoring module | WFA-005 |
| WFA-015 | B | Aggregator handler: orchestration, idempotent writes, EMF metrics, 12-month backfill | WFA-011, WFA-012, WFA-013, WFA-014 |
| WFA-016 | B | Golden-file test | WFA-009, WFA-015 |
| WFA-017 | A | Terraform module `compute`: aggregator Lambda + daily schedule | WFA-008, WFA-015 |

## M3 API, Auth & Frontend (Wk3)

| ID | WS | Title | Depends on |
|---|---|---|---|
| WFA-018 | A | Terraform module `auth`: Cognito | WFA-003 |
| WFA-019 | C | Shared Lambda library: auth, responses, errors, CORS | WFA-006 |
| WFA-020 | C | API Lambda: `api_metrics` (headcount, leave, funnel, system health) | WFA-015, WFA-019 |
| WFA-021 | C | API Lambda: `api_attrition` (top 10) | WFA-015, WFA-019 |
| WFA-022 | C | API Lambda: `api_org` (recursive org tree) | WFA-005, WFA-019 |
| WFA-023 | A | Terraform module `api`: HTTP API, JWT authorizer, routes | WFA-017, WFA-018, WFA-020, WFA-021, WFA-022, WFA-025 |
| WFA-024 | C | Contract test suite for all endpoints | WFA-020, WFA-021, WFA-022 |
| WFA-025 | A | health_snapshot Lambda + 15-minute schedule | WFA-008, WFA-015 |
| WFA-026 | C | SPA shell: login (PKCE), tabs, config, API client | WFA-006, WFA-007, WFA-018 |
| WFA-027 | C | Charts: headcount trend and leave utilisation | WFA-026 |
| WFA-028 | C | Charts: recruitment funnel and risk distribution | WFA-026 |
| WFA-029 | C | Attrition table with sortable columns and factor breakdown | WFA-026 |
| WFA-030 | C | Org chart tab (D3) | WFA-026 |
| WFA-031 | C | System health widget | WFA-026, WFA-020 |
| WFA-032 | A | Terraform module `frontend`: private S3 + CloudFront (OAC) | WFA-003 |

## M4 Operate, Harden & Release (Wk4)

| ID | WS | Title | Depends on |
|---|---|---|---|
| WFA-033 | ALL | Accessibility and responsive pass | WFA-027, WFA-028, WFA-029, WFA-030, WFA-031 |
| WFA-034 | A | Terraform module `monitoring`: alarms, SNS, budgets visibility | WFA-017, WFA-023 |
| WFA-035 | A | Security hardening: tighten IAM, scan IaC | WFA-023, WFA-032 |
| WFA-036 | A | Game day on dev | WFA-034 |
| WFA-037 | A | Smoke test script | WFA-023, WFA-032 |
| WFA-038 | A | Production release v1.0.0 | WFA-035, WFA-036, WFA-037, WFA-033, WFA-039 |
| WFA-039 | ALL | Final architecture diagram, README polish, screenshots | WFA-033 |
| WFA-040 | ALL | Demo script and project write-up | WFA-039 |

---

# Issue details

## WFA-001: Repo governance: ruleset, collaborators, environments, variables

**Workstream:** A (Platform & SRE) · **Milestone:** M1 Foundation & Design (Wk1) · **Depends on:** -

**Goal:** Make `main` safe: protected branch, code-owner review, required checks, dev/prod environments, Actions variables.

**Allowed paths (touch nothing else):**
- `(GitHub settings only, no code)`
- `docs/09-bootstrap-console-guide.md (tick boxes)`

**Acceptance criteria:**
- [ ] Ruleset `protect-main` active (PR + code-owner review + required checks + no force push)
- [ ] `sush-kush` and `dggk78` have Write access
- [ ] Environments `dev` and `prod` exist; `prod` requires reviewer and only `v*` tags
- [ ] Secret scanning + push protection on
- [ ] Evidence: screenshots in PR description

## WFA-002: AWS account bootstrap: budgets, MFA, state bucket, OIDC provider and roles

**Workstream:** A (Platform & SRE) · **Milestone:** M1 Foundation & Design (Wk1) · **Depends on:** WFA-001

**Goal:** Do Parts 1-3 of the bootstrap guide.

**Allowed paths (touch nothing else):**
- `(AWS Console only)`
- `docs/09-bootstrap-console-guide.md (tick boxes)`

**Acceptance criteria:**
- [ ] Free-tier plan type and expiry noted in project channel
- [ ] $1 budget and zero-spend budget active
- [ ] State bucket `wfa-tfstate-amit-cloudops-ap-south-1` with versioning and public access blocked
- [ ] OIDC provider and roles `wfa-github-deploy-dev`, `wfa-github-deploy-prod` (and `wfa-github-plan`) exist with exact `sub` conditions
- [ ] Actions variables `AWS_ROLE_ARN_DEV/PROD/PLAN` set

## WFA-003: Terraform skeleton for dev and prod

**Workstream:** A (Platform & SRE) · **Milestone:** M1 Foundation & Design (Wk1) · **Depends on:** WFA-002

**Goal:** Create root configs, shared tags, and empty module skeletons so CI validates.

**Allowed paths (touch nothing else):**
- `infra/envs/dev/**`
- `infra/envs/prod/**`
- `infra/modules/**`

**Acceptance criteria:**
- [ ] `terraform fmt -check` and `validate` pass for dev and prod in CI
- [ ] Backend uses S3 + `use_lockfile`, keys `dev/terraform.tfstate` and `prod/terraform.tfstate`
- [ ] Default tags Project/Env/ManagedBy applied
- [ ] Root outputs declared per the outputs contract (may be placeholders until modules land)
- [ ] No resources yet beyond what is required

## WFA-004: Deploy workflow works end to end for dev (empty stack)

**Workstream:** A (Platform & SRE) · **Milestone:** M1 Foundation & Design (Wk1) · **Depends on:** WFA-003

**Goal:** Prove OIDC + plan + apply from GitHub Actions to dev.

**Allowed paths (touch nothing else):**
- `.github/workflows/deploy.yml`
- `.github/workflows/plan.yml`

**Acceptance criteria:**
- [ ] Merge to main triggers deploy to dev using OIDC (no keys)
- [ ] Plan and apply logs visible; prod path blocked unless tag `v*`
- [ ] PR plan summary visible on a test PR touching infra
- [ ] Screenshots/log links in PR

## WFA-005: Validate and finalise data model with fixtures and schemas

**Workstream:** B (Data & Aggregation) · **Milestone:** M1 Foundation & Design (Wk1) · **Depends on:** -

**Goal:** Turn doc 03 into machine-checkable JSON Schemas and tiny fixtures that tests can use.

**Allowed paths (touch nothing else):**
- `data/schemas/**`
- `data/fixtures/**`
- `tests/unit/test_data_model.py`

**Acceptance criteria:**
- [ ] JSON Schema per table item (employees, leave_records, recruitment_events, analytics, attrition_risk)
- [ ] Fixture with 12 employees covering root, orphan, terminated, new joiner, cycle (invalid) cases
- [ ] Tests validate fixtures against schemas
- [ ] No change to doc 03 (if a gap is found, open an issue, do not edit the contract)

## WFA-006: Mock API responses from the OpenAPI contract

**Workstream:** C (API & Frontend) · **Milestone:** M1 Foundation & Design (Wk1) · **Depends on:** -

**Goal:** Create `frontend/mock/*.json` for all six endpoints so the UI can be built before the API exists.

**Allowed paths (touch nothing else):**
- `frontend/mock/**`
- `tests/contract/test_mock_matches_openapi.py`

**Acceptance criteria:**
- [ ] One JSON file per endpoint, realistic values for 8 departments and 12 months
- [ ] Contract test validates every mock against `docs/openapi.yaml` schemas
- [ ] Org-tree mock has 3+ levels and at least one warning example

## WFA-007: UI design direction proposal (needs lead approval before building)

**Workstream:** C (API & Frontend) · **Milestone:** M1 Foundation & Design (Wk1) · **Depends on:** -

**Goal:** Propose 2-3 visual directions (palette, typography, layout, light/dark) for the dashboard. No production UI yet.

**Allowed paths (touch nothing else):**
- `docs/ui-design-direction.md`
- `docs/img/ui-*.png (optional sketches)`

**Acceptance criteria:**
- [ ] Three directions with colours, fonts, layout sketch, chart styling
- [ ] Accessibility notes (contrast, colour-blind-safe chart palette)
- [ ] Lead picks one and records it in the doc; WFA-026+ do not start before this is approved

## WFA-008: Terraform module `data`: five DynamoDB tables

**Workstream:** A (Platform & SRE) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-003, WFA-005

**Goal:** Create `employees`, `leave_records`, `recruitment_events`, `analytics` (with TTL on `ttl`), `attrition_risk` exactly as doc 03.

**Allowed paths (touch nothing else):**
- `infra/modules/data/**`
- `infra/envs/*/main.tf (module call only)`

**Acceptance criteria:**
- [ ] Keys and types match doc 03
- [ ] Provisioned capacity matches the budget table (23/23 total), no GSI, no PITR
- [ ] TTL enabled on analytics `ttl`
- [ ] Outputs: table names/ARNs for compute and api modules
- [ ] `terraform plan` on dev shows only creates

## WFA-009: Deterministic seed script

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-005, WFA-008

**Goal:** `data/seed.py --env dev|prod` loads realistic dummy data into DynamoDB. Reference date 2026-11-27, seed 42.

**Allowed paths (touch nothing else):**
- `data/seed.py`
- `data/README.md`
- `data/names.py (if needed)`

**Acceptance criteria:**
- [ ] 80 active employees with department distribution from doc 03 + ~14 terminated in last 12 months
- [ ] Hierarchy: 1 root, depth <= 6, no cycles, managers valid
- [ ] Leave records never span months; performance scores 1-5 plausible
- [ ] Recruitment: ~25 candidates/month for 12 months
- [ ] Uses batch writes with exponential backoff; idempotent (second run changes nothing)
- [ ] `--dry-run` prints counts and a dataset checksum; same checksum every run
- [ ] Runs against moto in tests and against real dev tables

## WFA-010: Seed validation tests

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-009

**Goal:** Prove the seeded dataset satisfies every rule in doc 03.

**Allowed paths (touch nothing else):**
- `tests/unit/test_seed.py`

**Acceptance criteria:**
- [ ] Asserts counts, department distribution, hierarchy integrity, no month-spanning leave
- [ ] Asserts deterministic checksum equals a pinned value
- [ ] Runs in `make verify` in under 30 s

## WFA-011: Aggregator: headcount, hires, departures

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-005

**Goal:** Pure functions + tests for monthly headcount/hires/departures per department and totals, last 12 months.

**Allowed paths (touch nothing else):**
- `services/aggregator/metrics_headcount.py`
- `tests/unit/test_metrics_headcount.py`

**Acceptance criteria:**
- [ ] Definitions exactly as doc 03
- [ ] Edge cases tested: hire and termination in same month, termination at month end, first/last month
- [ ] Returns `{metric_name: {month: value}}` structure used by the handler

## WFA-012: Aggregator: leave utilisation and 3-month average

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-005

**Goal:** Compute `leave_util_<dept>` and `leave_util_3mo_avg_<dept>` per doc 03.

**Allowed paths (touch nothing else):**
- `services/aggregator/metrics_leave.py`
- `tests/unit/test_metrics_leave.py`

**Acceptance criteria:**
- [ ] Formula exactly as doc 03 (2 days/month/employee, 1 decimal)
- [ ] 3-month average uses the 3 months before the month; handles months with <3 prior months
- [ ] Zero-headcount department/month handled without division error

## WFA-013: Aggregator: recruitment funnel

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-005

**Goal:** Compute `funnel_*` cohort counts per month.

**Allowed paths (touch nothing else):**
- `services/aggregator/metrics_funnel.py`
- `tests/unit/test_metrics_funnel.py`

**Acceptance criteria:**
- [ ] Counts are cohort-based and monotonic non-increasing across stages
- [ ] Months with no candidates return zeros for all five stages

## WFA-014: Attrition risk scoring module

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-005

**Goal:** Pure function implementing doc 04 exactly, with per-factor points.

**Allowed paths (touch nothing else):**
- `services/aggregator/risk.py`
- `tests/unit/test_risk.py`

**Acceptance criteria:**
- [ ] Weights 0.40/0.35/0.25, tenure lookup and bands exactly as doc 04
- [ ] Worked example in doc 04 reproduced (87.5 High)
- [ ] Boundary tests: 39.9/40.0, 64.9/65.0, tenure 5/6/11/12/23/24/35/36/59/60, new joiner proration
- [ ] Decimal rounding half-up; deterministic ranking and tie-break

## WFA-015: Aggregator handler: orchestration, idempotent writes, EMF metrics, 12-month backfill

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-011, WFA-012, WFA-013, WFA-014

**Goal:** `handler.lambda_handler` reads source tables, calls metric modules, writes `analytics` and `attrition_risk` (PutItem overwrite), emits EMF metrics.

**Allowed paths (touch nothing else):**
- `services/aggregator/handler.py`
- `services/aggregator/io.py`
- `tests/unit/test_aggregator_handler.py`

**Acceptance criteria:**
- [ ] Accepts `{}` and `{"as_of":"YYYY-MM-DD"}`
- [ ] Writes every metric name in doc 03 for 12 months, plus risk rows and `risk_band_*`
- [ ] Running twice yields identical tables (moto test)
- [ ] Throttling handled with retries; fails loudly (exception) if write ultimately fails
- [ ] Emits `EmployeesProcessed`, `MetricsWritten`, `AggregatorSuccess` via EMF; no PutMetricData calls
- [ ] On success writes one `sys_aggregator_last_success` row (date = run timestamp, value = epoch seconds, ttl +7 days)

## WFA-016: Golden-file test

**Workstream:** B (Data & Aggregation) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-009, WFA-015

**Goal:** Pin aggregator output on seed data so accidental changes are caught.

**Allowed paths (touch nothing else):**
- `tests/golden/**`

**Acceptance criteria:**
- [ ] Test seeds moto with seed 42, runs aggregator with `as_of=2026-11-27`, compares to committed `expected_analytics.json` and `expected_risk.json`
- [ ] README explains how to regenerate and when that is allowed
- [ ] Intentional diff on a deliberate formula change is demonstrated in the PR

## WFA-017: Terraform module `compute`: aggregator Lambda + daily schedule

**Workstream:** A (Platform & SRE) · **Milestone:** M2 Data & Compute (Wk2) · **Depends on:** WFA-008, WFA-015

**Goal:** Deploy the aggregator with least-privilege IAM and EventBridge Scheduler (daily 01:00 IST).

**Allowed paths (touch nothing else):**
- `infra/modules/compute/**`
- `infra/envs/*/main.tf (module call only)`

**Acceptance criteria:**
- [ ] Function `wfa-<env>-aggregator`, python3.12, arm64, 512 MB, 120 s, zip from `build/aggregator.zip`
- [ ] IAM exactly as doc 02 table
- [ ] Log group retention 14 days
- [ ] Schedule enabled; manual test invoke succeeds in dev
- [ ] No wildcard resource ARNs

## WFA-018: Terraform module `auth`: Cognito

**Workstream:** A (Platform & SRE) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-003

**Goal:** User pool, groups `HR_Admin` and `Leadership`, public app client (auth code + PKCE, no secret), hosted UI domain.

**Allowed paths (touch nothing else):**
- `infra/modules/auth/**`
- `infra/envs/*/main.tf (module call only)`

**Acceptance criteria:**
- [ ] Pool `wfa-<env>-users`, email sign-in, no self sign-up
- [ ] Groups created; client callback/logout URLs use the CloudFront domain (and `http://localhost:8080` in dev only)
- [ ] Domain prefix `wfa-<env>-amit-cloudops`
- [ ] Outputs `cognito_user_pool_id`, `cognito_client_id`, `cognito_domain` per contract
- [ ] Stays on Lite/Essentials tier

## WFA-019: Shared Lambda library: auth, responses, errors, CORS

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-006

**Goal:** `services/shared` used by every API Lambda.

**Allowed paths (touch nothing else):**
- `services/shared/**`
- `tests/unit/test_shared.py`

**Acceptance criteria:**
- [ ] `require_group(event)` allows only `HR_Admin`/`Leadership`, returns 403 JSON error otherwise, 401 if claims missing
- [ ] `ok(body)` and `error(code, msg, status)` produce the exact shapes from OpenAPI incl. CORS headers
- [ ] Decimal-safe JSON serialisation
- [ ] Fully unit-tested

## WFA-020: API Lambda: `api_metrics` (headcount, leave, funnel, system health)

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-015, WFA-019

**Goal:** Serve `/metrics/headcount`, `/metrics/leave`, `/metrics/funnel` and `/system/health` from the analytics table (health reads the `sys_*` rows written by WFA-025).

**Allowed paths (touch nothing else):**
- `services/api_metrics/**`
- `tests/contract/test_api_metrics.py`

**Acceptance criteria:**
- [ ] Responses validate against OpenAPI schemas
- [ ] Months ascending; arrays aligned; missing data yields zeros not errors
- [ ] `months` and `month` query params validated (400 on bad input; add to OpenAPI only via lead)
- [ ] `/system/health` returns series for the last 60 min and aggregator status (ok if last success < 26 h, stale otherwise, unknown if never)
- [ ] Handler uses only `Query` on analytics

## WFA-021: API Lambda: `api_attrition` (top 10)

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-015, WFA-019

**Goal:** Serve `/attrition/top10` from `attrition_risk` and `analytics` distribution.

**Allowed paths (touch nothing else):**
- `services/api_attrition/**`
- `tests/contract/test_api_attrition.py`

**Acceptance criteria:**
- [ ] Exactly 10 (or fewer if fewer active) sorted by score desc, tie-break employee_id asc
- [ ] Each row has 3 factors with raw input and weighted points
- [ ] Distribution counts match `risk_band_*`
- [ ] Validates against OpenAPI

## WFA-022: API Lambda: `api_org` (recursive org tree)

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-005, WFA-019

**Goal:** Build nested tree from `manager_id` with recursion.

**Allowed paths (touch nothing else):**
- `services/api_org/**`
- `tests/unit/test_org_tree.py`
- `tests/contract/test_api_org.py`

**Acceptance criteria:**
- [ ] Single root; children sorted by name
- [ ] Cycle detected and broken with a warning; orphans attached to root with a warning; depth limit 15 with a warning
- [ ] Only ACTIVE employees included
- [ ] Validates against OpenAPI; tested with fixtures from WFA-005

## WFA-023: Terraform module `api`: HTTP API, JWT authorizer, routes

**Workstream:** A (Platform & SRE) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-017, WFA-018, WFA-020, WFA-021, WFA-022, WFA-025

**Goal:** Wire the three API Lambdas and the health route to API Gateway with Cognito JWT authorizer.

**Allowed paths (touch nothing else):**
- `infra/modules/api/**`
- `infra/envs/*/main.tf (module call only)`

**Acceptance criteria:**
- [ ] All 6 routes from OpenAPI exist, `GET` only, JWT authorizer on all
- [ ] CORS allows only the CloudFront origin (plus localhost in dev)
- [ ] Throttling burst 20 / rate 10; access logs retention 14 days
- [ ] Lambda IAM per doc 02; output `api_url`
- [ ] No-token request returns 401

## WFA-024: Contract test suite for all endpoints

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-020, WFA-021, WFA-022

**Goal:** One suite that exercises every API handler and validates against OpenAPI, including auth failures.

**Allowed paths (touch nothing else):**
- `tests/contract/**`

**Acceptance criteria:**
- [ ] Every route: 200 shape valid, 401 without claims, 403 without group
- [ ] Suite fails if a route is added to OpenAPI without a test
- [ ] Runs in `make verify`

## WFA-025: health_snapshot Lambda + 15-minute schedule

**Workstream:** A (Platform & SRE) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-008, WFA-015

**Goal:** Every 15 min read last 60 min of API Gateway and Lambda metrics and store `sys_*` rows in `analytics` (served to the UI by `api_metrics`, see WFA-020).

**Allowed paths (touch nothing else):**
- `services/health_snapshot/**`
- `infra/modules/monitoring/** (schedule + IAM only)`
- `tests/unit/test_health_snapshot.py`

**Acceptance criteria:**
- [ ] Writes `sys_api_requests`, `sys_api_5xx`, `sys_lambda_errors`, `sys_lambda_invocations` with TTL 7 days
- [ ] Uses `GetMetricData` once per run (batched)
- [ ] IAM: GetMetricData + PutItem on analytics only

## WFA-026: SPA shell: login (PKCE), tabs, config, API client

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-006, WFA-007, WFA-018

**Goal:** App shell with Cognito Hosted UI login, token handling, route guard, tab navigation, loading/error states, mock mode.

**Allowed paths (touch nothing else):**
- `frontend/index.html`
- `frontend/css/**`
- `frontend/js/**`

**Acceptance criteria:**
- [ ] Follows the approved design direction (WFA-007)
- [ ] Loads `config.json`; `?mock=1` uses `frontend/mock`
- [ ] PKCE auth-code flow, tokens kept in memory/sessionStorage, logout works
- [ ] Denied screen for users without group
- [ ] Chart.js and D3 from CDN pinned with SRI hashes

## WFA-027: Charts: headcount trend and leave utilisation

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-026

**Goal:** Grouped bar (hires vs departures) and horizontal bar (current vs 3-month avg).

**Allowed paths (touch nothing else):**
- `frontend/js/charts/headcount.js`
- `frontend/js/charts/leave.js`
- `frontend/css/**`

**Acceptance criteria:**
- [ ] Department filter for headcount chart
- [ ] Both charts keyboard/tooltips accessible, colour-blind-safe
- [ ] Work in mock mode and live mode

## WFA-028: Charts: recruitment funnel and risk distribution

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-026

**Goal:** Funnel (horizontal stages with conversion %) and doughnut (low/medium/high).

**Allowed paths (touch nothing else):**
- `frontend/js/charts/funnel.js`
- `frontend/js/charts/risk.js`

**Acceptance criteria:**
- [ ] Funnel shows 5 ordered stages with counts and conversion
- [ ] Doughnut uses thresholds from API response
- [ ] Empty-state handling

## WFA-029: Attrition table with sortable columns and factor breakdown

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-026

**Goal:** Top-10 table; click headers to sort; expandable factor details.

**Allowed paths (touch nothing else):**
- `frontend/js/attrition-table.js`

**Acceptance criteria:**
- [ ] Sortable by rank, name, department, score, band (asc/desc, indicated visually)
- [ ] Contributing factors visible per row (inputs and weighted points)
- [ ] Band shown with text + colour (not colour only)
- [ ] Keyboard accessible

## WFA-030: Org chart tab (D3)

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-026

**Goal:** Interactive tree in its own tab.

**Allowed paths (touch nothing else):**
- `frontend/js/org-chart.js`

**Acceptance criteria:**
- [ ] Expand/collapse nodes, zoom/pan, search by name highlights and focuses node
- [ ] Renders all ~80 active employees smoothly
- [ ] Shows API warnings if present
- [ ] Works in mock and live modes

## WFA-031: System health widget

**Workstream:** C (API & Frontend) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-026, WFA-020

**Goal:** Small panel showing API requests, 5xx, Lambda errors (last 60 min) and aggregator status.

**Allowed paths (touch nothing else):**
- `frontend/js/health-widget.js`

**Acceptance criteria:**
- [ ] Sparkline or small chart + totals
- [ ] Aggregator status badge (ok/stale/unknown) with last success time
- [ ] Auto-refreshes every 60 s without piling up requests

## WFA-032: Terraform module `frontend`: private S3 + CloudFront (OAC)

**Workstream:** A (Platform & SRE) · **Milestone:** M3 API, Auth & Frontend (Wk3) · **Depends on:** WFA-003

**Goal:** Host the SPA securely over HTTPS.

**Allowed paths (touch nothing else):**
- `infra/modules/frontend/**`
- `infra/envs/*/main.tf (module call only)`

**Acceptance criteria:**
- [ ] Bucket private with Block Public Access; only CloudFront OAC can read
- [ ] HTTP redirects to HTTPS, TLS 1.2+, SPA fallback to index.html for 403/404
- [ ] Response headers policy (HSTS, nosniff, frame deny, referrer policy, CSP allowing self, pinned CDNs, API and Cognito origins)
- [ ] Outputs `frontend_bucket`, `cloudfront_distribution_id`, `cloudfront_domain`
- [ ] Deploy workflow publishes `config.json` and syncs `frontend/`

## WFA-033: Accessibility and responsive pass

**Workstream:** ALL (Shared) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-027, WFA-028, WFA-029, WFA-030, WFA-031

**Goal:** Make the dashboard usable on phone and keyboard.

**Allowed paths (touch nothing else):**
- `frontend/**`

**Acceptance criteria:**
- [ ] Usable at 360 px width; tables scroll inside containers
- [ ] All interactive elements reachable by keyboard with visible focus
- [ ] Contrast meets WCAG AA; no information by colour alone
- [ ] Lighthouse accessibility score recorded in PR

## WFA-034: Terraform module `monitoring`: alarms, SNS, budgets visibility

**Workstream:** A (Platform & SRE) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-017, WFA-023

**Goal:** Alarms for aggregator no-success 26 h, Lambda errors, API 5xx, with SNS email.

**Allowed paths (touch nothing else):**
- `infra/modules/monitoring/**`
- `docs/11-runbook.md`

**Acceptance criteria:**
- [ ] Alarms exist per doc 02 SLO table; <= 10 alarms total
- [ ] SNS topic `wfa-<env>-alerts`; output `sns_alert_topic_arn`
- [ ] Runbook alert table verified against real alarm names

## WFA-035: Security hardening: tighten IAM, scan IaC

**Workstream:** A (Platform & SRE) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-023, WFA-032

**Goal:** Replace AdministratorAccess deploy roles with scoped policies; add IaC scanning.

**Allowed paths (touch nothing else):**
- `.github/workflows/ci.yml`
- `docs/09-bootstrap-console-guide.md`
- `docs/adr/**`

**Acceptance criteria:**
- [ ] Deploy roles scoped to `wfa-*` resources and required services only (documented policy)
- [ ] Checkov (or tfsec) runs in CI; findings triaged with written justifications
- [ ] No wildcard IAM actions/resources without justification
- [ ] ADR recording the final role design

## WFA-036: Game day on dev

**Workstream:** A (Platform & SRE) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-034

**Goal:** Break things on purpose and prove detection and recovery.

**Allowed paths (touch nothing else):**
- `docs/11-runbook.md`
- `docs/GAMEDAY.md`

**Acceptance criteria:**
- [ ] Scenarios run: aggregator fails, API 5xx, expired/invalid token, DynamoDB throttling, bad deploy rollback
- [ ] Each scenario: alarm fired (screenshot), time to detect, fix, runbook updated
- [ ] Gaps turned into issues

## WFA-037: Smoke test script

**Workstream:** A (Platform & SRE) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-023, WFA-032

**Goal:** `scripts/smoke.sh <env>` verifies a deployed environment end to end.

**Allowed paths (touch nothing else):**
- `scripts/smoke.sh`
- `docs/10-testing-strategy.md`

**Acceptance criteria:**
- [ ] Checks: SPA 200 over HTTPS, API 401 without token, 403 for no-group user, 200 on all 6 routes for HR_Admin user
- [ ] Exits non-zero on first failure with clear message
- [ ] Documented how to obtain test tokens (dev client only may enable USER_PASSWORD_AUTH; never prod)

## WFA-038: Production release v1.0.0

**Workstream:** A (Platform & SRE) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-035, WFA-036, WFA-037, WFA-033, WFA-039

**Goal:** Tag, approve and deploy to prod; tick the Definition of Done.

**Allowed paths (touch nothing else):**
- `docs/12-definition-of-done.md`
- `CHANGELOG.md`

**Acceptance criteria:**
- [ ] All DoD items ticked with evidence
- [ ] Prod deployed from tag `v1.0.0` via approval
- [ ] Cognito users + SNS subscription configured on prod
- [ ] `terraform plan` on prod shows no drift after deploy
- [ ] Budget shows $0

## WFA-039: Final architecture diagram, README polish, screenshots

**Workstream:** ALL (Shared) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-033

**Goal:** Export the diagram, add screenshots and live link, state limitations.

**Allowed paths (touch nothing else):**
- `README.md`
- `docs/02-architecture.md`
- `docs/img/**`

**Acceptance criteria:**
- [ ] Diagram image in `docs/img/`
- [ ] README has live demo link, 4+ screenshots, limitations statement from doc 04
- [ ] Repo About/topics set

## WFA-040: Demo script and project write-up

**Workstream:** ALL (Shared) · **Milestone:** M4 Operate, Harden & Release (Wk4) · **Depends on:** WFA-039

**Goal:** A 5-minute demo script and a short write-up for portfolio/LinkedIn.

**Allowed paths (touch nothing else):**
- `docs/DEMO.md`

**Acceptance criteria:**
- [ ] Step-by-step demo with expected screens
- [ ] Talking points: architecture, free-tier design, SRE practices, AI-assisted workflow with guardrails
- [ ] Each teammate's contribution described
