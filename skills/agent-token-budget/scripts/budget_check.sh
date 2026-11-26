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
ML=$(get meter_log)
[ -n "$ML" ] && METER_LOG="$ML"   # config wins only if present; CLI arg / default kept otherwise

ERR=0
for v in "$IN_CAP" "$OUT_CAP" "$DAY_CAP"; do
  case "$v" in ''|*[!0-9]*) echo "ERROR: missing or non-numeric ceiling in $BUDGET_FILE" >&2; ERR=1;; esac
done
case "$ON_BREACH" in halt-and-log|degrade|notify-only) ;; *) echo "ERROR: on_breach must be halt-and-log|degrade|notify-only" >&2; ERR=1;; esac

# Optional cost model (v1.11): per-million-USD prices + a daily cost ceiling.
# Token counts alone don't answer the question stakeholders ask ("what did
# yesterday cost?"); a ceiling in dollars is the number a budget owner can
# actually reason about. Fields are optional — absent means no cost reporting.
P_IN=$(get usd_per_1m_input)
P_OUT=$(get usd_per_1m_output)
COST_CAP=$(get cost_ceiling_usd)
if [ -n "$P_IN" ] || [ -n "$P_OUT" ] || [ -n "$COST_CAP" ]; then
  for v in "$P_IN" "$P_OUT"; do
    case "$v" in ''|*[!0-9.]*) echo "ERROR: usd_per_1m_* must be numeric (got '$v')" >&2; ERR=1;; esac
  done
  case "$COST_CAP" in ''|*[!0-9.]*) echo "ERROR: cost_ceiling_usd must be numeric (got '$COST_CAP')" >&2; ERR=1;; esac
  # Both prices required when cost reporting is on: one-sided pricing silently
  # misvalues output-heavy workflows (output is usually the expensive side).
  if [ -z "$P_IN" ] || [ -z "$P_OUT" ]; then
    echo "ERROR: cost reporting needs both usd_per_1m_input and usd_per_1m_output" >&2; ERR=1
  fi
fi
[ "$ERR" = 1 ] && exit 1

TODAY=$(python3 -c "import datetime;print(datetime.date.today())" 2>/dev/null \
  || date +%Y-%m-%d)

# Rotation (log_usage.sh auto-rotate) moves earlier lines into <log>.1 — today's
# usage can span both files. Ignoring the archive silently undercounts the day.
BREACH=0
IN_USED=0; OUT_USED=0
for LOGF in "$METER_LOG" "$METER_LOG.1"; do
  [ -f "$LOGF" ] || continue
  # One awk pass per file: validate every line numeric, enforce per-run ceilings,
  # and sum the day — all in awk, compared numerically. Doing the SUM in bash
  # instead lets a single corrupted (>=2^63) meter line poison the total: awk
  # prints such a sum in e-notation (e.g. 1.84467e+19) and bash's $(( ))
  # coerces that to 0, so the broken line DEFEATS the daily ceiling check
  # instead of tripping it. Same reason per-run checks run here and not in a
  # bash while-read loop (bash arithmetic errors on >=2^63 values).
  STATS=$(grep "^$TODAY" "$LOGF" | awk -v ic="$IN_CAP" -v oc="$OUT_CAP" '
    {
      rid=$2; lin=$3; lout=$4
      if (lin !~ /^[0-9]+$/ || lout !~ /^[0-9]+$/) {
        printf "BREACH: run %s meter line corrupt (input=%s output=%s must be numeric) — an unreadable meter line hides real usage\n", rid, lin, lout > "/dev/stderr"
        bad++
      } else {
        tin += lin; tout += lout
        if (lin+0 > ic+0) printf "BREACH: run %s input %s > per-run ceiling %s\n", rid, lin, ic > "/dev/stderr"
        if (lout+0 > oc+0) printf "BREACH: run %s output %s > per-run ceiling %s\n", rid, lout, oc > "/dev/stderr"
        if (lin+0 > ic+0 || lout+0 > oc+0) bad++
      }
    }
    END { printf "%d %d %d\n", tin+0, tout+0, bad+0 }')
  IN_USED=$((IN_USED + $(echo "$STATS" | awk "{print \$1}")))
  OUT_USED=$((OUT_USED + $(echo "$STATS" | awk "{print \$2}")))
  [ "$(echo "$STATS" | awk "{print \$3}")" -gt 0 ] && BREACH=1
done

echo "date=$TODAY in+out=$((IN_USED + OUT_USED))/$DAY_CAP (per-run cap: in=$IN_CAP out=$OUT_CAP) on_breach=$ON_BREACH"
TOTAL_USED=$((IN_USED + OUT_USED))
if [ "$TOTAL_USED" -gt "$DAY_CAP" ]; then echo "BREACH: daily ceiling exceeded (in+out=$TOTAL_USED > $DAY_CAP)" >&2; BREACH=1; fi

# Cost model (v1.11): report today's estimated cost; enforce cost_ceiling_usd.
# awk does the float math (bash arithmetic is integer-only); printf %.2f keeps
# the report human-readable. Grep for BREACH in stderr, not exit code alone —
# the caller may run with notify-only and still want the number surfaced.
if [ -n "$COST_CAP" ]; then
  COST=$(awk -v ti="$IN_USED" -v to="$OUT_USED" -v pi="$P_IN" -v po="$P_OUT" \
    'BEGIN { printf "%.2f", (ti/1000000)*pi + (to/1000000)*po }')
  OVER=$(awk -v c="$COST" -v cap="$COST_CAP" 'BEGIN { print (c+0 > cap+0) ? 1 : 0 }')
  echo "cost_usd=$COST/$COST_CAP (in=${IN_USED}x\$$P_IN/M + out=${OUT_USED}x\$$P_OUT/M)"
  if [ "$OVER" = 1 ]; then
    echo "BREACH: daily cost ceiling exceeded (cost_usd=$COST > $COST_CAP)" >&2
    BREACH=1
  fi
fi

# Checking only the last meter line lets an oversized run earlier in the day
# escape — the per-file awk pass above checks EVERY line from today.

if [ "$BREACH" = 1 ] && [ "$ON_BREACH" = "halt-and-log" ]; then
  exit 1
fi
exit 0
