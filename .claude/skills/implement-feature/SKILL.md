---
name: implement-feature
description: Implement a feature from GitHub issue
disable-model-invocation: true
---

Analyze and fix the GitHub issue: $ARGUMENTS.

1. Use `gh issue view` to get the issue details.
2. Branch out to a new feature branch from main. Follow the convention feat/name-of-the-feature
2. Understand the problem, and what needs to be implemented described in the issue.
3. Search the codebase for relevant files.
4. Create a relevant test to match the specification
5. Implement the necessary changes to implement the issue.
6. Write and run tests to verify the fix, if it fails, fix until passes.
7. Ensure code passes linting.
8. Create a descriptive commit message. Commit without co-signing
9. Push and create a PR. PR message should have a Github convention to auto close the issue by adding #123 number of the issue
