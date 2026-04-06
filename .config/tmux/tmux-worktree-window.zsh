#!/usr/bin/env zsh
# Entry point for tmux `prefix W`: open a new window in a worktree for the given branch.
# Usage: tmux-worktree-window.zsh <branch>
# Expect cwd to be the pane path (tmux run-shell cd's there first).

here=${0:A:h}
source "$here/../zsh/autoload/git-worktree-fzf.zsh"
worktree_tmux_window "$1"
