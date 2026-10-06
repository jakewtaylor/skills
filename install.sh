#!/usr/bin/env bash
# Install or update upstream skills globally, then reapply the patches in
# overrides/. Safe to run repeatedly.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"

# One entry per upstream skill: "<source> <skill>".
upstream=(
  "cursor/plugins/pstack unslop"
)

for entry in "${upstream[@]}"; do
  read -r source skill <<<"$entry"
  echo "Installing $skill from $source"
  # Reinstalling overwrites the skill with a clean upstream copy.
  npx -y skills add "$source" -g -y -s "$skill"
done

# Without -a, `skills add -g` writes the files to ~/.agents/skills/<skill> and
# symlinks ~/.claude/skills/<skill> to it. With --copy, or with only
# `-a claude-code`, Claude Code gets its own copy instead. Patch every distinct
# file so both layouts end up the same.
targets_for() {
  local dir
  for dir in "$HOME/.agents/skills/$1" "$HOME/.claude/skills/$1"; do
    if [[ -f "$dir/SKILL.md" ]]; then (cd -P "$dir" && pwd); fi
  done | sort -u
}

for patch_file in "$repo"/overrides/*.patch; do
  [[ -e "$patch_file" ]] || continue
  skill="$(basename "$patch_file" .patch)"
  targets="$(targets_for "$skill")"
  if [[ -z "$targets" ]]; then
    echo "error: $skill has a patch in overrides/ but is not installed" >&2
    exit 1
  fi

  while read -r dir; do
    if patch -d "$dir" -p1 -f -s -F0 --dry-run <"$patch_file" >/dev/null 2>&1; then
      patch -d "$dir" -p1 -f -s -F0 <"$patch_file"
      echo "Patched $skill in $dir"
    elif patch -d "$dir" -p1 -f -s -F0 -R --dry-run <"$patch_file" >/dev/null 2>&1; then
      echo "$skill in $dir is already patched"
    else
      echo "error: overrides/$skill.patch no longer applies to $dir/SKILL.md." >&2
      echo "Upstream $skill has changed. Regenerate the patch (see README)." >&2
      exit 1
    fi
  done <<<"$targets"
done
