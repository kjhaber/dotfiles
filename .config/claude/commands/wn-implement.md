---
description: Claim a wn work item (if not already claimed), set up a working branch, and implement it inline using red/green TDD. Use when the user invokes "/wn-implement [item-id]", asks to work on a wn item, or wants to implement a wn item interactively.
argument-hint: [item-id]
---

Claim a `wn` work item and implement it inline. Handles the full lifecycle: claim, branch setup, TDD implementation, commit, and release.

For parallel or agentic dispatch (multiple items, tmux sessions), use `wn do` or `wn launch` instead.

## Step 1: Claim the work item

**If `$ARGUMENTS` is a non-empty item ID:** call `wn_claim` with that ID (`for: "2h"`, `by: "claude-code"`).

**If no argument was given:**
1. Call `wn_show` (no id) to fetch the current work item.
2. If the current item exists and is **undone** (not done, not review-ready, no active claim), claim it with `wn_claim` (`for: "2h"`, `by: "claude-code"`).
3. Otherwise, call `wn_next` with `claim_for: "2h"` and `claim_by: "claude-code"` to atomically claim the next available item.
4. If the queue is empty, stop and tell the user there are no available items.

Show the user the item ID and description before continuing.

## Step 2: Set up the working branch

Check the current branch:
```bash
git rev-parse --abbrev-ref HEAD
```

**Case A — item already has a `wn:branch` note:** use that branch. If not already on it, check it out (`git checkout <branch>`).

**Case B — on `main` or `master` with no `wn:branch` note:**
1. Derive a short readable slug (2–5 words) from the description. Lowercase, hyphen-separated, max ~35 chars. Example: "Add saved views to 'wn list'" → `saved-views`.
2. Create and check out a new branch: `git checkout -b wn-<id>-<slug>`
3. Record it explicitly: `wn note add wn:branch <id> -m "wn-<id>-<slug>"`

**Case C — already on a feature branch with no `wn:branch` note:** record it via auto-detect: `wn note add wn:branch <id>` (omit `-m` — reads current branch from git).

## Step 3: Implement with red/green TDD

**Red phase:**
1. Write new or updated tests that cover the expected behavior (happy paths and error cases).
2. Run `wn verify` and confirm the new tests fail as expected — not just compile errors, but actual test failures matching the intended behavior.
3. Do NOT modify implementation code during this phase.

**Green phase:**
1. Implement the feature or fix so the tests pass.
2. Run `wn verify` and confirm it passes completely.
3. Do NOT modify tests during this phase.

If discoveries during the green phase require changing the expected test behavior, undo implementation changes and restart from the red phase.

## Step 4: Commit

```
git add -A
git commit -m "<short summary line>

<paragraph describing what was implemented, key design decisions, and any notable edge cases handled>"
```

Write the message based on what you actually built — don't just restate the work item title.

## Step 5: Mark review-ready

Call `wn_release` to clear the in-progress claim and mark the item review-ready.

Report to the user:
- What was implemented (brief summary)
- Branch name where changes live
- Which files were changed
- Any notable design decisions or edge cases
- Confirmation that `wn verify` passed and changes were committed

## Constraints
- Use `wn verify` for all build/test runs — do not call the underlying build tool directly.
- Do NOT push to remote.
- Do NOT update README or other docs unless a user-visible command was added, removed, or changed.
- Do NOT call `wn_done` — that happens later via `/wn-merge` after the user reviews.
