# prod environment

Root module for `prod`. Resource prefix: `wfa-prod-`. State: `s3://wfa-tfstate-amit-cloudops-ap-south-1/prod/terraform.tfstate`.

Modules are called from `main.tf` (added by issues WFA-003, 008, 017, 018, 023, 032, 034).
Root **outputs are a contract**: see `docs/02-architecture.md`.

```
terraform -chdir=infra/envs/prod init
terraform -chdir=infra/envs/prod plan
```

Deploys run through GitHub Actions (OIDC). Do not `apply` from a laptop except in an emergency, and then note it in the runbook.
