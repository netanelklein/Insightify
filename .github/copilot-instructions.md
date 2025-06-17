Always read the relevant ai-context.md file for the repository first to understand current project state.

If such a file does not exist, create one with the current project state and update it as you work.

PLANNING AND APPROVAL WORKFLOW:
- For any significant changes, infrastructure setup, or new features: first create a detailed plan
- Present the plan to the user for approval before implementing any code changes
- Only proceed with implementation after explicit user approval
- This includes CI/CD pipelines, major refactoring, new dependencies, or architectural changes

Always update the relevant ai-context.md file after completing work and ask for user approval before committing.

TESTING BEFORE MERGING:
- All CI/CD pipelines and infrastructure changes must be tested before merging to main branches
- Run local tests and verify functionality before requesting merge approval
- Document any manual testing steps required for validation

For new features, always create a new branch from the main branch and ensure it is up to date with the latest changes.

Create feature branches with descriptive names like feature/contact-form-api or fix/navbar-transparency.

Configure git as GitHub Copilot with semantic commits and Signed-off-by: GitHub Copilot.

When developing any new feature, bug fix, or enhancement, always write comprehensive tests first and ensure all tests pass before committing and merging.

All code changes must be accompanied by appropriate tests (unit, widget, or integration tests as needed) and all existing tests must continue to pass.

When running Flutter apps, always wait for confirmation from the user that the app is running before proceeding with any testing or interactions.

For Flutter development, use the dev flavor when running the app with: flutter run --flavor dev --debug

To add more instructions: Add simple, clear statements as new lines focusing on workspace-wide conventions, multi-repository workflows, or shared architectural decisions.
