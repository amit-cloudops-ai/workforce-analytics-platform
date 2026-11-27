# infra/

Terraform for everything in AWS. Never click-create resources that Terraform should own.

```
infra/
  bootstrap/        # manual one-time steps (docs/09), nothing applied by CI
  envs/dev|prod/    # root modules: backend, provider, module calls, outputs (contract)
  modules/          # data, compute, api, auth, frontend, monitoring
```

Rules: `terraform fmt`, pinned provider range, tags via provider `default_tags`, least-privilege IAM per function, free-tier guardrails (docs/08), outputs contract (docs/02). Module changes must show a clean `terraform plan` with no unexpected destroy/replace.
