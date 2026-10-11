# ato-e1-skill-factory

Production-grade agent skills packaged as portable SKILL.md files (agentskills.io open standard), installable across Claude Code, Codex, ChatGPT and other agent platforms.

## Skills

| Skill | Description | Status |
|-------|-------------|--------|
| [git-backup-discipline](skills/git-backup-discipline/) | Fail-closed backup discipline: backup manifest + verified push + gap audit. Never trust "committed" — prove "backed up." | v1.0.0 |

Install: `npx skills add AthenaMohist/ato-e1-skill-factory`

## Repository layout

- `skills/` - one directory per skill: `SKILL.md` + `README.md` + `examples/`
- `docs/` - marketplace research and packaging notes
- `listings/` - published listing URLs and public metrics per channel

## License

MIT
