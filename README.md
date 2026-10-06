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

## Upstream skills with overrides

`install.sh` installs the skills listed in its `upstream` array from their own repos, then applies `overrides/<skill>.patch` to each installed copy. On a new machine, clone this repo and run it:

```sh
git clone git@github.com:jakewtaylor/skills.git && skills/install.sh
```

Rerun it to pull upstream updates. Each run reinstalls a clean upstream copy and patches it again. `npx skills add -g` writes the files to `~/.agents/skills/<skill>` and links `~/.claude/skills/<skill>` to that folder, so the script patches the file Claude Code reads.

| Skill | Upstream | Override |
| --- | --- | --- |
| unslop | `cursor/plugins`, `pstack/skills/unslop` | Model-invocable, with a description that covers all prose. |

### Change an override or regenerate a patch

When upstream changes under a patch, `install.sh` stops with `overrides/<skill>.patch no longer applies`. It leaves the clean upstream file installed. The same steps cover editing an override:

```sh
skill=unslop
work=$(mktemp -d) && mkdir "$work/a" "$work/b"
npx skills add cursor/plugins/pstack -g -y -s "$skill"    # reset to clean upstream
cp ~/.agents/skills/$skill/SKILL.md "$work/a/"
cp ~/.agents/skills/$skill/SKILL.md "$work/b/"
patch -d "$work/b" -p1 < overrides/$skill.patch           # start from the old override, fix any rejects by hand
$EDITOR "$work/b/SKILL.md"
(cd "$work" && diff -u a/SKILL.md b/SKILL.md) > overrides/$skill.patch
./install.sh
```

To override another upstream skill, add it to the `upstream` array in `install.sh` and save its patch as `overrides/<skill>.patch`.
