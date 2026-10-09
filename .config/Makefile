.PHONY: all lint test

all: lint test

# Shell scripts that have tests (add more as they get covered)
TESTED_SCRIPTS := bin/agent-capture bin/agent-restore bin/lib/agent-common.sh bin/clean-clipboard

lint:
	shellcheck -x -P SCRIPTDIR $(TESTED_SCRIPTS)

test:
	bats tests/bin
