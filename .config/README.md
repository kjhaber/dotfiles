# Claude Code settings

As of March 2026, Claude Code settings don't support importing configs or reading configs from multiple user-level locations.  To allow global dotfile configs (~/.config) and local machine dotfile configs (~/.config-local) I'm doing a bit of a hack:
* Claude Code is launched with ~/.config/bin/claude wrapper script.
* The wrapper script merges configs from ~/.config/claude and ~/.config-local/claude and writes them to ~/.claude where Claude Code will really pick them up.
* The wrapper script flags changes and prompts before overwriting, so if something else updated ~/.claude/settings (like Claude Code itself), you'll know in advance.

## Capturing and restoring Claude sessions in tmux

`bin/agent-capture` prints the Claude Code sessions running in tmux panes, one per line (`-c` copies to the clipboard instead):

```
mysession:1,~/projects/mycoolproject,claude:9e49b7ad-87db-4d16-9ede-7665fa6301f6 # add-feature
mysession:2,~/projects/mycoolproject,claude:7ede57a2-4ace-44be-8eb1-ebaea63bf7a3 # fix-bug
mysession:2,~/projects/mycoolproject,claude:03ca029b-dd36-46c1-8c3e-bc93a51171e8 # split pane in window 2
```

* Format is `tmux-session:window-index,path,claude:session-id # optional name`. Lines sharing a `session:window` are split panes of one window. Everything after ` #` is ignored on restore, so you can edit session/window names to reshuffle agents between tmux sessions.
* `bin/agent-restore` reads that format from stdin (`-c` reads the clipboard). It creates missing tmux sessions, creates each window at its captured index (appending if that index is taken), tiles split panes, and types `claude --resume <id>` in each pane. Sessions already running are skipped, so it's safe to re-run. Lines it can't restore (missing directory, unsupported app, malformed) are reported and make the exit status 1.
* Session ids come from the `~/.claude/sessions/<pid>.json` files Claude Code writes for each live process (they record the tmux pane), so no hooks are required.
* Shared logic lives in `bin/lib/agent-common.sh`.

# Tests

`make all` runs shellcheck and the bats tests under `tests/` (currently covering the agent-* scripts). Add a script to `TESTED_SCRIPTS` in the Makefile when you add tests for it.

