#!/bin/bash
# wn-git-guard.sh
# PreToolUse hook: blocks destructive git operations that escape the local
# environment or irreversibly destroy work. Merging (including to main),
# checkout, and branch navigation are intentionally allowed.

input=$(cat)

# Extract the bash command from the tool input JSON
if command -v jq >/dev/null 2>&1; then
    git_cmd=$(echo "$input" | jq -r '.tool_input.command // ""')
else
    git_cmd=$(echo "$input" | python3 -c \
        "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" \
        2>/dev/null || echo "")
fi

# If we couldn't parse the input, fail open
[ -z "$git_cmd" ] && exit 0

block() {
    echo "Blocked by wn-git-guard: $1" >&2
    exit 2
}

# Block git push (any form — sends to remote without review)
if echo "$git_cmd" | grep -qE '(^|[;&|[:space:]])git[[:space:]]+push\b'; then
    block "'git push' is not permitted in agent sessions — push manually after review."
fi

# Block git branch -D / --force (irreversible branch destruction)
if echo "$git_cmd" | grep -qE '(^|[;&|[:space:]])git[[:space:]]+branch[[:space:]].+(-D\b|--force\b|-f[[:space:]])'; then
    block "'git branch -D/--force' is not permitted in agent sessions."
fi

# Block git reset --hard (discards uncommitted work irreversibly)
if echo "$git_cmd" | grep -qE '(^|[;&|[:space:]])git[[:space:]]+reset[[:space:]]+.*--hard\b'; then
    block "'git reset --hard' is not permitted in agent sessions."
fi

exit 0
