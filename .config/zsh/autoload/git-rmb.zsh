# rmb - remove branch or worktree
# Usage: rmb [-y|--yes] [branch]
#   No args: fzf picker over branches (excluding main/master); remove selected.
#   branch: remove that branch (worktree dir or git branch -d).
#   . (dot): if current dir is a worktree root, remove it and cd to main/master; else checkout main/master and delete current branch.
#   -y/--yes: skip confirmation when deleting a non-worktree branch.
# See ~/.config/zsh/completions/_rmb for tab completion

_rmb_worktree_path() {
  local branch="$1" lines line path i
  [[ -z "$branch" ]] && return 1
  lines=("${(@f)$(git worktree list --porcelain 2>/dev/null)}")
  path=""
  for i in {1..$#lines}; do
    line="$lines[$i]"
    if [[ "$line" == worktree\ * ]]; then
      path="${line#worktree }"
    elif [[ "$line" == branch\ refs/heads/* ]]; then
      if [[ "${line#branch refs/heads/}" == "$branch" ]]; then
        echo "$path"
        return 0
      fi
    fi
  done
  return 1
}

_rmb_primary_worktree_path() {
  # When in a linked worktree, git-dir is /path/to/main/.git/worktrees/<name>
  local git_dir primary
  git_dir=$(git rev-parse --git-dir 2>/dev/null) || return 1
  if [[ "$git_dir" == *"/.git/worktrees/"* ]]; then
    primary="${git_dir%/.git/worktrees/*}"
    [[ -d "$primary" ]] && echo "$primary"
  fi
}

_rmb_is_worktree_root() {
  # In a worktree, git-dir is under .git/worktrees/<name>; in main repo it's .git
  local git_dir
  git_dir=$(git rev-parse --git-dir 2>/dev/null) || return 1
  [[ "$git_dir" == *"/.git/worktrees/"* ]]
}

rmb() {
  local branch confirm=0 dir primary reply
  # Parse -y/--yes from anywhere in args
  for arg in "$@"; do
    [[ "$arg" == -y || "$arg" == --yes ]] && confirm=1 && break
  done
  while [[ $# -gt 0 && "$1" == -* ]]; do
    case "$1" in
      -y|--yes) confirm=1 ;;
      *) echo "Unknown option: $1" >&2; return 1 ;;
    esac
    shift
  done

  if [[ "${1:-}" == "." ]]; then
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
      echo "Not a git repository." >&2
      return 1
    fi
    branch=$(git branch --show-current 2>/dev/null)
    if [[ "$branch" == "main" || "$branch" == "master" ]]; then
      echo "Refusing to remove branch '${branch}'." >&2
      return 1
    fi
    if _rmb_is_worktree_root; then
      primary=$(_rmb_primary_worktree_path)
      if [[ -z "$primary" ]]; then
        echo "Could not determine primary worktree (main/master)." >&2
        return 1
      fi
      dir="$PWD"
      cd "$primary" || return 1
      git worktree remove "$dir" && echo "Removed worktree dir ${dir}"
      return $?
    fi
    # Not a worktree root: checkout main/master then delete current branch
    local primary_branch
    if git show-ref --quiet refs/heads/main 2>/dev/null; then
      primary_branch=main
    elif git show-ref --quiet refs/heads/master 2>/dev/null; then
      primary_branch=master
    else
      echo "No main or master branch found." >&2
      return 1
    fi
    if [[ $confirm -eq 0 ]]; then
      print -n "Remove branch '${branch}' and checkout ${primary_branch}? [y/N] "
      read -k 1 reply
      print
      [[ "${reply:l}" != y ]] && return 0
    fi
    git checkout "$primary_branch" || return 1
    if ! git branch -d "$branch"; then
      echo "Use 'git branch -D ${branch}' to force-delete an unmerged branch." >&2
      return 1
    fi
    return 0
  fi

  if [[ $# -eq 0 ]]; then
    branch=$(git branch --format='%(refname:short)' 2>/dev/null |
      grep -v -E '^(main|master)$' |
      fzf --no-multi --height 40% --prompt 'branch to remove> ')
    [[ -z "$branch" ]] && return 0
  else
    branch="$1"
  fi

  if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    echo "Refusing to remove branch '${branch}'." >&2
    return 1
  fi

  dir=$(_rmb_worktree_path "$branch")
  if [[ -n "$dir" && -d "$dir" ]]; then
    git worktree remove "$dir" && echo "Removed worktree dir ${dir}"
    return $?
  fi

  if [[ $confirm -eq 0 ]]; then
    print -n "Remove branch '${branch}'? [y/N] "
    read -k 1 reply
    print
    [[ "${reply:l}" != y ]] && return 0
  fi

  if ! git branch -d "$branch"; then
    echo "Use 'git branch -D ${branch}' to force-delete an unmerged branch." >&2
    return 1
  fi
}

