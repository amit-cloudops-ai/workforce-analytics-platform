# ChatGPT builder playbook

ChatGPT writes much of the code. **The plan, contracts and rules live in this repo, not in the chat.** Every session starts by loading them. Never give ChatGPT AWS credentials, passwords or admin access to the repo; it proposes changes, humans (and CI) approve and deploy.

## How ChatGPT gets changes into the repo (use whichever your plan supports)
- **Connected GitHub:** let it read the repo and open a branch/PR named `wfa-<issue>-<slug>`.
- **No write access:** ask it to output **complete files** with their paths; you create the branch, paste the files, commit, push, open the PR.

## Session-start prompt (paste at the beginning of every new chat)
```
You are a senior cloud/DevOps engineer working on the repo
https://github.com/amit-cloudops-ai/workforce-analytics-platform.

Before doing anything, read these files fully and follow them as binding rules:
AGENTS.md, docs/00-project-charter.md, docs/02-architecture.md, docs/03-data-model.md,
docs/04-scoring.md, docs/openapi.yaml, docs/08-free-tier-guardrails.md,
docs/12-definition-of-done.md.

Rules: AWS free tier only, region ap-south-1. Touch ONLY the paths allowed by the issue.
Do not change contracts (openapi.yaml, data model, scoring, outputs contract) unless the issue says so.
No drive-by edits, no dependency upgrades, no new AWS services outside the allowed list.
Always tell me how to verify (make verify + specific test/command) and what could break.
If a fix fails twice, stop and explain instead of patching further.

Confirm you have read the files by summarising, in 6 bullets, the architecture and the rules
you must follow. Then wait for the issue.
```

## Task prompt (one per issue)
```
Work on issue WFA-<id>: <title>
Issue text:
<paste the full issue from docs/BACKLOG.md or GitHub>

Allowed paths: <paste>
Acceptance criteria: <paste>

Steps:
1. Restate the task and list the exact files you will create/modify (must be inside allowed paths).
2. Name which contracts this touches and confirm none are changed.
3. Implement with the smallest possible diff.
4. Add/adjust tests in the allowed test paths.
5. Give me: the commands to run (make verify + targeted), expected output, and a short
   "blast radius" note (what else could be affected and why it is not).
```

## Fix-a-failure prompt
```
CI/verify failed. Output below. Fix ONLY the cause, with the smallest diff, inside the same allowed paths.
Do not touch anything that was passing. After the fix, list every file changed and why,
and which tests prove nothing else broke. If this needs a file outside the allowed paths, stop and tell me.
<paste log>
```

## Review checklist for humans (before approving an AI PR)
- [ ] Only allowed paths changed (check "Files changed" tab)
- [ ] No contract files changed unintentionally
- [ ] No new dependencies, services, or wildcard IAM
- [ ] Tests added and meaningful; golden/contract tests still green
- [ ] Terraform plan has no unexpected destroy/replace
- [ ] No secrets, account IDs, ARNs hard-coded
- [ ] You can explain what the change does (if not, do not merge)

## Anti-chaos rules
- One chat per issue (long chats drift). Start a fresh chat and paste the session-start prompt again.
- Paste real files/logs; do not describe from memory.
- If ChatGPT suggests a "better design", that is a proposal for an ADR, not something to slip into a task.
