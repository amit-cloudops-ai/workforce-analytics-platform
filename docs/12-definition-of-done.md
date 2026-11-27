# 12. Definition of done (the finish line)

The project is finished when every box is ticked on **prod** with evidence (link, screenshot or command output) in the final PR/release notes.

## Functional
- [ ] HTTPS URL opens a login page; login works with a `HR_Admin` user
- [ ] Login works with a `Leadership` user
- [ ] A Cognito user in **no** group is denied (UI message + API 403)
- [ ] Headcount chart: hires vs departures per department, 12 months
- [ ] Leave utilisation chart: current month vs 3-month average per department
- [ ] Recruitment funnel chart with 5 ordered stages
- [ ] Risk distribution chart (low/medium/high)
- [ ] Attrition table: top 10, sortable columns, contributing factors visible
- [ ] Org chart tab: interactive, expand/collapse, search, handles the whole tree
- [ ] System health widget shows API request counts and Lambda errors
- [ ] 4+ distinct chart types are on screen (e.g. grouped bar, horizontal bar, funnel, doughnut)

## Data and pipeline
- [ ] Seed script creates ~80 active employees, deterministic (same checksum twice)
- [ ] EventBridge runs the aggregator daily; last success visible in health widget
- [ ] Aggregator re-run produces identical results (idempotent)
- [ ] Golden test green

## Engineering quality
- [ ] Everything created by Terraform; `terraform plan` on prod shows no changes after deploy
- [ ] CI green on `main` (verify, terraform, secrets)
- [ ] Dev auto-deploys on merge; prod deploys only from a `v*` tag with approval
- [ ] No long-lived AWS keys anywhere; deploys via OIDC
- [ ] IAM roles reviewed for least privilege; no wildcard resources without justification
- [ ] Smoke test passes on prod

## Operations
- [ ] Alarms (aggregator, Lambda errors, API 5xx) exist and were proven in a game day
- [ ] AWS Budget alerts configured; Billing shows $0
- [ ] Runbook is complete and tested

## Documentation deliverables
- [ ] Attrition formula documented with inputs, weights, thresholds (`docs/04-scoring.md`)
- [ ] Architecture diagram (README + `docs/02-architecture.md` + exported image in `docs/img/`)
- [ ] Seed script documented (`data/README.md`)
- [ ] README has live demo link, screenshots, and the limitations statement
- [ ] Demo script written (`docs/DEMO.md`)
