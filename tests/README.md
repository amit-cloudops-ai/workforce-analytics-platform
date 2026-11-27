# tests/

- `unit/`: pure logic, seed validation, moto-backed handler tests
- `contract/`: API responses vs docs/openapi.yaml; auth failures
- `golden/`: pinned aggregator output on the deterministic seed

Run all: `make test` (or `make verify`). Strategy: docs/10-testing-strategy.md.
