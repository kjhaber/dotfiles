---
description: Merge the current feature branch into main and mark the wn item done. Use when the user invokes "/wn-merge" after reviewing a branch implemented by /wn-implement.
---

Merge the current feature branch into main and mark the item done. Run each step in sequence — stop and report if anything fails.

## Step 1: Identify the branch and item ID

```bash
git rev-parse --abbrev-ref HEAD
```

Branch names follow the pattern `[prefix]wn-<id>-<slug>` (e.g. `wn-44e8a3-saved-views` or `keith/wn-44e8a3-saved-views`). Extract the 6-character hex item ID from after `wn-`.

If the branch doesn't match this pattern, stop and ask the user to confirm the item ID manually before continuing.

## Step 2: Detect working context and capture main root

Determine whether you're in a linked worktree or working directly on a branch in the main repo:

```bash
git rev-parse --git-dir
git rev-parse --git-common-dir
```

- **Linked worktree**: the two outputs differ (`--git-dir` is a path under `--git-common-dir/worktrees/`)
- **Branch-only**: the two outputs are the same (both `.git` or the same absolute path)

In either case, capture the main root by stripping the trailing `/.git` from the `--git-common-dir` output. MCP tools auto-detect this, so no need to pass `root` explicitly.

## Step 3: Sync main into the feature branch

Before merging into main, bring the feature branch up to date with main so any conflicts are resolved here rather than on main.

From the feature branch (current directory):
```bash
git fetch origin
git merge <main_branch>   # e.g. git merge main
```

If there are merge conflicts, resolve them, stage the fixes, and complete the merge (`git merge --continue`). Report what was merged and any conflicts resolved.

## Step 4: Verify the feature branch

Run `wn verify` to confirm the branch is still green after syncing. If it fails, stop and report — do not proceed with the merge into main.

## Step 5: Squash-merge into main

Combine all feature branch commits into a single commit on main.

**If in a linked worktree** (the main worktree is already on main):
```bash
git -C <main_root> merge --squash <branch>
git -C <main_root> commit -m "<unified message>"
```

**If branch-only** (main repo, currently on the feature branch):
```bash
git checkout main
git merge --squash <branch>
git commit -m "<unified message>"
```

Compose a unified commit message that accurately summarizes the actual change. The wn item title is a useful starting point, but the implementation may have evolved — write a message that reflects what was actually built, not just what was originally planned.

If the merge or commit fails (e.g. conflict, nothing to commit), stop and report.

## Step 6: Verify main after merge

Run `wn verify` from the main root as a sanity check:

```bash
cd <main_root> && wn verify
```

If it fails, report the failure. Do not mark the item done until main is green.

## Step 7: Mark done

Call `wn_done` with the item ID (no `root` needed — MCP auto-detects).

Report: item ID, branch merged, item marked done. The feature branch remains and can be deleted with `git branch -d <branch>` once no longer needed.
