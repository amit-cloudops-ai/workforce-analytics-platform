# bootstrap/

One-time account setup only. Follow `docs/09-bootstrap-console-guide.md` in order.
Terraform state bucket, GitHub OIDC provider and IAM roles are bootstrapped before
the environment roots can initialize. Do not put credentials or state files here.
