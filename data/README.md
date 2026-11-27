# data/ (Workstream B)

`seed.py` loads deterministic dummy HRMS data (seed 42, reference date 2026-11-27) into DynamoDB:
~80 active + ~14 terminated employees, leave records, 12 months of recruitment candidates. Rules: docs/03-data-model.md.

```
python data/seed.py --env dev --dry-run   # counts + checksum, no writes
python data/seed.py --env dev             # idempotent load with backoff
```

Also holds `schemas/` (JSON Schema per table) and `fixtures/` for tests. Issues WFA-005, 009, 010.
