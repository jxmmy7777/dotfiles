#!/bin/bash
# Claude Code status line: model | context% (tokens) | path

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // .model // "unknown"' 2>/dev/null)
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' 2>/dev/null)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""' 2>/dev/null)

# Shorten path: replace $HOME with ~
short_path="${cwd/#$HOME/~}"
[ -z "$short_path" ] && short_path="~"

# Color the context %: green < 35, yellow 35-59, red >= 60
reset=$'\033[0m'
if [ "$pct" -ge 60 ] 2>/dev/null; then
  ctx_color=$'\033[31m'   # red
elif [ "$pct" -ge 35 ] 2>/dev/null; then
  ctx_color=$'\033[33m'   # yellow
else
  ctx_color=$'\033[32m'   # green
fi

echo "${model} | ${ctx_color}ctx ${pct}%${reset} | ${short_path}"
