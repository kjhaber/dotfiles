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

# Print absolute path of an already-registered worktree where refs/heads/<branch> is checked out
_worktree_find_path_for_branch() {
  local branch="$1"
  local dir="" line ref
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == worktree\ * ]]; then
      dir="${line#worktree }"
    elif [[ "$line" == branch\ * ]]; then
      ref="${line#branch }"
      if [[ "$ref" == "refs/heads/$branch" ]]; then
        echo "$dir"
        return 0
      fi
    fi
  done < <(git worktree list --porcelain 2>/dev/null)
  return 1
}

# Print the filesystem path where a new worktree for <branch> would be placed (same rules as mkworktree)
_worktree_computed_path_for_branch() {
  local branch="$1"
  local main_worktree main_name worktrees_root safe_branch
  main_worktree=$(git worktree list | head -1 | awk '{print $1}')
  main_name=$(basename "$main_worktree")
  worktrees_root=$(dirname "$main_worktree")
  safe_branch="${branch//\//-}"

  if [[ "$main_name" == "main" || "$main_name" == "master" ]]; then
    echo "${worktrees_root}/${safe_branch}"
  else
    echo "${worktrees_root}/${main_name}_${safe_branch}"
  fi
}

# True if current session has a window whose name exactly matches $1
_tmux_has_window_named() {
  local name="$1"
  [[ -n "$name" ]] || return 1
  tmux list-windows -F '#{window_name}' 2>/dev/null | grep -Fqx "$name"
}

# Open a new tmux window in the worktree for <branch>, creating the worktree if needed (non-interactive).
# If a window named like the branch's short name already exists in this session, select it instead.
# Intended for tmux key bindings; requires TMUX. Git repo is only required when no matching window exists.
worktree_tmux_window() {
  local branch="$1" dir add_out add_status win
  branch="${branch:?usage: worktree_tmux_window <branch>}"
  [[ -n "$TMUX" ]] || {
    echo "worktree_tmux_window: not running inside tmux" >&2
    return 1
  }

  win="${branch##*/}"
  if _tmux_has_window_named "$win"; then
    tmux select-window -t "=$win"
    return 0
  fi

  git rev-parse --is-inside-work-tree &>/dev/null || {
    echo "worktree_tmux_window: not a git repository (cwd=$(pwd))" >&2
    return 1
  }

  if dir=$(_worktree_find_path_for_branch "$branch"); then
    tmux new-window -n "$win" -c "$dir"
    return 0
  fi

  dir=$(_worktree_computed_path_for_branch "$branch")

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    add_out=$(git worktree add "$dir" "$branch" 2>&1)
    add_status=$?
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    add_out=$(git worktree add --track -b "$branch" "$dir" "origin/$branch" 2>&1)
    add_status=$?
  else
    add_out=$(git worktree add -b "$branch" "$dir" 2>&1)
    add_status=$?
  fi

  if (( add_status == 0 )); then
    tmux new-window -n "$win" -c "$dir"
    return 0
  fi

  if [[ "$add_out" == *"already exists"* ]] && git worktree list | awk '{print $1}' | grep -Fqx "$dir"; then
    tmux new-window -n "$win" -c "$dir"
    return 0
  fi

  echo "$add_out" >&2
  return 1
}

# Create a new git worktree for a branch, then cd into it
# Usage: mkworktree <branch>
# If <branch> doesn't exist locally, creates it (tracking remote if available)
mkworktree() {
  local branch dir add_out add_status
  branch="${1:?usage: mkworktree <branch>}"

  if dir=$(_worktree_find_path_for_branch "$branch"); then
    echo "Worktree for '$branch' already exists at $dir"
    if read -q "?Switch there? [y/N] "; then
      echo
      cd "$dir" || return 1
      if [[ -n "$TMUX" ]]; then
        tmux rename-window "${branch##*/}"
      fi
      return 0
    fi
    echo >&2
    return 1
  fi

  dir=$(_worktree_computed_path_for_branch "$branch")

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    # Branch exists locally
    add_out=$(git worktree add "$dir" "$branch" 2>&1)
    add_status=$?
  elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    # Branch exists on remote — create local tracking branch
    add_out=$(git worktree add --track -b "$branch" "$dir" "origin/$branch" 2>&1)
    add_status=$?
  else
    # New branch off current HEAD
    add_out=$(git worktree add -b "$branch" "$dir" 2>&1)
    add_status=$?
  fi

  if (( add_status == 0 )); then
    echo "Created worktree at $dir"
  elif [[ "$add_out" == *"already exists"* ]]; then
    echo "$add_out" >&2
    if git worktree list | awk '{print $1}' | grep -Fqx "$dir"; then
      if read -q "?Switch to existing worktree at $dir? [y/N] "; then
        echo
        cd "$dir" || return 1
        if [[ -n "$TMUX" ]]; then
          tmux rename-window "${branch##*/}"
        fi
        return 0
      fi
      echo >&2
    else
      echo "Path exists but is not a registered worktree for this repo." >&2
    fi
    return 1
  else
    echo "$add_out" >&2
    return 1
  fi

  cd "$dir" || return 1

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
