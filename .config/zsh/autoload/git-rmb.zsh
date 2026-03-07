# rmb - remove branch or worktree
# Usage: rmb [-y|--yes] [branch]
#   No args: fzf picker over branches (excluding main/master); remove selected.
#   branch: remove that branch (worktree dir or git branch -d).
#   . (dot): if current dir is a worktree, remove it and cd to main/master worktree.
#   -y/--yes: skip confirmation when deleting a non-worktree branch.
# See ~/.config/zsh/completions/_rmb for tab completion

_rmb_worktree_path() {
  local branch="$1"
  [[ -z "$branch" ]] && return 1
  git worktree list --porcelain 2>/dev/null | awk -v branch="$branch" '
    /^worktree / { path = $2; for (i=3;i<=NF;i++) path = path " " $i }
    /^branch refs\/heads\// { b = $2; sub(/^refs\/heads\//, "", b); if (b == branch) { print path; exit } }
  '
}

_rmb_primary_worktree_path() {
  local path
  path=$(_rmb_worktree_path "main")
  [[ -n "$path" ]] && { echo "$path"; return 0 }
  path=$(_rmb_worktree_path "master")
  [[ -n "$path" ]] && echo "$path"
}

_rmb_is_worktree_root() {
  local wdir
  for wdir in ${(f)"$(git worktree list --porcelain 2>/dev/null | awk '/^worktree / { path = $2; for (i=3;i<=NF;i++) path = path " " $i; print path }')"}; do
    [[ "$PWD" == "$wdir" ]] && return 0
  done
  return 1
}

rmb() {
  local branch confirm=0 dir primary reply
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
    if ! _rmb_is_worktree_root; then
      echo "Current directory is not a worktree root." >&2
      return 1
    fi
    branch=$(git branch --show-current 2>/dev/null)
    if [[ "$branch" == "main" || "$branch" == "master" ]]; then
      echo "Refusing to remove worktree for branch '${branch}'." >&2
      return 1
    fi
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
    read "reply?Remove branch '${branch}'? [y/N] "
    [[ "${reply:l}" != y && "${reply:l}" != yes ]] && return 0
  fi

  if ! git branch -d "$branch"; then
    echo "Use 'git branch -D ${branch}' to force-delete an unmerged branch." >&2
    return 1
  fi
}

