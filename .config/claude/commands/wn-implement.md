---
description: Implement the current wn work item using red/green TDD. Use when invoked as "/wn-implement [item-id]" inside a worktree that was already set up by `wn do`. The item is already claimed; this skill focuses purely on implementation, then marks the item review-ready when done.
argument-hint: [item-id]
---

Implement a `wn` work item in the current worktree. The item is already claimed and the worktree is already set up — focus entirely on implementation.

## Step 1: Load the work item

Call `wn_show` with the item ID from `$ARGUMENTS`. Show the user the item ID and description before continuing.

## Step 2: Implement with red/green TDD

**Red phase:**
1. Write new or updated tests that cover the expected behavior (happy paths and error cases).
2. Run `wn verify` and confirm the new tests fail as expected — not just compile errors, but actual test failures matching the intended behavior.
3. Do NOT modify implementation code during this phase.

**Green phase:**
1. Implement the feature or fix so the tests pass.
2. Run `wn verify` and confirm it passes completely.
3. Do NOT modify tests during this phase.

If discoveries during the green phase require changing the expected test behavior, undo implementation changes and restart from the red phase.

## Step 3: Commit

```
git add -A
git commit -m "<short summary line>

<paragraph describing what was implemented, key design decisions, and any notable edge cases handled>

wn: ITEM_ID"
```

Write the message based on what you actually built — don't just restate the work item title. Always include `wn: ITEM_ID` as the last line.

## Step 4: Mark review-ready

Call `wn_release` to clear the in-progress claim and mark the item review-ready.

Report to the user:
- What was implemented (brief summary)
- Which files were changed
- Any notable design decisions or edge cases
- Confirmation that `wn verify` passed and changes were committed

## Constraints
- Use `wn verify` for all build/test runs — do not call the underlying build tool directly.
- Do NOT push to remote.
- Do NOT update README or other docs unless a user-visible command was added, removed, or changed.
- Do NOT call `wn_done` — that happens later via `/wn-merge` after the user reviews.
