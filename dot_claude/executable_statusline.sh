#!/bin/bash
# Claude Code status line: model | context% (tokens) | path

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // .model // "unknown"' 2>/dev/null)
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' 2>/dev/null)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""' 2>/dev/null)

# Shorten path: replace $HOME with ~
short_path="${cwd/#$HOME/~}"
[ -z "$short_path" ] && short_path="~"

echo "${model} | ctx ${pct}% | ${short_path}"
