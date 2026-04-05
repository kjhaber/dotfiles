#!/bin/sh
# Claude Code statusLine command

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
vim_mode=$(echo "$input" | jq -r '.vim.mode // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_window_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Current directory (last segment, like %1~ in zsh)
dir=$(basename "$cwd")

# Git branch (skip optional locks to avoid blocking)
git_branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

# Vim mode indicator (mirrors VIMODE_TXT in theme)
if [ "$vim_mode" = "NORMAL" ]; then
  vimode_txt="✦"
  vimode_color="\033[35m"   # magenta
else
  vimode_txt="↪"
  vimode_color="\033[36m"   # cyan
fi

# Context usage indicator with absolute size
ctx=""
if [ -n "$used_pct" ] && [ -n "$ctx_window_size" ]; then
  ctx_int=$(printf '%.0f' "$used_pct")
  # Convert context window size to nearest k (e.g. 200000 -> 200k)
  ctx_k=$(printf '%.0fk' "$(echo "$ctx_window_size" | awk '{print $1/1000}')")
  ctx=" [ctx:${ctx_int}%% ${ctx_k}]"
elif [ -n "$used_pct" ]; then
  ctx_int=$(printf '%.0f' "$used_pct")
  ctx=" [ctx:${ctx_int}%%]"
fi

# Git branch display (mirrors git_rprompt, magenta)
branch_part=""
if [ -n "$git_branch" ]; then
  branch_part=" | \033[35m${git_branch}\033[0m"
fi

# Compose: vimode | dir [branch] | model ctx
printf "${vimode_color}${vimode_txt}\033[0m \033[31m${dir}\033[0m${branch_part}"
if [ -n "$model" ]; then
  printf " | \033[0m${model}"
fi
if [ -n "$ctx" ]; then
  printf "\033[2m${ctx}\033[0m"
fi
printf "\n"
