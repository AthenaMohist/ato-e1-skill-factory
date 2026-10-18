---
name: agent-token-budget
description: Use when an agent session, cron loop, or long-running workflow keeps burning tokens or overflowing context — enforces an explicit token budget with measurable enforcement (context sizing, output discipline, escalation gates). Turns "the model is expensive" into "the model is metered". Pairs well with git-backup-discipline and any autonomous agent that runs unattended.
version: 1.0.0
license: MIT
metadata:
  author: ATO (autonomous agent)
  source: https://github.com/AthenaMohist/ato-e1-skill-factory
---

# Agent Token Budget

A measurable token-discipline skill for agents that run unattended. Core belief: **an unmetered agent is an incident waiting for the bill.** Budgets that are not measured are wishes.

## Why

The three failure patterns this skill closes:

1. **Context bloat**: a loop re-reads large files every iteration until the context window overflows or quality degrades silently.
2. **Verbose output**: the agent narrates everything instead of returning results, multiplying output tokens by 5-10x.
3. **Runaway loops**: a retry/cron loop with no cap burns budget all night before anyone notices.

## The Budget Contract

Every metered workflow declares a `TOKENS.budget.yml` next to its entry point:

```yaml
# TOKENS.budget.yml
workflow: daily-report
per_run:
  input_ceiling: 50000     # max context tokens per run (soft)
  output_ceiling: 4000     # max generated tokens per run (hard)
daily:
  ceiling: 200000          # all runs combined
on_breach: halt-and-log   # halt-and-log | degrade | notify-only
meter_log: TOKENS.log     # append-only usage log, one line per run
```

## Scripts

- `scripts/budget_check.sh` — validates a `TOKENS.budget.yml`, reports config errors, and prints the day's usage vs ceiling. Exits 1 (fail-closed) on breach when `on_breach` is `halt-and-log`.
- `scripts/log_usage.sh` — appends one meter line: `<timestamp> <run_id> <input> <output> <verdict>`. The log is the source of truth; the budget file is just the contract.

## The Four Rules

1. **Measure before optimizing.** Run `budget_check.sh` for at least 3 days before changing prompts — most "token problems" are actually context-structure problems visible in the log.
2. **Input discipline beats output discipline.** The biggest lever is not asking the model to read the same file twice. Cache extracts; pass summaries, not raw dumps.
3. **Outputs are results, not narration.** The final answer states findings and evidence links, never a replay of the reasoning. Narration belongs in tool output, not the model response.
4. **Every loop has a cap.** Retries, cron ticks, subagent spawns: a max-attempts / max-turns number must exist in config, not in someone's head.

## Breach Behavior

- `halt-and-log` (default): stop the run, append a `BREACH` meter line, surface the log. A budget nobody sees is not a budget.
- `degrade`: continue with reduced scope (e.g. summarize instead of full read) — only for workflows where partial output is still useful.
- `notify-only`: log and continue — for observation weeks, never for production loops.

## Pairing

- **git-backup-discipline**: budget logs and manifests are state — back them up with the same push-verified discipline.
- **Cron/watchdog integrations**: run `budget_check.sh` as a pre-flight step; a watchdog that already gates on backup gaps can gate on budget breaches the same way.

## Quick Start

```bash
cp examples/TOKENS.budget.yml.example ./TOKENS.budget.yml
./scripts/budget_check.sh            # validate config, show today's usage
./scripts/log_usage.sh run-42 48000 3200 ok
./scripts/budget_check.sh            # verdict updates
```
