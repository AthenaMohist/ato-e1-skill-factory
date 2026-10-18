#!/usr/bin/env bash
# budget_check.sh — validate TOKENS.budget.yml and report today's usage vs ceiling.
# Fail-closed: exit 1 on config error or breach (when on_breach is halt-and-log).
set -u

BUDGET_FILE="${1:-TOKENS.budget.yml}"
METER_LOG="${2:-TOKENS.log}"

if [ ! -f "$BUDGET_FILE" ]; then
  echo "ERROR: no $BUDGET_FILE found — an unmetered agent is an incident waiting for the bill." >&2
  exit 1
fi

# Parse values (GNU sed + BSD sed compatible: plain line regex)
get() { sed -n "s/^[[:space:]]*$1:[[:space:]]*//p" "$BUDGET_FILE" | head -1 | sed 's/[[:space:]]*#.*//' | tr -d '[:space:]'; }

IN_CAP=$(get input_ceiling)
OUT_CAP=$(get output_ceiling)
DAY_CAP=$(get ceiling)
ON_BREACH=$(get on_breach)
METER_LOG=$(get meter_log)
[ -z "$METER_LOG" ] && METER_LOG="TOKENS.log"

ERR=0
for v in "$IN_CAP" "$OUT_CAP" "$DAY_CAP"; do
  case "$v" in ''|*[!0-9]*) echo "ERROR: missing or non-numeric ceiling in $BUDGET_FILE" >&2; ERR=1;; esac
done
case "$ON_BREACH" in halt-and-log|degrade|notify-only) ;; *) echo "ERROR: on_breach must be halt-and-log|degrade|notify-only" >&2; ERR=1;; esac
[ "$ERR" = 1 ] && exit 1

# Sum today's usage from the meter log (date computed portably via python3, sed fallback)
TODAY=$(python3 -c "import datetime;print(datetime.date.today())" 2>/dev/null \
  || date +%Y-%m-%d)
IN_USED=0; OUT_USED=0
if [ -f "$METER_LOG" ]; then
  IN_USED=$(grep "^$TODAY" "$METER_LOG" | awk '{s+=$3} END{print s+0}')
  OUT_USED=$(grep "^$TODAY" "$METER_LOG" | awk '{s+=$4} END{print s+0}')
fi

echo "date=$TODAY in=$IN_USED/$DAY_CAP (per-run cap: in=$IN_CAP out=$OUT_CAP) on_breach=$ON_BREACH"
BREACH=0
if [ "$OUT_USED" -gt "$DAY_CAP" ]; then echo "BREACH: daily output ceiling exceeded ($OUT_USED > $DAY_CAP)" >&2; BREACH=1; fi

if [ "$BREACH" = 1 ] && [ "$ON_BREACH" = "halt-and-log" ]; then
  exit 1
fi
exit 0
