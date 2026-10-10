#!/usr/bin/env bash
# init.sh — enroll a repo into git-backup-discipline
# usage: bash init.sh /path/to/repo [--cadence daily|weekly|per-commit]
set -euo pipefail
REPO="${1:?usage: init.sh /path/to/repo [--cadence daily]}"
CADENCE="daily"
[ "${2:-}" = "--cadence" ] && CADENCE="${3:?--cadence needs a value}"
cd "$REPO"
[ -d .git ] || { echo "not a git repo: $REPO" >&2; exit 2; }
REMOTE=$(git remote get-url origin 2>/dev/null || true)
[ -n "$REMOTE" ] || { echo "no 'origin' remote configured" >&2; exit 2; }
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ ! -f BACKUP.manifest.yml ]; then
cat > BACKUP.manifest.yml <<EOF
repo: $(basename "$REPO")
remote: $REMOTE
branch: $BRANCH
cadence: $CADENCE
verify: push
owner: "${BACKUP_OWNER:-unset}"
last_verified: never
EOF
echo "created BACKUP.manifest.yml"
fi
touch BACKUP.log BACKUP.gaps
echo "enrolled $(basename "$REPO") (branch=$BRANCH cadence=$CADENCE). Next: bash backup.sh $REPO"
