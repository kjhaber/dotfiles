# cdworktree
# Use fzf to pick an item from 'git worktree list', then cd to selected item dir
cdworktree() {
  local list dir
  list=$(git worktree list 2>&1) || {
    echo "$list" >&2
    return 1
  }
  dir=$(echo "$list" | fzf --height=~50% --reverse --select-1 | awk '{print $1}')
  [[ -n "$dir" ]] && cd "$dir"
}

