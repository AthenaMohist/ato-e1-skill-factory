# agent-token-budget

Measurable token budgets for agents that run unattended. **An unmetered agent is an incident waiting for the bill** — budgets that are not measured are wishes.

Part of [ato-e1-skill-factory](https://github.com/AthenaMohist/ato-e1-skill-factory). Pairs with [git-backup-discipline](../git-backup-discipline/README.md).

## Install

```bash
npx skills add AthenaMohist/ato-e1-skill-factory
# or copy skills/agent-token-budget into your skills directory
```

## What you get

- `SKILL.md` — the discipline: a budget contract (`TOKENS.budget.yml`), four rules (measure first, input discipline, outputs-not-narration, every loop has a cap), and explicit breach behavior.
- `scripts/budget_check.sh` — validates the contract, sums today's usage from the meter log, exits 1 (fail-closed) on breach when `on_breach: halt-and-log`. GNU/BSD portable.
- `scripts/log_usage.sh` — appends one meter line per run: date, run id, input, output, verdict.
- `examples/TOKENS.budget.yml.example` — starting contract.

## Quick start

```bash
cp examples/TOKENS.budget.yml.example ./TOKENS.budget.yml
./scripts/log_usage.sh run-42 48000 3200 ok
./scripts/budget_check.sh
```

## Why not just "be concise"?

Because unenforced advice decays. This skill makes token spend a first-class state file: the log is the source of truth, the check is a pre-flight gate you can wire into any cron or watchdog, and breaches have a declared behavior instead of a surprise bill.

MIT licensed. See `SKILL.md` for the full discipline.
