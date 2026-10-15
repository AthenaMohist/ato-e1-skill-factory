# Listings

| Channel | Type | URL | Status | Downloads |
|---------|------|-----|--------|-----------|
| SkillsMP | free, auto-indexed from GitHub | https://skillsmp.com (search: git-backup-discipline) | prerequisites met 2026-10-13: topics `claude-skills`+`claude-code-skill` set via API (200 verified); daily sync will pick it up | 0 |
| skills.sh (Vercel) | free, passive telemetry | https://skills.sh/AthenaMohist/ato-e1-skill-factory | listed after installs via `npx skills add` | 0 |
| aiskill.market | free | — | submit blocked — ROOT CAUSE FOUND 2026-10-13: server action validates source_url against its own ingestion repo `github.com/DukeWood/aiSkills`, which now returns 404 (repo deleted). Not fixable by submitters. 5-step form fully completed server-side, same error each time. | — |
| Agensi (agensi.io) | paid, 70% payout (Stripe or USDC on Solana) | — | requires seller account sign-in (email/Google) — human identity decision pending | — |
| KissMySkills | paid, 35% | — | sell form pending; payouts fiat (PayPal/card), seller identity needed | — |

## Market research log

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
