# Example output — agent-token-budget

All output below was produced by actually running the scripts on
2026-11-12 (GNU bash, Linux). The meter log had 3 runs in one day;
run-002 blew the 50,000 per-run input ceiling by accidentally
feeding a whole repo into context:

```
2026-11-12 run-001 32000 3100 ok
2026-11-12 run-002 61000 3800 ok
2026-11-12 run-003 41000 3900 ok
```

## 1. Day with a per-run breach, `on_breach: halt-and-log`

```console
$ budget_check.sh TOKENS.budget.yml TOKENS.log
date=2026-11-12 in=134000/200000 (per-run cap: in=50000 out=4000) on_breach=halt-and-log
BREACH: run run-002 input 61000 > per-run ceiling 50000
rc=1
```

The daily sum (134,000) is still under the 200,000 ceiling, but the
skill fails closed anyway: **one oversized run is a breach**, not just
an oversized day. Exit code 1 is what your cron wrapper should gate on.

## 2. Same day, `on_breach: notify-only` (observation mode)

```console
$ budget_check.sh clean.yml TOKENS.log
date=2026-11-12 in=134000/200000 (per-run cap: in=50000 out=4000) on_breach=notify-only
BREACH: run run-002 input 61000 > per-run ceiling 50000
rc=0
```

Breach is still reported loudly, but does not halt — for observation
weeks only, never for production loops.

## 3. Corrupt config

```console
$ budget_check.sh bad.yml TOKENS.log
ERROR: missing or non-numeric ceiling in bad.yml
ERROR: missing or non-numeric ceiling in bad.yml
ERROR: missing or non-numeric ceiling in bad.yml
ERROR: on_breach must be halt-and-log|degrade|notify-only
rc=1
```

Config errors are fail-closed (exit 1) under every `on_breach` value —
a broken contract never silently passes.

## 4. Missing budget file

```console
$ budget_check.sh nope.yml TOKENS.log
ERROR: no nope.yml found — an unmetered agent is an incident waiting for the bill.
rc=1
```
