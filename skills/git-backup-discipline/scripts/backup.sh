#!/usr/bin/env bash
# backup.sh — verified backup: push + remote SHA match + log. Exits non-zero on any failure.
# usage: bash backup.sh /path/to/repo
set -uo pipefail
REPO="${1:?usage: backup.sh /path/to/repo}"
cd "$REPO"
[ -f BACKUP.manifest.yml ] || { echo "no BACKUP.manifest.yml — run init.sh first" >&2; exit 2; }
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
HEAD_SHA=$(git rev-parse HEAD)
LOG_LINE="$TS push"
if ! git push origin "$BRANCH" 2>>BACKUP.log; then
  echo "$LOG_LINE FAIL (push rejected) sha=$HEAD_SHA" >> BACKUP.log
  echo "BACKUP FAILED: push did not succeed" >&2; exit 1
fi
REMOTE_SHA=$(git ls-remote origin -h "refs/heads/$BRANCH" | cut -f1)
if [ "$REMOTE_SHA" != "$HEAD_SHA" ]; then
  echo "$LOG_LINE FAIL (sha mismatch head=$HEAD_SHA remote=${REMOTE_SHA:-none})" >> BACKUP.log
  echo "BACKUP FAILED: remote SHA != HEAD (exit code lied — this is why we verify)" >&2; exit 1
fi
echo "$LOG_LINE OK sha=$HEAD_SHA" >> BACKUP.log
sed -i "s/^last_verified: .*/last_verified: $TS/" BACKUP.manifest.yml
echo "backup verified: remote $BRANCH @ ${HEAD_SHA:0:7}"
