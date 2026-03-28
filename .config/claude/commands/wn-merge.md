---
description: Merge the current feature branch into main and mark the wn item done. Use when the user invokes "/wn-merge" after reviewing a branch implemented by /wn-implement.
---

Merge the current feature branch into main and mark the item done. Run each step in sequence — stop and report if anything fails.

## Step 1: Identify the branch

```bash
git rev-parse --abbrev-ref HEAD
```

This is the `<branch>` used in later steps.

## Step 2: Capture the main repo root

```bash
wn root
```

This prints the absolute path to the main repo root, worktree-aware. Use it as `<main_root>` in later steps.

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

## Step 5: Squash-merge, record commit, and mark done

Compose a unified commit message that accurately summarizes the actual change. The wn item title is a useful starting point, but the implementation may have evolved — write a message that reflects what was actually built, not just what was originally planned.

Run from `<main_root>`:
```bash
wn merge <branch> -m "<unified message>"
```

`wn merge` squash-merges the branch into main, records the commit hash as a `wn:commit` note, and marks the item done — all in one step. It finds the associated wn item via the `wn:branch` note on the branch.

If the merge fails (e.g. conflict, nothing to commit), stop and report.

## Step 6: Verify main after merge

Run `wn verify` from the main root as a sanity check:

```bash
wn verify --root
```

If it fails, report the failure.

Report: branch merged, squash commit recorded, item marked done. The feature branch remains and can be deleted with `git branch -d <branch>` once no longer needed.

