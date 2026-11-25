#!/usr/bin/env bash
# backup.sh — verified backup: push + remote SHA match + log. Exits non-zero on any failure.
# usage: bash backup.sh /path/to/repo
# Dirty worktree: uncommitted changes are NOT in any commit, so a successful push
# still leaves real work unbacked (gap type 6). Fail-closed default: exit 1 and
# record the gap. Set BACKUP_ALLOW_DIRTY=1 to push anyway (WARN logged, gaps still recorded).
set -uo pipefail
REPO="${1:?usage: backup.sh /path/to/repo}"
cd "$REPO"
[ -f BACKUP.manifest.yml ] || { echo "no BACKUP.manifest.yml — run init.sh first" >&2; exit 2; }
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
HEAD_SHA=$(git rev-parse HEAD)
LOG_LINE="$TS push"
# Gap type 8 (detached HEAD) at the primary entrypoint: abbrev-ref returns the
# literal "HEAD", so a push would target no real branch and fail with a
# misleading PUSH-FAILED. Fail-closed with the specific gap instead.
if [ "$BRANCH" = "HEAD" ]; then
  echo "$TS DETACHED-HEAD sha=$HEAD_SHA (not on any branch — commits are only reachable from reflog and will be garbage-collected)" >> BACKUP.gaps
  echo "$LOG_LINE BLOCKED (detached HEAD) sha=$HEAD_SHA" >> BACKUP.log
  echo "BACKUP BLOCKED: detached HEAD — checkout/attach a branch before backing up." >&2
  exit 1
fi

# Gap type 6 (uncommitted worktree changes) at the primary entrypoint, not only in audit.
# The discipline's own artifacts (BACKUP.manifest.yml/log/gaps) are untracked by design and excluded.
DIRTY=$(git status --porcelain | grep -v " BACKUP\.\(manifest\.yml\|log\|gaps\)" || true)
if [ -n "$DIRTY" ] && [ "${BACKUP_ALLOW_DIRTY:-0}" != "1" ]; then
  echo "$TS DIRTY-WORKTREE push blocked sha=$HEAD_SHA (uncommitted changes would NOT be backed up; set BACKUP_ALLOW_DIRTY=1 to override)" >> BACKUP.gaps
  echo "$LOG_LINE BLOCKED (dirty worktree) sha=$HEAD_SHA" >> BACKUP.log
  echo "BACKUP BLOCKED: uncommitted changes exist — they are not in any commit and would not be backed up. Commit first, or set BACKUP_ALLOW_DIRTY=1 to push anyway." >&2
  exit 1
elif [ -n "$DIRTY" ]; then
  echo "$TS DIRTY-WORKTREE override push sha=$HEAD_SHA" >> BACKUP.gaps
  echo "$LOG_LINE WARN (dirty worktree override) sha=$HEAD_SHA" >> BACKUP.log
fi

if ! git push origin "$BRANCH" 2>>BACKUP.log; then
  echo "$TS PUSH-FAILED sha=$HEAD_SHA (push rejected — remote state unknown)" >> BACKUP.gaps
  echo "$LOG_LINE FAIL (push rejected) sha=$HEAD_SHA" >> BACKUP.log
  echo "BACKUP FAILED: push did not succeed" >&2; exit 1
fi
REMOTE_SHA=$(git ls-remote origin -h "refs/heads/$BRANCH" | cut -f1)
if [ "$REMOTE_SHA" != "$HEAD_SHA" ]; then
  echo "$TS SHA-MISMATCH sha=$HEAD_SHA remote=${REMOTE_SHA:-none} (remote does not match HEAD)" >> BACKUP.gaps
  echo "$LOG_LINE FAIL (sha mismatch head=$HEAD_SHA remote=${REMOTE_SHA:-none})" >> BACKUP.log
  echo "BACKUP FAILED: remote SHA != HEAD (exit code lied — this is why we verify)" >&2; exit 1
fi
echo "$LOG_LINE OK sha=$HEAD_SHA" >> BACKUP.log
# Portable manifest update: `sed -i` (no suffix) is GNU-only — on BSD/macOS sed
# `-i` expects a backup-suffix argument and the command errors (or treats the
# pattern as the suffix), leaving last_verified stale so the next audit falsely
# reports STALE-VERIFIED. Write-then-rename is portable and atomic.
TS_ESC=$(printf '%s' "$TS" | sed 's/[&|]/\\&/g')
sed "s/^last_verified: .*/last_verified: $TS_ESC/" BACKUP.manifest.yml > BACKUP.manifest.yml.tmp \
  && mv -f BACKUP.manifest.yml.tmp BACKUP.manifest.yml
echo "backup verified: remote $BRANCH @ ${HEAD_SHA:0:7}"
