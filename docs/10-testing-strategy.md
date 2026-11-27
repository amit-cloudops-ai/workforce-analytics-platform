# 10. Testing strategy

| Layer | Where | Tooling | What it proves |
|---|---|---|---|
| Unit | `tests/unit/` | pytest | Risk scoring boundaries, metric math, tree builder (cycles/orphans/depth), auth helper |
| Seed validation | `tests/unit/test_seed.py` | pytest | 80 active, depth ≤ 6, one root, no cycles, deterministic checksum |
| Pipeline (moto) | `tests/unit/` | pytest + moto | Aggregator against fake DynamoDB, idempotent on re-run |
| **Golden** | `tests/golden/` | pytest | With seed 42 and `as_of=2026-11-27`, aggregator output equals `tests/golden/expected_analytics.json` and `expected_risk.json`. **Any accidental change to computation fails here.** |
| **Contract** | `tests/contract/` | pytest + jsonschema | Each API Lambda's response validates against `docs/openapi.yaml` schemas; 401/403 behaviour |
| Infra | CI | terraform fmt/validate, PR plan | No syntax errors; plan reviewed for destroy/replace |
| Security | CI | gitleaks; checkov (from phase 8) | No secrets; IaC misconfigurations reviewed |
| Smoke / E2E | `scripts/smoke.sh` (WFA-037) | curl | Dev/prod: unauthenticated = 401, wrong group = 403, correct group = 200 on all 6 routes, SPA loads over HTTPS |
| Game day | runbook | manual | Break the aggregator / revoke permission / bad token → alarms fire, runbook works |

## Regenerating golden files
Only when the formula or seed intentionally changes: run the generator documented in `tests/golden/README.md`, review the diff line by line, and mention it in the PR.

## Rule
A bug fix includes a test that fails before the fix and passes after.
