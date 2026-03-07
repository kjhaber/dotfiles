# git-worktree-fzf
# ZSH shell utilities for working with git worktree dirs via fzf

# Use fzf to pick an item from 'git worktree list' and print it
pick_worktree_dir() {
  local list dir
  list=$(git worktree list 2>&1) || {
    echo "$list" >&2
    return 1
  }
  dir=$(echo "$list" | fzf --height=~50% --reverse --select-1 | awk '{print $1}')
  printf "$dir"
}

# Use fzf to pick an item from 'git worktree list', then cd to selected item dir
cdworktree() {
  local dir
  dir=$(pick_worktree_dir)
  [[ -n "$dir" ]] && cd "$dir"
}

# Use fzf to pick an item from 'git worktree list', then remove it
rmworktree() {
  local dir branch
  dir=$(pick_worktree_dir)
  if [[ -z "$dir" ]]; then
    return
  fi
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    echo "Refusing to remove worktree for branch '${branch}': ${dir}" >&2
    return 1
  fi
  git worktree remove "$dir" && echo "Removed worktree dir ${dir}"
}
