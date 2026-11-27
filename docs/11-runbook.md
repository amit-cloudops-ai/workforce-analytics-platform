# 11. Runbook

Console-first steps (region **ap-south-1** unless stated). Fill/extend as the system is built; Workstream A owns this file.

## Where to look
| Need | Console path |
|---|---|
| Is the aggregator running? | CloudWatch → Log groups → `/aws/lambda/wfa-prod-aggregator` |
| API errors / latency | CloudWatch → Metrics → ApiGateway → `wfa-prod-api` |
| Lambda errors | Lambda → `wfa-prod-<function>` → Monitor tab |
| Alarms | CloudWatch → Alarms |
| Data | DynamoDB → Tables → `wfa-prod-analytics` → Explore items |
| Spend | Billing and Cost Management → Free Tier / Budgets |
| Users and groups | Cognito → User pools → `wfa-prod-users` |

## Alerts and first response
| Alarm | Meaning | First steps |
|---|---|---|
| `aggregator-no-success-26h` | Daily job missed | Check EventBridge Scheduler target, Lambda logs; run Lambda manually with test event `{}`; check DynamoDB throttling |
| `lambda-errors-<fn>` | A function errored | Open its log group, read stack trace, roll back via previous tag if caused by a deploy |
| `api-5xx` | Server errors | Check the same Lambda's logs; check DynamoDB `ThrottledRequests` |
| Budget alert | Spend appeared | Billing → Cost Explorer → group by service; delete the offender; see doc 08 |

## Common tasks
- **Re-run aggregation now:** Lambda → `wfa-<env>-aggregator` → Test → event `{}` (or `{"as_of":"2026-11-27"}`).
- **Add a dashboard user:** Cognito → user pool → Users → Create user → then Groups → add to `HR_Admin` or `Leadership`.
- **Re-seed data:** run `make seed ENV=dev` (idempotent).
- **Roll back prod:** Actions → deploy → Run workflow → env `prod`, ref = previous tag.
- **Stop paying attention to dev:** `terraform -chdir=infra/envs/dev destroy` (state bucket and OIDC provider stay).

## Disaster notes
All data is derived from seeded source tables and can be recreated by `make seed` + running the aggregator. There are no backups to restore, by design (dummy data, free tier).
