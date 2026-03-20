---
description: Claim a `wn` work item and implement it in an isolated git worktree subagent. Use when the user invokes "/wn-worktree", asks to work on a wn item in a worktree, or wants to implement an agentic wn item in isolation.
argument-hint: [item-id]
---

Claim a `wn` work item and implement it in an isolated git worktree using a subagent. The parent conversation handles the wn lifecycle (claim, worktree setup, branch note, release); the subagent focuses purely on implementation and commits its own changes.

## Step 1: Claim the work item

**If `$ARGUMENTS` is a non-empty item ID:** call `wn_claim` with that ID (use `for: "2h"`, `by: "claude-code"`).

**If no argument was given:**
1. Call `wn_show` (no id) to fetch the current work item.
2. If the current item exists and is in **undone** state (not done, not review-ready, no active claim), claim it with `wn_claim` (use `for: "2h"`, `by: "claude-code"`).
3. Otherwise (current item is done, review-ready, in-progress, or there is no current item), call `wn_next` with `claim_for: "2h"` and `claim_by: "claude-code"` to atomically claim the next available item.
4. If the queue is empty, stop and tell the user there are no available items.

Show the user the item ID and description before continuing.

## Step 2: Set up the worktree

Derive a short readable slug (2–5 words) that captures the essence of the work item — don't just truncate the first line mechanically. Lowercase, words joined with `-`, max ~40 chars. Example: "Add saved views to 'wn list': named filter+sort+group combos in settings" → `saved-views`.

If the item already has a `"branch"` note (from a prior run), skip slug generation and pass no `--branch` flag — `wn worktree` will reuse the existing branch automatically.

Run `wn worktree` to claim, create the branch, set up the worktree, and record the branch note all in one step:
```bash
WORKTREE=$(wn worktree <id> --branch <slug>)
```
(`wn worktree` prints the worktree path to stdout and human-readable info to stderr. The full branch name will be `[prefix]wn-<id>-<slug>`, respecting any `worktree.branch_prefix` from settings.)

For a resume (item already has a branch note):
```bash
WORKTREE=$(wn worktree <id>)
```

## Step 3: Implement in the worktree

Launch a **general-purpose Agent** (no `isolation`) with the following prompt (fill in ITEM_ID, DESCRIPTION, and WORKTREE_PATH):

```
You are implementing work item ITEM_ID for the `wn` project (a Go CLI/TUI work item tracker).

Work item description:
DESCRIPTION

## Working directory

Your work is in an isolated git worktree at: WORKTREE_PATH

Run this as your very first Bash command to set your working directory:
  cd WORKTREE_PATH

All subsequent Bash commands must either use absolute paths under WORKTREE_PATH or be run with `cd WORKTREE_PATH && <command>`.

## Your task

Implement the change described above. Use red/green test-driven development:

**Red phase:**
1. Write new or modified tests that cover the expected behavior (happy paths and error cases).
2. Run `make test` and confirm the new tests fail as expected (not just compile errors — actual test failures matching the intended behavior).
3. Do NOT modify implementation code during this phase.

**Green phase:**
1. Implement the feature or fix so the tests pass.
2. Run `make all` (runs format check, lint, coverage, and build) and confirm it passes.
3. Do NOT modify tests during this phase.

If discoveries during the green phase require changing the expected test behavior, revert implementation changes and restart from the red phase.

## Committing

When `make all` passes, commit all your changes with a descriptive message:
```
git add -A
git commit -m "<short summary line>

<paragraph describing what was implemented, key design decisions, and any notable edge cases handled>

wn: ITEM_ID"
```
Write the message based on what you actually built — don't just restate the work item title. Always include `wn: ITEM_ID` as the last line so commits are traceable back to their work item.

## Constraints
- Use `make test` / `make all` (not `go test` or `go build` directly) — the Makefile sets required env vars and outputs the binary to `./build/wn`.
- Do NOT call any `wn_*` MCP tools — the parent conversation manages the wn lifecycle.
- Do NOT push to remote.
- Do NOT update the README unless a command was added, removed, or changed.

## When done
Report:
- What was implemented (a brief summary)
- Which files were changed
- Any notable design decisions or edge cases handled
- Confirmation that `make all` passed and changes were committed
```

## Step 4: After the agent returns

1. Call `wn_release` to clear the in-progress claim and mark the item review-ready.
2. Report to the user:
   - Item ID and description
   - Branch and worktree path where changes live
   - Summary of what the agent implemented
   - Next steps: review the branch (`git diff main..<branchname>`), merge it, then run `wn done <id>`

## Error handling

- If the agent makes no changes and does not commit: do NOT call `wn_release` (item should stay in-progress, not review-ready). Remove the empty worktree (`git worktree remove <path>`), then report to the user what happened and ask how they'd like to proceed — retry, skip, or mark done manually. The item will remain claimed until its 2h window expires.
- If the agent fails mid-way but committed partial work: call `wn_release` to unblock the item and report the partial state to the user so they can review the branch and decide next steps.
