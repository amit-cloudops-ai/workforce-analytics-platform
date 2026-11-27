# Contributing

1. Pick an issue assigned to you (see `docs/BACKLOG.md`).
2. Branch: `wfa-<issue-number>-<slug>` from latest `main`.
3. Read `AGENTS.md`. If ChatGPT helps you, follow `docs/CHATGPT_BUILDER_PLAYBOOK.md`.
4. `make verify` before and after your change.
5. Open a PR titled `WFA-<id>: <summary>` using the template. CODEOWNERS review is required.
6. Squash-merge. Never push to `main`.

Commit style: `feat|fix|docs|infra|test|chore(<area>): message` (area = `data`, `api`, `frontend`, `infra`, `ci`).
