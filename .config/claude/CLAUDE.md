Begin all responses with a ⚪ emoji.

Whenever possible, use a red/green test-driven development approach when implementing features or fixing bugs
* When making any change, consider how the requested feature or fix will be verified.
* Create new tests that verify the intended behavior. Prefer test frameworks already in the project, but offer to add new testing frameworks if necessary. Include both happy-path and error cases.
* Run the tests and confirm that they fail as expected (since the system does not implement the requested change yet).
  - If the tests don't fail as expected, inspect the tests and confirm that they are correct, applying any fixes that make sense.
  - If the tests appear to have been broken before the task started, notify the user and offer to fix the tests if possible before proceeding.
* Implement the feature or bugfix.
  - It is important to avoid updating the tests at this point. If test updates are needed, it may be best to rethink the change and start the task over!
* Run the tests and confirm they all pass.
* Once done, make sure any relevant documentation like README or help text is updated to account for the change.
