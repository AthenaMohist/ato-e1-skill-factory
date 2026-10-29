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

### 2026-10-20
- **SkillsMP**: `git-backup-discipline` now indexed — API search returns 2 entries
  (nested skills/ path + repo root), skillUrl live under
  `/creators/athenamohist/ato-e1-skill-factory/skills-git-backup-discipline`.
  `agent-token-budget` and `release-checklist-discipline` not yet indexed
  (day-2 / day-1 since push; sync window continues).
- **Market signal (top-of-catalog by stars)**: highest-signal entries in the
  "backup/verify" neighborhood are operational-audit and release-verification
  disciplines (healthcheck 392K, chrome-release-verify 123K, dependency-doctor
  142K) — all described as outcome + enforcement ("audit/harden", "checks … for
  footguns"), consistent with the 10-15 methodology-beats-wrapper insight.
  **Action taken this tick**: root `SKILL.md` (the file marketplace validators
  index for repo-level entries) had diverged from the v1.0.2 skill — it was
  missing the Pairing Framework and the sharpened pairing trigger line. Synced
  it to v1.0.2 content (commit cc97fc1, remote == HEAD verified). The root
  entry is the one SkillsMP shows for the repo, so this directly fixes the
  indexed copy's discoverability.

### 2026-10-21
- **SkillsMP re-crawl check**: both `git-backup-discipline` entries (nested + repo
  root) still serve the pre-pairing snapshot (root `updatedAt` ≈ 10-13; listing
  frontmatter/body lack the pairing trigger line and Pairing Framework section).
  Expected — re-crawl cadence appears to be ~1 week per entry. Re-check next tick.
  `agent-token-budget` (day-3) and `release-checklist-discipline` (day-2) still
  not indexed.
- **Listing improvement (quantified-outcome description)**: sharpened the
  `git-backup-discipline` description with measurable results — "closes 3
  data-loss gap types …; CI/cron-ready exit codes (0 clean / 1 gap); zero
  platform lock-in" — following the pattern of top-enforcement listings
  (healthcheck / dependency-doctor / chrome-release-verify). Applied to both the
  root and nested SKILL.md (kept identical). commit `4eeb3a9` pushed,
  HEAD == origin/main verified.

### 2026-10-22
- **SkillsMP re-crawl check**: root entry still serves the 10-13 snapshot
  (no quantified-outcome sentence, no Pairing Framework); nested entry
  unchanged since 10-11. `agent-token-budget` (day-4) and
  `release-checklist-discipline` (day-3) still not indexed. Re-check next tick.
- **Real gap fix (self-audit)**: found that a corrupted/unparseable
  `last_verified` timestamp (e.g. `last_verified: "not-a-date"`) made
  `audit.sh`'s ISO->epoch fallback return 0 and fall through both checks —
  the repo silently produced no STALE-VERIFIED gap, i.e. a fail-closed
  coverage hole. Now emits a dedicated `UNPARSEABLE-VERIFIED` gap type
  (4 gap types total). Fixture regression: fresh/stale/unparseable + /root
  projects scan all behave correctly. commit `a9d75c0` pushed,
  HEAD == origin/main verified.

### 2026-10-25
- **SkillsMP re-crawl check**: BLOCKED this tick — the site now serves a
  Cloudflare managed challenge on both the API and the homepage (verified via
  direct fetch and a real browser session, 90s+ wait). Re-check next tick;
  expected re-crawl of the quantified-outcome description (pushed 10-21) is
  now 4 days pending.
- **Real gap fix (self-audit #2)**: `audit.sh` did not detect uncommitted
  worktree changes — a repo can be fully pushed yet still lose local edits on
  disk failure, the exact data-loss class this skill exists to prevent. Added
  an `UNCOMMITTED-CHANGES` gap type (5 gap types total) via
  `git status --porcelain`. Regression: dirty repo flagged, clean repo not;
  corrupted-manifest cases (multiline yaml / quoted scalar / broken yaml) all
  correctly emit `UNPARSEABLE-VERIFIED`. commit `cb3c733` pushed,
  HEAD == origin/main verified.

### 2026-10-26
- **SkillsMP re-check**: API and listing page both return 403 with a Cloudflare
  managed challenge (curl blocked). Status unverifiable from the CLI this tick;
  the 10-18 INDEXED observation remains the last confirmed state.
- **skills.sh**: repo page 404s (registry is telemetry-driven — no listing until
  real `npx skills add` installs occur; we do not fake installs).
- **Market read (Agensi top-12, Oct 2026)**: free dev-tooling skills top out at
  a few hundred installs (code-reviewer 764, git-commit-writer 232); the big
  install numbers belong to official suites and job-outcome products. Confirms
  the strategy: discovery via free channels, differentiation via fail-closed
  enforcement scripts rather than advice-only content.
- **Storefront fix**: README "Skills" table listed only skill #1 while the repo
  ships three (agent-token-budget and release-checklist-discipline were missing
  entirely). Added both with versions, plus a set-framing paragraph (backup →
  budget → release gate as one discipline stack). Verified: no internal
  references/credentials per docs/RELEASING.md checklist; SKILL.md versions
  match (1.0.3 / 1.0.0 / 1.0.0).

## 2026-10-27 (tick 18)

- **SkillsMP API unblocked**: homepage still behind Cloudflare managed
  challenge (403), but the search API returns 200 again. git-backup-discipline
  root entry updatedAt ≈ 10-25 — the 10-21 quantified-description resync
  finally landed (was pending 4 days). #2 indexed day-9 snapshot, #3 day-10.
- **Gap fix (front-matter accuracy)**: all git-backup-discipline descriptions
  still said "Closes 3 data-loss gap types" while audit.sh has shipped 5 gap
  types since 10-25 (UNPARSEABLE-VERIFIED, UNCOMMITTED-CHANGES). Updated both
  SKILL.md files, bumped v1.0.2 → v1.0.3, synced nested README changelog.

## 2026-10-28 (tick 19)

- **SkillsMP full index achieved**: all three skills now listed. #1 two
  entries at 10-25 snapshot (v1.0.3 5-gap description resync pending ~1 day);
  #2 agent-token-budget indexed (snapshot 10-18); #3
  release-checklist-discipline indexed (snapshot 10-19). Homepage still behind
  Cloudflare challenge; search API 200.
- **Coverage fix (self-audit #3)**: audit.sh repo discovery only matched `.git`
  as a directory — git linked worktrees and submodules (`.git` is a *file*)
  were silently skipped, a coverage blind spot in a fail-closed auditor. Both
  GNU find and python3 fallback now accept `.git` as file or dir. Regression:
  worktree fixture discovered and audited (4 gaps incl. UNPARSEABLE-VERIFIED);
  normal repo path unchanged (rc=0). v1.0.4, commit `e0f9ed3` pushed,
  HEAD == origin/main.
- **aiskill.market weekly check**: ingestion repo `DukeWood/aiSkills` still
  404; site up but submission remains broken server-side. Not fixable by us.

## 2026-10-29 (tick 20)

- **SkillsMP resync check**: #1 two entries still at 10-25 snapshot — v1.0.4
  coverage fix not re-fetched yet (pending 4 days; historical resync cadence
  ~4-11 days). #2 (10-18) / #3 (10-19) snapshots unchanged. API 200, homepage
  still Cloudflare-challenged.
- **skills.sh top-list scan (www, 922 KB DOM)**: board is dominated by
  org/edu dev-education skills (mattpocock 30+ entries, vercel-labs,
  anthropics, prisma, supabase, shadcn, prime-skills/RunComfy media suite).
  Zero backup/verify/postmortem/checklist skills on the front board —
  confirms methodology/discipline skills win via install telemetry long tail,
  not the front page. Market direction unchanged: free-discovery first,
  second outcome-type paid skill still the open item.
- **Integration gap fix (self-audit #4)**: SKILL.md advertises "CI/cron-ready
  exit codes" but audit.sh only emitted human-readable text — consumers had
  to parse prose to know *which* gaps fired. Added `--json` flag: structured
  `{"root", "gapCount", "gaps":[{type, repo, detail}]}` to stdout. Regression
  caught two real bugs live: (a) quoted YAML scalars
  (`last_verified: "2026-..."`) false-flagged UNPARSEABLE-VERIFIED (fixed by
  quote-stripping); (b) JSON detail containing quotes produced invalid JSON
  (fixed with escaping). Fixtures: fresh/stale/unparseable/dirty/no-remote
  all correct; valid JSON verified by parser. v1.0.5, commit `bcb7e1d`
  pushed, HEAD == origin/main.
