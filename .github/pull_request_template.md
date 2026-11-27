## Issue
Closes #<issue-number>  (title format: `WFA-<id>: <summary>`)

## What changed (and why)
<!-- 2-5 lines -->

## Files touched
<!-- List them. Every file must be inside the issue's allowed paths. -->

## Verification
- [ ] `make verify` green **before** my change
- [ ] `make verify` green **after** my change
- [ ] Acceptance criteria from the issue are met (paste evidence: test output, screenshot, curl output)

## Blast radius
- [ ] I did not change contracts (`openapi.yaml`, data model, scoring, outputs contract), **or** I added an ADR and updated every consumer
- [ ] No unrelated refactors, renames, formatting or dependency changes
- [ ] No new AWS service outside `docs/08-free-tier-guardrails.md`
- [ ] Terraform plan reviewed: **no unexpected destroy/replace** (paste summary if infra changed)

## AI assistance
- [ ] Not used  /  [ ] Used ChatGPT following `docs/CHATGPT_BUILDER_PLAYBOOK.md`

## Notes for reviewer
<!-- Risks, follow-ups, things you were unsure about -->
