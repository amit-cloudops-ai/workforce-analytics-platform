# 08. Free-tier guardrails

> AWS changes free-tier terms. **Before building**, open Billing and Cost Management → Free Tier and note (a) whether the account is on the newer time-limited free plan or the older 12-month model, and (b) the expiry date. Re-check monthly.

## Allowed services (and how we stay free)
| Service | Our usage | Limit we respect |
|---|---|---|
| Lambda | 5 functions, arm64, ≤512 MB | well under 1M requests / 400k GB-s monthly |
| DynamoDB | 5 tables, **provisioned** | ≤ 25 RCU + 25 WCU total (doc 03); storage ≪ 25 GB |
| API Gateway (HTTP API) | 6 routes, throttled | low request volume; watch the free-tier counter |
| S3 | 2 buckets (site, tf state), tiny | small storage and requests |
| CloudFront | 1 distribution | always-free monthly transfer/requests |
| Cognito | 1 user pool, a handful of users | stay on Lite/Essentials, **never Plus** |
| EventBridge Scheduler | 2 schedules | free quota |
| CloudWatch | Logs (14-day retention), metrics, ≤10 alarms, EMF custom metrics ≤10 | stay under free quotas |
| SNS | email alerts | free email quota |
| IAM, Budgets (≤2 free budgets), STS | | free |

## Banned (cost money or add risk)
NAT Gateway, ALB/NLB, EC2/EBS, RDS/Aurora, WAF, Secrets Manager, custom KMS keys, VPC endpoints, Lambda inside a VPC, DynamoDB on-demand mode, DynamoDB PITR/backups, DAX, X-Ray, Route 53 hosted zones, ACM Private CA, Cognito Plus features (advanced security), CloudTrail extra trails, GuardDuty/Config/Inspector/Macie, Amplify Hosting, and any service not in the table above.

## Cost controls
1. AWS Budget: cost budget **$1** with email alerts at 50% actual, 100% actual and 100% forecast; plus a Zero-Spend budget.
2. Log retention 14 days on every log group (set in Terraform).
3. Monthly 5-minute check: Billing → Free Tier usage page; Cost Explorer by service.
4. Health snapshot reads CloudWatch every **15 min** (not per user request) to avoid `GetMetricData` charges.
5. API Gateway throttling on, so a loop or abuse cannot burn quota.
6. `terraform destroy` for `dev` is documented in the runbook when not demoing.

## Things that silently cost money (watch out)
- DynamoDB tables created in the Console as on-demand by default → always provisioned via Terraform.
- Extra CloudWatch dashboards beyond 3, detailed monitoring, high-resolution custom metrics.
- Public IPv4 addresses (we have none).
- Orphaned resources after manual Console experiments: tag everything, delete experiments.
