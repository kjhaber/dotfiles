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

# Create a new git worktree for a branch, then cd into it
# Usage: mkworktree <branch>
# If <branch> doesn't exist locally, creates it (tracking remote if available)
mkworktree() {
  local branch dir worktrees_root main_worktree main_name safe_branch
  branch="${1:?usage: mkworktree <branch>}"

  # Derive placement from the main worktree path
  main_worktree=$(git worktree list | head -1 | awk '{print $1}')
  main_name=$(basename "$main_worktree")
  worktrees_root=$(dirname "$main_worktree")
  safe_branch="${branch//\//-}"

  # If main worktree dir is named "main" or "master", it lives inside a container
  # dir — place new worktree as a sibling without prefix (e.g. wn/feat-example).
  # Otherwise the main worktree IS the project root — prefix with project name
  # so new worktrees are siblings of it (e.g. spire-feat-example).
  if [[ "$main_name" == "main" || "$main_name" == "master" ]]; then
    dir="${worktrees_root}/${safe_branch}"
  else
    dir="${worktrees_root}/${main_name}_${safe_branch}"
  fi

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    # Branch exists locally
    git worktree add "$dir" "$branch" || return 1
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    # Branch exists on remote — create local tracking branch
    git worktree add --track -b "$branch" "$dir" "origin/$branch" || return 1
  else
    # New branch off current HEAD
    git worktree add -b "$branch" "$dir" || return 1
  fi

  echo "Created worktree at $dir"
  cd "$dir"

  if [[ -n "$TMUX" ]]; then
    tmux rename-window "${branch##*/}"
  fi
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
