Begin all responses with a 🔹 emoji.

Do not append `; echo "exit: $?"` or similar to commands — Claude Code already reports exit codes.

## Prefer Red/Green Test-Driven Development when making code changes.
Code projects should have some kind of "compile, lint, and run all tests" command, e.g. "make all" or "npm test all".  If one isn't clear from the project's prompt setup or README, please ask.  Prefer the command from project prompts such as CLAUDE.md rather than README.

Whenever possible, use a red/green test-driven development approach when implementing features or fixing bugs
1. When making any change, consider how the requested feature or fix will be verified.
  - Consider both happy paths and error cases/failure modes.
  - Consider tests beyond unit tests.  Are there integration tests or end-to-end tests that should also be updated?  Some projects won't have integration or end-to-end tests, but for projects that have them these should not be ignored.
2. Create new tests that verify the intended behavior.
  - This is the start of the "red phase": add new tests that intentionally do not pass, which are usually displayed to developers as red error messages.
  - Prefer test frameworks already in the project, but offer to add new testing frameworks if necessary.
  - Include both happy-path and error cases.
  - Use the "compile/lint/run all tests" command specified for the project, not just unit tests only.
3. Run the tests and confirm that they fail as expected (since the system does not implement the requested change yet).
  - Note that not just any failure from the build command meets this standard, e.g. compiler errors. Error results should match the failures expected from step 1.
  - If the tests don't fail as expected, inspect the tests and confirm that they are correct, applying any fixes that make sense.
  - If the tests appear to have been broken before the task started, notify the user and offer to fix the tests if possible before continuing.
4. Implement the feature or bugfix.
  - This is the start of the "green phase": update code so the tests now pass, which are usually displayed to developers as a green success message.
  - It is important to avoid updating the tests during the green phase! If test updates are needed, it may be best to rethink the change and start the task over!
5. Run the tests and confirm they all pass.  In theory this will mean the change really fulfills the request.
6. Once done, make sure any relevant documentation like README or help text is updated to account for the change.

