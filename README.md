# Skills

Personal agent skills, installable with the [`skills`](https://github.com/vercel-labs/skills) CLI.

## Install

```sh
# Pick from every skill in the repo
npx skills add jakewtaylor/skills

# Install one skill globally for Claude Code
npx skills add jakewtaylor/skills --skill remind-me -g -a claude-code
```

## Skills

| Skill | Description |
| --- | --- |
| [remind-me](skills/remind-me/SKILL.md) | Capture a personal todo or reminder in Todoist. |

## Adding a skill

Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter. The `name` must match the directory name.
