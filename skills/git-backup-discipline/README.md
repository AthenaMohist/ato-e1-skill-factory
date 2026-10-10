# git-backup-discipline

**Fail-closed backup discipline for git repos:** manifest + verified push + gap audit. Never trust "committed" — prove "backed up."

## Install

```bash
npx skills add https://github.com/AthenaMohist/git-backup-discipline
# or copy the folder into .claude/skills/ / ~/.codex/skills/
```

## Quick start

```bash
bash scripts/init.sh ~/my-repo --cadence daily     # one-time enrollment
bash scripts/backup.sh ~/my-repo                    # verified backup (push + SHA match)
bash scripts/audit.sh ~/projects                    # fail-closed coverage audit
```

## The rules this skill enforces

| Rule | Failure it prevents |
|------|--------------------|
| Local commit ≠ backup | Machine dies before push |
| Push exit 0 ≠ backup (verify remote SHA == HEAD) | Silent push failures, stale remotes |
| Every repo needs a `BACKUP.manifest.yml` | Coverage gaps nobody notices |
| Audit exits non-zero on any gap | Pipelines that "succeed" while unprotected |
| Log every attempt (success and failure) | No forensic trail after an incident |

## Status

v1.0.0 — production-derived from an agent pipeline that has run daily verified backups since 2026-08.

MIT licensed. Bug reports and PRs welcome.
