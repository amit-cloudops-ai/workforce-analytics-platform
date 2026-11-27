#!/usr/bin/env bash
# Single entrypoint for local + CI checks. Safe to run on an empty scaffold:
# each stage runs only when there is something to check.
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
step() { printf '\n== %s ==\n' "$1"; }
bad()  { echo "FAIL: $1"; fail=1; }

step "Required files"
required=(
  README.md AGENTS.md Makefile LICENSE .gitignore
  .github/CODEOWNERS .github/pull_request_template.md
  .github/workflows/ci.yml .github/workflows/deploy.yml
  docs/00-project-charter.md docs/01-requirements.md docs/02-architecture.md
  docs/03-data-model.md docs/04-scoring.md docs/openapi.yaml
  docs/06-sdlc-roadmap.md docs/07-team-and-workstreams.md
  docs/08-free-tier-guardrails.md docs/09-bootstrap-console-guide.md
  docs/12-definition-of-done.md docs/BACKLOG.md docs/backlog.json
)
for f in "${required[@]}"; do [[ -f "$f" ]] || bad "missing $f"; done

step "OpenAPI contract"
if python3 -c "import yaml, openapi_spec_validator" 2>/dev/null; then
  python3 - <<'PY' || bad "docs/openapi.yaml is invalid"
import yaml
from openapi_spec_validator import validate
spec = yaml.safe_load(open("docs/openapi.yaml"))
validate(spec)
print("openapi.yaml valid;", len(spec["paths"]), "paths")
PY
else
  echo "skip (pip install -r requirements-dev.txt to enable)"
fi

step "Backlog JSON"
python3 -c "import json; d=json.load(open('docs/backlog.json')); print(len(d['issues']), 'issues')" || bad "docs/backlog.json invalid"

step "Lint (ruff)"
if command -v ruff >/dev/null 2>&1; then
  if find services data tests scripts -name '*.py' 2>/dev/null | grep -q .; then
    ruff check services data tests scripts || bad "ruff"
  else
    echo "no python files yet"
  fi
else
  echo "skip (ruff not installed)"
fi

step "Tests (pytest)"
if find tests -name 'test_*.py' 2>/dev/null | grep -q .; then
  if command -v pytest >/dev/null 2>&1; then pytest -q tests || bad "pytest"; else bad "pytest not installed"; fi
else
  echo "no tests yet"
fi

step "Terraform"
if command -v terraform >/dev/null 2>&1; then
  terraform fmt -check -recursive infra || bad "terraform fmt"
  for e in dev prod; do
    if ls infra/envs/$e/*.tf >/dev/null 2>&1; then
      terraform -chdir=infra/envs/$e init -backend=false -input=false >/dev/null && \
        terraform -chdir=infra/envs/$e validate || bad "terraform validate ($e)"
    fi
  done
else
  echo "skip (terraform not installed)"
fi

echo
if [[ $fail -eq 0 ]]; then echo "VERIFY: PASS"; else echo "VERIFY: FAIL"; fi
exit $fail
