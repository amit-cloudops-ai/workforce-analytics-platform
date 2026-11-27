# 09. One-time bootstrap (AWS Console + GitHub UI)

Workstream A owner does this once. Values are pre-filled. Region everywhere: **ap-south-1 (Mumbai)**. Tick each box.

## Part 1: AWS account safety (10 min)
- [ ] **Billing and Cost Management → Free Tier:** write down plan type and expiry date in the project channel.
- [ ] **Root user:** IAM → *Security credentials* → enable MFA on root. Stop using root after this.
- [ ] **Admin identity:** IAM → Users → Create user `amit-admin` → Attach `AdministratorAccess` → enable MFA. Use this user for all Console work.
- [ ] **Budgets:** Billing → Budgets → Create budget → *Customize (advanced)* → *Cost budget* → name `wfa-monthly-1usd`, monthly, **$1** → alerts at 50% actual, 100% actual, 100% forecast → your email.
- [ ] **Budgets (2nd):** Create budget → *Use a template* → *Zero spend budget* → your email.
- [ ] **Billing preferences:** enable *Free Tier usage alerts* and *CloudWatch billing alerts* to your email.

## Part 2: Terraform state bucket
- [ ] S3 → Create bucket → name `wfa-tfstate-amit-cloudops-ap-south-1` (if taken, append `-01` and update both `backend.tf` files) → region ap-south-1 → **Block all public access: ON** → **Bucket Versioning: Enable** → default encryption SSE-S3.

## Part 3: GitHub → AWS trust (OIDC)
- [ ] IAM → Identity providers → *Add provider* → OpenID Connect → Provider URL `https://token.actions.githubusercontent.com` → Audience `sts.amazonaws.com` → Add.
- [ ] IAM → Roles → *Create role* → *Web identity* → Identity provider `token.actions.githubusercontent.com` → Audience `sts.amazonaws.com` → GitHub organization `amit-cloudops-ai` → Repository `workforce-analytics-platform` → Next.
  - Role 1: name **`wfa-github-deploy-dev`**, permission `AdministratorAccess` (temporary, tightened in WFA-035).
  - Role 2: name **`wfa-github-deploy-prod`**, permission `AdministratorAccess` (temporary, tightened in WFA-035).
  - Role 3 (optional, enables PR plans): name **`wfa-github-plan`**, permission `ReadOnlyAccess`.
- [ ] For each role: IAM → Roles → open role → *Trust relationships* → *Edit trust policy* → in the `Condition`, set the `token.actions.githubusercontent.com:sub` value (and keep `:aud` = `sts.amazonaws.com`):

| Role | `sub` value |
|---|---|
| `wfa-github-deploy-dev` | `repo:amit-cloudops-ai/workforce-analytics-platform:environment:dev` |
| `wfa-github-deploy-prod` | `repo:amit-cloudops-ai/workforce-analytics-platform:environment:prod` |
| `wfa-github-plan` | `repo:amit-cloudops-ai/workforce-analytics-platform:pull_request` |

  Use `StringEquals` for `aud` and `sub`. Do **not** use wildcards for `sub`.
- [ ] Copy each role's ARN (role page → ARN).

## Part 4: GitHub repository settings
**Make the repo public** (all data is dummy, no secrets). On a free personal account, branch protection and environment approvals are not available for private repos.

- [ ] Settings → Collaborators → add `sush-kush` and `dggk78` with **Write** (not Admin).
- [ ] Settings → Rules → Rulesets → *New branch ruleset* → name `protect-main` → target `main` → enforcement *Active* → enable: *Restrict deletions*, *Require a pull request before merging* (1 approval, **Require review from Code Owners**, dismiss stale approvals), *Require status checks to pass* (add `pr-title`, `verify`, `terraform`, `secrets` after the first CI run), *Block force pushes*, *Require linear history*. No bypass list.
- [ ] Settings → General → Pull Requests → allow **squash merging** only; auto-delete head branches.
- [ ] Settings → Environments → New environment `dev` (no rules). New environment `prod` → *Required reviewers*: `amit-cloudops-ai` → *Deployment branches and tags*: selected → add tag rule `v*`.
- [ ] Settings → Secrets and variables → Actions → **Variables** tab (not Secrets):
  - `AWS_ROLE_ARN_DEV` = ARN of `wfa-github-deploy-dev`
  - `AWS_ROLE_ARN_PROD` = ARN of `wfa-github-deploy-prod`
  - `AWS_ROLE_ARN_PLAN` = ARN of `wfa-github-plan` (if created)
- [ ] Settings → Code security → enable *Secret scanning* and *Push protection*.
- [ ] Repo → Issues → create labels, milestones and issues: `python3 scripts/create_github_issues.py --repo amit-cloudops-ai/workforce-analytics-platform --apply` (needs `gh auth login` first; run without `--apply` to preview).

## Part 5: After first successful deploy to dev (Workstream A)
- [ ] **Cognito users:** Cognito → User pools → `wfa-dev-users` → *Users* → Create user (email + temporary password) for: an HR admin, a leader, and a no-group user (for the 403 test). Then *Groups* → `HR_Admin` / `Leadership` → *Add user to group*.
- [ ] **SNS:** SNS → Topics → `wfa-dev-alerts` → Subscriptions → confirm the email subscription (click the link in the email).
- [ ] **Smoke test:** see `scripts/smoke.sh` once WFA-037 is done.
- [ ] Repeat Cognito/SNS steps for `prod` after the first prod release.

## Naming reference (pre-filled)
| Thing | dev | prod |
|---|---|---|
| Resource prefix | `wfa-dev-` | `wfa-prod-` |
| Cognito hosted-UI domain prefix | `wfa-dev-amit-cloudops` | `wfa-prod-amit-cloudops` |
| Terraform state key | `dev/terraform.tfstate` | `prod/terraform.tfstate` |
| GitHub Environment | `dev` | `prod` |
