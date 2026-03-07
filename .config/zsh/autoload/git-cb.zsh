# cb - checkout branch or cd to worktree
# Usage: cb [branch]
#   No args: fzf picker over git branches; selection checkouts or cds to worktree.
#   With branch: if branch has a worktree, cd to it; else git checkout branch.
# See ~/.config/zsh/completions/_cb for tab completion

_cb_worktree_path() {
  local branch="$1"
  _cb_path=
  [[ -z "$branch" ]] && return 1
  _cb_path=$(git worktree list --porcelain 2>/dev/null | awk -v branch="$branch" '
    /^worktree / { path = $2; for (i=3;i<=NF;i++) path = path " " $i }
    /^branch refs\/heads\// { b = $2; sub(/^refs\/heads\//, "", b); if (b == branch) { print path; exit } }
  ')
  [[ -n "$_cb_path" ]]
}

cb() {
  local branch
  if (( $# == 0 )); then
    branch=$(git branch --format='%(refname:short)' | fzf --no-multi --height 40% --prompt 'branch> ')
    [[ -z "$branch" ]] && return 0
  else
    branch="$1"
  fi

  if _cb_worktree_path "$branch" && [[ -n "$_cb_path" && -d "$_cb_path" ]]; then
    cd "$_cb_path" || return 1
  else
    git checkout "$branch" || return 1
  fi
}

