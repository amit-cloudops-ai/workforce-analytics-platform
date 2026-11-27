# ADR-0007: Attrition risk is a documented weighted heuristic

- Status: Accepted
- Date: 2026-11-27
- Deciders: Amit, Sushmitha M, GopiKrishna

## Context
We have dummy data and need explainability for HR users; ML on synthetic data would be meaningless and unexplainable.

## Decision
Weighted formula `0.40 P + 0.35 L + 0.25 T` with fixed bands (doc 04). Per-factor points shown in the UI.

## Alternatives considered
- ML model: no real labels, not explainable here.
- Single-factor score: too crude.

## Consequences
Weights are judgement-based; limitations must be stated in README and demo. Formula changes need an ADR and regenerated golden files.
