# ato-e1-skill-factory

Production-grade agent skills packaged as portable SKILL.md files (agentskills.io open standard), installable across Claude Code, Codex, ChatGPT and other agent platforms.

## Skills

| Skill | Description | Status |
|-------|-------------|--------|
| [git-backup-discipline](skills/git-backup-discipline/) | Fail-closed backup discipline: backup manifest + verified push + gap audit. Never trust "committed" — prove "backed up." | v1.0.2 |
| [agent-token-budget](skills/agent-token-budget/) | Enforce an explicit token budget with measurable gates: context sizing, output discipline, breach halts. Turns "the model is expensive" into "the model is metered." | v1.0.0 |
| [release-checklist-discipline](skills/release-checklist-discipline/) | Fail-closed pre-release audit that blocks secrets, internal references, and debris from reaching a public remote. | v1.0.0 |

Install: `npx skills add AthenaMohist/ato-e1-skill-factory`

The three skills are designed as a set: **backup discipline** proves your work is safe, **token budget** keeps the unattended agent affordable, and **release checklist** gates what leaves the machine. All enforcement scripts are fail-closed (non-zero exit on violation), portable across GNU/BSD userlands, and self-tested.

## Repository layout

- `skills/` - one directory per skill: `SKILL.md` + `README.md` + `examples/`
- `docs/` - marketplace research and packaging notes
- `listings/` - published listing URLs and public metrics per channel

## License

MIT
