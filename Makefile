.PHONY: help verify lint test tf-validate package seed clean
ENV ?= dev

help: ## List targets
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-12s %s\n", $$1, $$2}'

verify: ## Run all local checks (same as CI)
	bash scripts/verify.sh

lint: ## Ruff lint for Python
	ruff check services data tests scripts

test: ## Run unit, contract and golden tests
	pytest -q tests

tf-validate: ## terraform fmt + validate for dev and prod
	terraform fmt -check -recursive infra
	@for e in dev prod; do \
	  if ls infra/envs/$$e/*.tf >/dev/null 2>&1; then \
	    terraform -chdir=infra/envs/$$e init -backend=false -input=false >/dev/null && \
	    terraform -chdir=infra/envs/$$e validate; \
	  fi; \
	done

package: ## Build Lambda zips into build/
	bash scripts/package.sh

seed: ## Seed DynamoDB for ENV (dev|prod)
	python data/seed.py --env $(ENV)

clean: ## Remove build output
	rm -rf build .pytest_cache .ruff_cache
