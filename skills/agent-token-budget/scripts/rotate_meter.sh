#!/usr/bin/env bash
# rotate_meter.sh — rotate TOKENS.log before it becomes its own cost problem.
# Keeps TOKENS.log (current) plus one archive TOKENS.log.1 (previous period).
# Usage: rotate_meter.sh [log_path] [max_lines]
#   log_path  defaults to $TOKENS_METER_LOG or TOKENS.log
#   max_lines defaults to $TOKENS_ROTATE_LINES or 5000
# A meter log that grows forever: (a) makes every budget_check.sh grep the whole
# file, (b) gets reread into agent context by tools that tail it, (c) mixes
# stale-period lines into today's sums. Rotation caps all three.
set -u
# Meter log path resolution must match budget_check.sh (the reader): CLI arg >
# config `meter_log` > env > TOKENS.log (see log_usage.sh cfg_meter_log).
cfg_meter_log() {
  [ -f "TOKENS.budget.yml" ] || return 0
  sed -n "s/^[[:space:]]*meter_log:[[:space:]]*//p" TOKENS.budget.yml | head -1 | sed 's/[[:space:]]*#.*//' | tr -d '[:space:]'
}
LOG="${1:-${TOKENS_METER_LOG:-TOKENS.log}}"
[ -z "${1:-}" ] && { ML=$(cfg_meter_log); [ -n "$ML" ] && LOG="$ML"; }
MAX="${2:-${TOKENS_ROTATE_LINES:-5000}}"
if [ ! -f "$LOG" ]; then exit 0; fi
case "$MAX" in ''|*[!0-9]*) echo "ERROR: max_lines must be numeric (got '$MAX')" >&2; exit 1;; esac
LINES=$(wc -l < "$LOG")
if [ "$LINES" -lt "$MAX" ]; then exit 0; fi
# Merge into the archive instead of overwriting it — mv -f silently destroys
# the previous archive (and any of today's meter lines inside it).
if [ -f "$LOG.1" ]; then
  cat "$LOG.1" "$LOG" > "$LOG.1.tmp" && mv -f "$LOG.1.tmp" "$LOG.1"
else
  mv -f "$LOG" "$LOG.1"
fi
: > "$LOG"
# Merged-archive growth control (same rationale as log_usage.sh): without a
# keep window the archive converges to ALL history and budget_check.sh greps
# the full file again — pruning outside the window is zero-semantics-loss.
prune_archive() {
  local PLOG="$1"
  [ -f "$PLOG.1" ] || return 0
  local KEEP="${TOKENS_ARCHIVE_KEEP_DAYS:-7}"
  case "$KEEP" in ''|*[!0-9]|0) echo "ERROR: TOKENS_ARCHIVE_KEEP_DAYS must be numeric >=1 (got '$KEEP')" >&2; return 1;; esac
  local CUTOFF
  CUTOFF=$(python3 -c "import datetime;print(datetime.date.today()-datetime.timedelta(days=$KEEP-1))" 2>/dev/null \
    || date -d "$((KEEP-1)) days ago" +%Y-%m-%d 2>/dev/null \
    || date -v-"$((KEEP-1))"d +%Y-%m-%d 2>/dev/null) || { echo "WARN: cannot compute cutoff — archive left unpruned" >&2; return 0; }
  local TMPF
  TMPF=$(mktemp "${PLOG}.1.prune.XXXXXX") || return 0
  awk -v cut="$CUTOFF" 'substr($1,1,10) >= cut' "$PLOG.1" > "$TMPF" && mv -f "$TMPF" "$PLOG.1" || { rm -f "$TMPF"; echo "WARN: archive prune failed — archive left unpruned" >&2; return 0; }
}
prune_archive "$LOG" || exit 1
echo "rotated: $LINES lines -> $LOG.1 (merged, fresh $LOG started)"
