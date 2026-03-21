---
description: Merge the current worktree branch into main and mark the wn item done. Use when the user invokes "/wn-merge" after reviewing a worktree branch implemented by /wn-implement.
---

Merge the current worktree's branch into main and mark the item done. Run each step in sequence — stop and report if anything fails.

## Step 1: Identify the branch and item ID

```bash
git rev-parse --abbrev-ref HEAD
```

Branch names follow the pattern `[prefix]wn-<id>-<slug>` (e.g. `wn-44e8a3-saved-views` or `keith/wn-44e8a3-saved-views`). Extract the 6-character hex item ID from after `wn-`.

If the branch doesn't match this pattern, stop and ask the user to confirm the item ID manually before continuing.

## Step 2: Capture the main root

Get the main worktree root — strip the trailing `/.git` from the output of:
```bash
git rev-parse --git-common-dir
```

Use this as the `root` parameter for all `wn_*` MCP calls.

## Step 3: Sync main into the worktree branch

Before merging into main, bring the worktree branch up to date with main so any conflicts are resolved here rather than on main.

From within the worktree (current directory):
```bash
git fetch origin
git merge <main_branch>   # e.g. git merge main
```

If there are merge conflicts, resolve them, stage the fixes, and complete the merge (`git merge --continue`). Once the merge is done, report what was merged and any conflicts that were resolved.

## Step 4: Verify the worktree branch

Run `wn verify` to confirm the branch is still green after syncing with main. If it fails, stop and report — do not proceed with the merge into main.

## Step 5: Squash-merge into main

Combine all worktree commits into a single commit on main. Perform the squash merge from the main worktree:
```bash
git -C <main_root> merge --squash <branch>
```

Compose a single unified commit message that accurately summarizes the actual change. The wn item title is a useful starting point, but the implementation may have evolved during development — write a message that reflects what was actually done, not just what was originally planned.

Commit with this message:
```bash
git -C <main_root> commit -m "<unified message>"
```

If the merge or commit fails (e.g. conflict, nothing to commit), stop and report.

## Step 6: Verify main after merge

Run `wn verify` from the main worktree root as a sanity check:
```bash
wn verify   # run from <main_root>
```

If it fails, report the failure. Do not mark the item done until main is green.

## Step 7: Mark done

Call `wn_done` with the item ID and `root` from Step 2.

Report: item ID, branch merged, item marked done. The worktree directory remains and can be used for follow-up questions.
