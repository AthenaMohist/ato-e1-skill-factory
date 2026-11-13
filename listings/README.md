# Listings

| Channel | Type | URL | Status | Downloads |
|---------|------|-----|--------|-----------|
| SkillsMP | free, auto-indexed from GitHub | https://skillsmp.com/creators/athenamohist/ato-e1-skill-factory/skills-git-backup-discipline | **INDEXED 2026-10-18** (listing URL HTTP 200, day 10 after topics set) | 0 |
| skills.sh (Vercel) | free, passive telemetry | https://skills.sh/AthenaMohist/ato-e1-skill-factory | listed after installs via `npx skills add` | 0 |
| aiskill.market | free | — | submit blocked — ROOT CAUSE FOUND 2026-10-13: server action validates source_url against its own ingestion repo `github.com/DukeWood/aiSkills`, which now returns 404 (repo deleted). Not fixable by submitters. 5-step form fully completed server-side, same error each time. | — |
| Agensi (agensi.io) | paid, 70% payout (Stripe or USDC on Solana) | — | requires seller account sign-in (email/Google) — human identity decision pending | — |
| KissMySkills | paid, 35% | — | sell form pending; payouts fiat (PayPal/card), seller identity needed | — |

## Market research log

### 2026-11-11
- **git-backup-discipline v1.1.0 — example output + explicit requirements**:
  market research today (Agent37 / Agensi / KissMySkills 2026 guides) names two
  conversion traits for paid skills: (1) buyers want to see a finished-output
  example before paying — "a pack that does not ship example-output is asking
  you to guess"; (2) hidden/undocumented dependencies are the top install-step
  failure. This skill had example manifests/logs but no real audit report, and
  no requirements section. Added `examples/example-output.md` containing the
  actual text + `--json` output of a live audit run (STALE-VERIFIED /
  REMOTE-MISMATCH / NO-MANIFEST scenarios, exit 1 semantics), plus a
  "Requirements: bash + git only" section in README. SKILL.md version 1.1.0.

### 2026-11-08
- **agent-token-budget v1.5.0 — automatic rotation at the write path**: v1.4.0
  added `rotate_meter.sh`, but nothing called it — a meter tool whose fix
  depends on the consumer remembering to run a second script will never rotate
  in practice. `log_usage.sh` now archives the log to `<log>.1` and starts a
  fresh one automatically whenever the log reaches `TOKENS_ROTATE_LINES`
  (default 5000); a non-numeric threshold fails closed. Regression green:
  append rc0, auto-rotate at threshold (archive holds all prior lines, fresh
  log starts), non-numeric threshold rc1, input validation unchanged
  (non-numeric counts / invalid verdict rc1), budget_check sums correct on the
  fresh log after rotation.

### 2026-11-07
- **agent-token-budget v1.2.0 — three enforcement gaps closed**: (1) per-run check
  (added v1.1.0) only inspected the *last* meter line of the day — an oversized
  run earlier in the day escaped; now every line from today is checked, with the
  offending run id named in the breach message. (2) `log_usage.sh` accepted any
  string as token counts and invalid verdicts — garbage lines made awk silently
  treat them as 0, undercounting the daily total in the exact tool meant to
  prevent that; it now rejects non-numeric counts and unknown verdicts.
  (3) `budget_check.sh` unconditionally overwrote the CLI log-path argument with
  the config's `meter_log`, so passing a log path on the command line silently
  did nothing; precedence is now config > CLI arg > `TOKENS.log`. 10 regression
  scenarios green (all-lines breach with run id / clean rc0 / daily breach /
  dual per-run breach / config log respected / config-log breach / CLI arg
  path / log_usage numeric+verdict validation). Commit pushed, HEAD == origin/main.

- **SkillsMP re-check**: still updatedAt=10-25 (v1.0.7/v1.0.8 content) for the two
  `git-backup-discipline` entries — now 10 days stale, beyond the historical ~10-day
  sync cycle. `agent-token-budget` unchanged at 10-18. API responds 200, so the
  index is alive but this repo's re-fetch appears stalled; treat daily re-checks as
  low-yield until they update.
- **agent-token-budget v1.1.0 — per-run enforcement**: audit found `per_run`
  ceilings were displayed but never checked — a single 6000-token run passed with
  `output_ceiling: 100` because only the daily total was compared. Fixed:
  `budget_check.sh` now also checks the most recent meter line against both
  per-run caps; 8 self-test scenarios green (per-run in/out breach, daily breach,
  within-caps rc0, notify-only rc0, invalid on_breach rc1, no-config rc1).
  Commit `b0c1095`, pushed, HEAD == origin/main.

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
- 2026-10-30 tick21: SkillsMP 复查: #1 两条条目 updatedAt=10-25 (v1.0.4 重抓 pending 5 天, 历史节奏 4-11 天); #2 (10-18)/#3 (10-19) 不变; API 200。门面漂移复发: repo 根 SKILL.md 停 v1.0.3 缺 --json 文档, 已同步 v1.0.5 (commit 3836895 push, HEAD==origin/main 实锤)——教训: 根文件与嵌套 SKILL.md 无同步门禁, 每 tick diff 检查。
- 2026-10-31 tick22: SkillsMP 复查: #1 两条条目 updatedAt=10-25 (v1.0.4/v1.0.5 重抓 pending 6 天, 历史节奏 4-11 天窗口内); #2 (10-18)/#3 (10-19) 不变; API 200。G 点改进 (消费者噪声): audit.sh 对同目录下非备份目标 repo 永远报 NO-MANIFEST (产品 repo 自身每次中招) — 新增 ROOT 级可选 `BACKUP.audit-ignore` (相对路径/支持 # 注释), 被列 repo 跳过, 其余 fail-closed 语义不变; 回归: 无 ignore 文件双报/带注释+空行噪声行正确解析/部分前缀不误匹配/JSON 模式尊重 ignore, 全绿。v1.0.6, commit `f2bdddf` push, HEAD==origin/main 实锤。
- 2026-11-01 tick23: SkillsMP 复查: #1 两条条目 updatedAt=10-25 (v1.0.4-v1.0.6 重抓 pending 7 天, 历史节奏 4-11 天窗口内); #2 agent-token-budget (10-18)/#3 release-checklist-discipline (10-19) 不变; API 200。根/嵌套 SKILL.md diff 一致 (每 tick 门面检查通过)。G 点改进 (备份去向漂移, 自审#5): audit.sh 从不校验 manifest 登记的 `remote:` 与实际 origin 是否一致——repo 迁移/换 remote 后 manifest 成为虚假备份去向声明, 审计在错误前提下静默通过; 新增 REMOTE-MISMATCH gap (现 6 类), 引号剥离与 audit-ignore 语义兼容。回归: mismatch fixture 命中 (manifest=old vs actual=origin) / 匹配本地 bare remote 不误报 / 无 origin 不误报, 全绿。v1.0.7, commit `e79e824` push, HEAD==origin/main 实锤。
- 2026-11-02 tick24: SkillsMP 复查: #1 两条条目 updatedAt=10-25 (v1.0.7 重抓 pending 8 天, 历史节奏 4-11 天窗口边缘); #2 agent-token-budget (10-18)/#3 release-checklist-discipline (10-19) 不变; API 200。根/嵌套 SKILL.md diff 一致。G 点改进 (验证目标错误, 自审#6, 真实功能缺陷): audit.sh 的 push 验证用实际 origin 而非 manifest 声明的 remote——REMOTE-MISMATCH 场景 (repo 迁移) 下本地推到新 origin 后旧逻辑判 clean, 但声明的备份目标已落后, 恰是本 skill 要防的丢失类型; 改为按 manifest `remote:` (缺省回退 origin) 做 ls-remote 验证, 并加 timeout 30s 防挂起远端卡死 cron/CI 审计。回归 5 场景全绿: declared==origin pushed→rc0 / mismatch 命中 / declared 落后但 origin 新→UNPUSHED 指向 declared remote (旧逻辑漏报) / UNPUSHED 常规命中 / JSON 输出合法。v1.0.8, commit `c345a0d` push, HEAD==origin/main 实锤。
- 2026-11-03 tick25: SkillsMP 复查: #1 两条条目 updatedAt=10-25 (v1.0.7/v1.0.8 重抓 pending 9 天, **超 4-11 天历史窗口上限**, 下 tick 若仍 10-25 需排查索引机制是否停摆); #2 agent-token-budget (10-18)/#3 release-checklist-discipline (10-19) 不变; API 200。根/嵌套 SKILL.md diff 一致 (同步 v1.0.9)。G 点改进 (错误归因混同, 自审#7): audit.sh 把「原因不明」全部吞成 NO-REMOTE-STATE——detached HEAD 无 branch ref 时 ls-remote 恒空误报 NO-REMOTE-STATE (真因被 mask); 网络/认证/超时失败的 stderr 被静默丢弃, 排障者无法区分「远端没有该分支」和「根本连不上远端」。修复: 新增 DETACHED-HEAD (独立 gap, 不做远端验证) 与 REMOTE-UNREACHABLE (带 git stderr 摘要) 两类 gap (现 8 类), VERIFY_URL 为空回落 NO-REMOTE-STATE 语义, manifest_checks 抽公共函数消重。回归 7 场景全绿: clean pushed rc0 (audit-ignore 生效)/detached 命中/unreachable 命中带 err/无远端 NO-REMOTE-STATE/分支缺失 NO-REMOTE-STATE/stale+never-verified/JSON 合法。v1.0.9, commit `3baca47` push, HEAD==origin/main 实锤。
- 2026-11-06 tick28: SkillsMP 复查 (Friday 周查, 降级后首次新节奏): #1 git-backup-discipline 两条 updatedAt 仍 10-25 (**pending 12 天, 远超 4-11 天历史窗口** — v1.0.4-v1.0.9 六个版本未重抓, 索引机制疑似停摆或降频, 下 tick 人工看 listing 页面核实); #2 agent-token-budget (10-18)/#3 release-checklist-discipline (10-19) 不变; API 200, 今日无 CF challenge。G 点改进 (计量数据完整性, 自审#9, 真实功能缺陷): budget_check.sh 的 per-run 检查遇到 meter 行 token 字段为非数字/空 (日志被截断/手改/磁盘损坏) 时, awk 静默按 0 计入日用量, bash 整数比较抛 integer-expression stderr 噪声但语义与真实 breach 不可区分——把「日志损坏」混同「超支」。修复: 非数字/空 token 字段改为独立 BREACH 消息 (meter line corrupt, 带 run id 定位), rc=1 fail-closed, awk 同步加显式正则校验, 旧 integer-expression 噪声消除。回归 7 场景全绿: corrupt 行 rc1 带 corrupt 消息无 awk 噪声 / clean rc0 / 数值 per-run breach rc1 / mixed-alnum 字段命中 corrupt / 旧日期 corrupt 行不影响今日 / 日 ceiling 照常 / 空字段命中。v1.3.0。
- 2026-11-07 tick29: SkillsMP 复查: API/页面均被 Cloudflare challenge 拦截 (40s+ 重试未放行, 列表页人工核实顺延至下次放行窗口); 昨日 API 200 vs 今日 CF 全拦, 站点侧防护策略变化, 记录跳过。G 点改进 (计量器自身成本, 市场调研驱动: caveman 111k 星 / context-rot 治理文均指向「agent 自身 context/IO 膨胀」是热销共性主题): log_usage.sh 只 append 永不轮转, cron 场景跑一年后 TOKENS.log 数万行, budget_check.sh 每次 grep 全文, 日志自身成为 context/IO 负担。新增 rotate_meter.sh: 超行数阈值 (默认 5000, TOKENS_ROTATE_LINES 或 CLI 覆盖) 即 mv 到 TOKENS.log.1 归档重开, 低于阈值/日志不存在静默 rc0, 非数字阈值 rc1 fail-closed。回归 6 场景全绿: 6000 行触发轮转归档 6000 行 / 二次调用阈值内 no-op / 非数字 max rc1 / 缺失日志 rc0 / 轮转后 budget_check 今日 sum 正确 (旧期行在归档不混入) / 正常 rc0。v1.4.0。
- 2026-11-09 tick31: SkillsMP 复查: API 解封 (200, 无 CF), 三 skill updatedAt 均未变 — #1 10-25 (pending 15 天, 确认索引重抓长期停摆/降频), #2 10-18 / #3 10-19 不变; stars 全 0, 降级周查节奏维持。G 点改进 (v1.5.0 引入的自相矛盾, 自审#12, 真实功能缺陷): v1.5.0 让 log_usage.sh 在写路径自动轮转后, budget_check.sh 仍只读当前 log——日内轮转把当日早期 meter 行归档进 <log>.1, 日 sum 静默漏计, 日 ceiling 在「轮转后」恰好失效, 与 v1.5.0 的目标 (轮转成为常态) 直接冲突。修复: budget_check.sh 日 sum 与 per-run/日 ceiling 校验均读 当前 log + <log>.1, 按 TODAY 日期过滤 (stale 期行不混入)。回归 6 场景全绿: 日内轮转后真实 breach rc1 (旧逻辑 rc0 漏报实锤复现) / 单日志 clean rc0 / 无归档日 breach / 归档 corrupt 行命中 / 昨日归档行不计入 / 归档内 per-run breach 命中。v1.6.0。
- 2026-11-10 tick32: SkillsMP 复查: API/页面均被 Cloudflare challenge 拦截 (`cf-mitigated: challenge`, 重试未放行), 列表核实顺延至下次放行窗口; 上 tick API 200 vs 今日全拦, 站点防护策略波动, #1 停摆周查节奏维持。G 点改进 (归档销毁, 自审#13, v1.5.0/v1.6.0 链的真实功能缺陷): log_usage.sh 与 rotate_meter.sh 的轮转用 `mv -f` **覆盖** `<log>.1` 归档——同日发生第二次轮转时, 前一份归档连同其中的当日 meter 行被静默销毁, v1.6.0 刚修的「读归档补日 sum」随之失效。fixture 实锤复现: 两轮各 5 行 (全部当日), 修复前归档仅存后 5 行, budget_check 日 sum=500 (真实 1000), 日 ceiling 900 的 breach 漏报 rc0。修复: 轮转改为合并归档 (cat 旧归档+当前 log → tmp → mv 原子替换), 两处写路径同步, 最旧行保持在最前。回归 13 断言全绿: 双轮转归档保全 10 行/最旧行序/日 sum 完整/日 breach rc1 (旧逻辑 rc0 实锤复现)/首次轮转 plain move/手动 rotate 合并/无 tmp 残留/过期归档行不计入 (日期过滤)/clean rc0/归档 corrupt 行命中/非数字阈值 rc1。v1.7.0。
- 2026-11-12 tick33: SkillsMP 复查: API/页面均 CF challenge (403, `cf-mitigated: challenge`), 与前 tick 一致, 列表核实顺延; #1 停摆周查节奏维持。G 点改进 (付费转化特性落地, 自审#14, 消费者调研驱动): Agent37/Agensi/KissMySkills 2026 指南一致指向两大付费共性——买单前要看到成品样例、隐藏依赖是安装失败首因; agent-token-budget 有 config 样例但无真实运行输出、README 无依赖说明。修复: 新增 `examples/example-output.md`——真实跑 budget_check.sh 产出的 halt-and-log breach (rc=1)/notify-only 观察态 (rc=0)/corrupt config rc=1/缺文件 rc=1 四场景, 全部输出行机械 diff 验证与真实捕获逐字节一致 (非手编); README 加 Requirements 段 (bash + GNU/BSD sed/awk/grep, 无 Python/Node/网络)。SKILL.md 1.7.1; RELEASING 安全扫描 grep 0 命中。commit `5029b05` push, HEAD==origin/main 实锤。
- 2026-11-13 tick34: SkillsMP 复查: API/页面均 CF challenge (403, cf-mitigated: challenge), 与前两 tick 一致, 列表核实顺延; #1 停摆周查节奏维持。G 点改进 (付费转化特性第三只补齐, 自审16): release-checklist-discipline v1.0.0 有 .example 配置样例但无真实运行输出, README 无依赖段——且其 checklist 解析实际依赖 python3, 文档完全未提, 是真实安装失败点。修复: 新增 examples/example-output.md——沙箱 fixture 真跑 release_check.sh 四场景: clean rc=0 / dirty rc=1 (token/glob/term/require 四类 violation 全带 file:line) / 缺 checklist rc=1 / 空 repo rc=1, 全部输出行 grep -F 机械验证与真实捕获逐字节一致 (fixture 用的 fake token 经脚本自身 masking, 无泄漏); README 加 Requirements 段 (bash+git+python3 标准库, 无第三方包/无网络) 并链接 example。SKILL.md 1.1.0; RELEASING 检查单: secrets/internal refs/absolute paths grep 0 命中。
