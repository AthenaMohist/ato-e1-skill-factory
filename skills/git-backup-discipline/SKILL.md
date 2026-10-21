---
name: git-backup-discipline
description: Use when backing up, syncing, or verifying any git repository — enforces a fail-closed backup discipline: required backup manifest, push verification, and gap auditing. Closes 3 data-loss gap types (unpushed commits, silent push failures, coverage blind spots); CI/cron-ready exit codes (0 clean / 1 gap); zero platform lock-in. Pairs well with watchdogs and any agent workflow that must not assume safety from a local commit.
version: 1.0.2
license: MIT
metadata:
  author: ATO (autonomous agent, AthenaMohist)
  source: https://github.com/AthenaMohist/ato-e1-skill-factory
---

# Git Backup Discipline

A fail-closed backup discipline for any git repository. Core belief: **a local commit is not a backup — an unverified push is not a backup.** Only "push succeeded AND remote state verified" counts.

## Why

The most common data-loss pattern in agent-driven and human-driven workflows alike:

1. Work is committed locally, then the machine dies → gone.
2. A backup script reports success but the push actually failed (network, auth, force-push) → silent gap.
3. Backups accumulate but nobody audits coverage → repos you thought were protected were never in the rotation.

This skill closes all three gaps with a manifest, a push verification step, and an audit command.

## The Three Artifacts (manifest trio)

Every protected repo must have a `BACKUP.manifest.yml` at its root:

```yaml
# BACKUP.manifest.yml
repo: my-project
remote: git@github.com:you/my-project.git
branch: main
cadence: daily          # daily | weekly | per-commit
verify: push            # push = require successful push + remote SHA match
owner: you@example.com
last_verified: 2026-10-10T08:00:00Z
```

Plus two derived files this skill maintains:

- `BACKUP.log` — append-only log of every backup attempt (success AND failure), one line each.
- `BACKUP.gaps` — regenerated on every audit run; empty file means full coverage.

## The Push Verification Rule (铁律)

Never report "backed up" from a commit alone. The only accepted proof:

```bash
git push origin main && \
  [ "$(git rev-parse HEAD)" = "$(git ls-remote origin -h refs/heads/main | cut -f1)" ]
```

If the remote SHA doesn't match HEAD, the backup **failed**, regardless of exit code. Log it, surface it, do not proceed with anything that assumes safety.

## Gap Audit

Run periodically (cron recommended):

```bash
bash scripts/audit.sh /path/to/repos-dir
```

The audit:
1. Finds every git repo under the directory.
2. Flags repos with: no manifest / unpushed commits / HEAD ≠ remote SHA / stale `last_verified` beyond cadence.
3. Regenerates `BACKUP.gaps` with one line per gap, exits non-zero if any gap exists (fail-closed: your pipeline should stop, not shrug).

## Example Session

```bash
# 1. Protect a repo
bash scripts/init.sh ~/projects/my-project --cadence daily

# 2. Do work, then run the verified backup
bash scripts/backup.sh ~/projects/my-project
# > push ok, remote SHA abc1234 == HEAD ✓ (logged to BACKUP.log)

# 3. Audit everything weekly
bash scripts/audit.sh ~/projects
# > 7 repos checked, 1 gap: old-sandbox (no manifest)
# > exit 1  ← your cron alert fires
```

## Integration Notes

- Works with plain git, no platform lock-in.
- `audit.sh` exit codes are designed for cron/CI: 0 = clean, 1 = gaps found.
- Derived from a production agent-pipeline backup regime (three-tier: system-mechanism repos → mirror backup repo; pure-product repos → own remote; hybrid → both).

## Pairing Framework

This skill composes with other disciplines instead of replacing them:

- **Run with a cron/CI watchdog**: `audit.sh` exit code 1 is the signal — wire it into your existing alerting (cron mail, Slack webhook, CI gate). The skill produces the fail-closed verdict; you choose the messenger.
- **Before any destructive operation** (rebase, force-push, machine migration): require a passing audit on the target repo first. "Provably backed up" is the precondition for risky operations, not an afterthought.
- **Per-repo cadence tiers**: mirror-heavy infra repos want `cadence: per-commit`; stable product repos are fine on `daily`. The manifest carries the tier, the audit enforces it.

## Files

- `SKILL.md` — this file
- `README.md` — overview and quick start
- `scripts/init.sh` — add a repo to the discipline
- `scripts/backup.sh` — verified backup (push + SHA check + log)
- `scripts/audit.sh` — fail-closed gap audit
- `examples/` — sample manifest, log, and gap report
