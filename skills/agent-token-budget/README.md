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
- `scripts/log_usage.sh` — appends one meter line per run: date, run id, input, output, verdict. Rotation is automatic: at `TOKENS_ROTATE_LINES` (default 5000) the log is merged into the archive `<log>.1` and a fresh log starts — the meter never grows unbounded even if `rotate_meter.sh` is never invoked manually, and repeated rotations never destroy earlier meter data. The archive itself is pruned to a `TOKENS_ARCHIVE_KEEP_DAYS` (default 7) window on every rotation, so the merged archive cannot silently grow back into the full-history grep problem rotation exists to prevent.
- `scripts/rotate_meter.sh` — rotates the meter log past a line threshold into `TOKENS.log.1` (default 5000 lines), so the meter itself never becomes an unbounded cost. Uses the same archive keep-window as `log_usage.sh`; an invalid keep-window value exits 1 (fail-closed).
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

## Requirements

- `bash` and GNU/BSD `sed`, `awk`, `grep` — nothing else. No Python, no Node, no network access.
- Real output samples: see [`examples/example-output.md`](examples/example-output.md) — produced by actually running `budget_check.sh`, including the breach, corrupt-config, and missing-file paths (all fail-closed).
