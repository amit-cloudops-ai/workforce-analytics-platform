# 06. SDLC roadmap (zero to hero)

Timeline assumes **4 weeks** and can be stretched; phase order and exit criteria must not change. Each phase maps to a GitHub milestone and to issues in [`BACKLOG.md`](BACKLOG.md).

| Phase | Wk | Goal | Exit criteria (all must be true) |
|---|---|---|---|
| **0 Requirements** | 1 | Scope agreed | Charter + requirements merged; issues and milestones created |
| **1 Design** | 1 | Contracts frozen | `openapi.yaml`, data model, scoring, architecture, ADRs merged; design direction for UI approved by lead |
| **2 Foundation** | 1 | Pipeline to AWS works | Branch protection on; AWS bootstrap done; Terraform skeleton validates in CI; deploy workflow assumes OIDC role and applies an empty dev stack |
| **3 Data layer** | 2 | Data exists | 5 tables via Terraform within 23/23 capacity; seed script deterministic and passing validation tests |
| **4 Compute** | 2 | Metrics computed | Aggregator + risk scoring unit-tested; golden test green; EventBridge runs it daily in dev; `analytics` holds 12 months |
| **5 API + Auth** | 3 | Secure API | Cognito pool/groups/client; HTTP API with JWT authorizer; all 6 routes pass contract tests; non-group user gets 403 |
| **6 Frontend** | 3 | Dashboard usable | Visual direction approved; login works; 4+ chart types, sortable table, org chart, health widget; served via CloudFront |
| **7 Observability** | 4 | Operable | Alarms + SNS email; budget alerts; health widget live; runbook written |
| **8 Hardening** | 4 | Production-ready | IAM least-privilege review; secret scan clean; checkov reviewed; smoke test + game day completed on dev |
| **9 Release** | 4 | Live | `v1.0.0` tag; approved prod deploy; DoD fully ticked; demo script + screenshots in README |

## Parallelism rules
- Phase 1 contracts unblock everyone. Nobody builds before they are merged.
- **Frontend (C)** builds against `frontend/mock/*.json` (generated from the OpenAPI examples) so it never waits for the API.
- **API (C)** builds against seeded dev tables or `moto`, so it never waits for the aggregator, but the metric names in `03-data-model.md` are fixed.
- **Platform (A)** modules are written to the outputs contract in `02-architecture.md`.

## Gates between phases
Lead reviews the phase's exit criteria checklist in the milestone and closes the milestone. Next phase PRs are not merged before.

## Release process
1. All DoD items green on dev.
2. Lead tags `v1.0.0` on `main`.
3. Actions → deploy → `Run workflow` → environment `prod`, ref = the tag → approve.
4. Run the smoke test against prod; tick DoD.

## Rollback
Re-run the deploy workflow on the previous tag. Data is derived and re-creatable (re-run aggregator). No stateful destroy on rollback.
