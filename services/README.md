# services/

Python 3.12 Lambda code. Layout (packaging contract, docs/02):

```
services/<function>/handler.py   # entrypoint: lambda_handler(event, context)
services/shared/                 # auth, response, error helpers used by api_* functions
```

`bash scripts/package.sh` → `build/<function>.zip` (handler + shared + optional `requirements.txt`).
Prefer the Lambda runtime's built-in `boto3`; add dependencies only when unavoidable and pin them.

| Function | Owner WS | Purpose |
|---|---|---|
| aggregator | B | daily metrics + risk scoring |
| health_snapshot | A | 15-min CloudWatch snapshot |
| api_metrics | C | /metrics/* and /system/health |
| api_attrition | C | /attrition/top10 |
| api_org | C | /org/tree |
| shared | C | auth + response helpers |
