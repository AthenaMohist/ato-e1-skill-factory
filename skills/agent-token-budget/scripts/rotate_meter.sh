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
LOG="${1:-${TOKENS_METER_LOG:-TOKENS.log}}"
MAX="${2:-${TOKENS_ROTATE_LINES:-5000}}"
if [ ! -f "$LOG" ]; then exit 0; fi
case "$MAX" in ''|*[!0-9]*) echo "ERROR: max_lines must be numeric (got '$MAX')" >&2; exit 1;; esac
LINES=$(wc -l < "$LOG")
if [ "$LINES" -lt "$MAX" ]; then exit 0; fi
mv -f "$LOG" "$LOG.1"
: > "$LOG"
echo "rotated: $LINES lines -> $LOG.1 (fresh $LOG started)"
