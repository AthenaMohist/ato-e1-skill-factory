# Listings

| Channel | Type | URL | Status | Downloads |
|---------|------|-----|--------|-----------|
| SkillsMP | free, auto-indexed from GitHub | https://skillsmp.com/creators/athenamohist/ato-e1-skill-factory/skills-git-backup-discipline | **INDEXED 2026-10-18** (listing URL HTTP 200, day 10 after topics set) | 0 |
| skills.sh (Vercel) | free, passive telemetry | https://skills.sh/AthenaMohist/ato-e1-skill-factory | listed after installs via `npx skills add` | 0 |
| aiskill.market | free | — | submit blocked — ROOT CAUSE FOUND 2026-10-13: server action validates source_url against its own ingestion repo `github.com/DukeWood/aiSkills`, which now returns 404 (repo deleted). Not fixable by submitters. 5-step form fully completed server-side, same error each time. | — |
| Agensi (agensi.io) | paid, 70% payout (Stripe or USDC on Solana) | — | requires seller account sign-in (email/Google) — human identity decision pending | — |
| KissMySkills | paid, 35% | — | sell form pending; payouts fiat (PayPal/card), seller identity needed | — |

## Market research log

### 2026-10-18
- **SkillsMP INDEXED** — after 10 days, `git-backup-discipline` now appears in the
  SkillsMP API (2 entries: skill-file view + repo view) with a live listing page
  (HTTP 200). Sync cycle is ~10 days, far slower than the advertised "daily".
  Skill #2 (`agent-token-budget`) already benefits: topics are set, expect faster
  pickup now that the repo is a known indexed source.
- **skills.sh competitive scan for skill #2**: `token-budget` search shows one
  clear leader (affaan-m/ecc/token-budget-advisor, ~8.7K installs) and a long
  tail of <60-install clones — the niche is validated but underserved on the
  enforcement side (most are advice-only, few ship a fail-closed checker).
  `caveman` family still dominates efficiency overall (578K installs) — agent
  cost reduction remains the strongest near-neighbor paid category.
- **Differentiation for #1/#2**: shipped `agent-token-budget` v1.0.0 with a
  fail-closed `budget_check.sh` (breach → exit 1, portable GNU/BSD), closing the
  gap vs advice-only competitors. 5-scenario self-test green (valid config, ok
  usage, breach halt, invalid on_breach, notify-only).

### 2026-10-17
- **SkillsMP**: still not indexed (API `/api/v1/skills/search` = 0 results for both
  skill name and owner) — day 9 since topics were set. Continue next-tick checks;
  fallback remains skills.sh install telemetry.
- **KissMySkills best-sellers re-check**: catalog top cards are all job-outcome
  products (Charlotte Ghostwriter, Diane Executive Assistant, SEO/Sales/Finance
  Agent Bundles). Pricing ladder: $9/mo all-access subscription, $19 single
  skills, $99 bundles, $119 annual. Confirms again: dev-tooling needs the free
  discovery channels; paid channels need an outcome-type skill.
- **Ecosystem snapshot (web roundups, Oct 2026)**: stars leaders = obra/superpowers
  (~298K), anthropics/skills (~181K), ui-ux-pro-max (~135K), caveman (~111K, token
  compression), taste-skill (~95K). Notable: **caveman proves "agent efficiency /
  cost-reduction" is a winning paid-adjacent category** — measurable, one-line
  pitch, universal audience.
- **Second-skill candidate shortlist (closing the tick-8 plan)**, scored against
  the confirmed "outcome/methodology + measurable result" market fit:

  | Candidate | Type | Market fit | Differentiation | Effort | Score /5 |
  |---|---|---|---|---|---|
  | `agent-token-budget` (caveman-style output/token discipline for agent CLIs) | efficiency, measurable | High — universal audience, quantifiable claim | compression rules + guardrails beyond caveman's narration-strip | M | 4.5 |
  | `release-checklist-discipline` (fail-closed pre-release gates: version bump, changelog, RELEASING checklist, tag+push verification) | methodology | Medium-high — pairs with our backup skill | fail-closed exit codes like git-backup-discipline | S-M | 4.0 |
  | `incident-postmortem-discipline` (structured forensics: evidence-first, timeline, root-cause ledger) | methodology | Medium — narrower audience, high perceived value | evidence-chain discipline from real ops | M | 3.5 |

  Next step:封装 `agent-token-budget` as candidate #1 (measurable outcome claim
  matches the paid-market pattern best); release-checklist-discipline as #2 since
  it cross-sells with git-backup-discipline (pairing framing already shipped).

### 2026-10-16
- **SkillsMP**: still not indexed (API search = 0 results, totalIsExact true) — 7 days
  since topics were set. Continue next-tick checks.
- **Action taken this tick (closing the 10-15 insight)**: added a **Pairing Framework**
  section to SKILL.md (cron/CI watchdog integration, destructive-operation precheck gate,
  per-repo cadence tiers) and extended the description with a pairing trigger line —
  directly adopting differentiators (a) and (b) from the 2026-10-15 editorial analysis.
  Commit d44f2dc pushed and verified (remote == HEAD). Regression: audit.sh live scan on
  a real multi-repo dir exits 1 with 3 gaps (fail-closed semantics intact).

### 2026-10-15
- **SkillsMP**: still not indexed (API search `git-backup-discipline` = 0 results, totalIsExact
  true), 2 days after both topic prerequisites were set. Daily sync may be slower than 24h.
  Continue next-tick checks.
- **skills.sh**: listing URL still 404 (404 at final URL after 308 to lowercase path) — no
  install telemetry yet, expected: passive indexing requires real `npx skills add` installs.
- **aiskill.market** (via their editorial blog "Best Claude Skills for Git Workflows 2026"):
  top-15 git skills ranked by composite (stars/installs/ClawHub downloads + quality score).
  Key insight: **workflow-methodology skills outrank command wrappers** — the #1/#2 picks
  (obra/superpowers finishing-a-development-branch, using-git-worktrees, both 167.5K signal,
  4/5 quality) win because "Claude needs discipline more than it needs git commands."
  Our git-backup-discipline is squarely in the winning category (methodology/discipline,
  fail-closed rules, CI exit codes). Differentiators observed in top entries that we lack:
  (a) a catchy one-line "when to use" trigger in the description,
  (b) pairing/eco-system framing ("install with X"),
  (c) 0–5 quality score coverage (only ~15% of catalog has one — worth pursuing).
  Action taken this tick: v1.0.2 portability fix (BSD find repo discovery) — directly serves
  the trust/reliability signal those rankings reward.

### 2026-10-13
- **SkillsMP** (skillsmp.com): 3.5M indexed SKILL.md files. Free discovery channel — no
  submission form; indexes public GitHub repos tagged `claude-skills` or
  `claude-code-skill`, daily sync. We set both topics on our repo via the GitHub API.
- **KissMySkills**: 2,500+ skills; subscription library (7-day free trial, MCP connector)
  plus per-file purchases. Sells "role specialists" (SEO, CRM, recruiting) — top sellers
  are job-outcome skills, not developer tooling. Implication: our dev-tooling skill fits
  SkillsMP/skills.sh audiences better; a paid listing here would need a second,
  outcome-oriented skill.
- **aiskill.market**: Torly.ai family, claims 4,600+ skills / 58 publishers. Currently
  unfixable on our side (see table). Re-check their ingestion repo weekly.
