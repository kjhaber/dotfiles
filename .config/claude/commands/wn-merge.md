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

## Step 3: Verify

Run `wn verify` to confirm the branch is still green. If it fails, stop and report — do not merge.

## Step 4: Merge into main

```bash
git -C <main_root> merge <branch>
```

If the merge fails (e.g. conflict with another worktree's changes merged first), stop and report.

## Step 5: Mark done

Call `wn_done` with the item ID and `root` from Step 2.

Report: item ID, branch merged, item marked done. The worktree directory remains and can be used for follow-up questions.
