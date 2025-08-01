<!--
  Quick reference for Jira CLI commands available to Codex users.
  Requires jira-cli installed and configured (see README.md).
-->
# Jira CLI Quick Reference

> A quick reference for the most common jira-cli commands you can run from within the Codex sandbox.

## Setup

Ensure `jira-cli` is installed and credentials are configured (via `.env` or `jira init`):
```bash
# install jira-cli
go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest

# configure credentials (example)
JIRA_CLOUD_ENDPOINT=https://your-domain.atlassian.net
JIRA_CLOUD_USER_EMAIL=you@example.com
JIRA_CLOUD_API_TOKEN=your-api-token
```

## Projects

```bash
# List all projects
jira project list

# View details of a single project
jira project view YOUR_PROJECT_KEY
```

## Issues

```bash
# List issues in a project (interactive view)
jira issue list --project YOUR_PROJECT_KEY

# List issues in plain text without headers
jira issue list --project YOUR_PROJECT_KEY --plain --no-headers

# View detailed information about a specific issue
jira issue view YOUR_PROJECT_KEY-123
```

## Transitions

```bash
# Transition an issue to a new status (e.g., In Progress, Done)
jira issue move ISSUE-KEY "In Progress"

# Transition and add a comment in one command
jira issue move ISSUE-KEY Done --comment "Completed work"
```

## Comments

```bash
# Add a single-line comment to an issue
jira issue comment add ISSUE-KEY "Looks good to me"

# Add a multi-line comment to an issue
jira issue comment add ISSUE-KEY $'Line 1\n\nLine 2'
```

## Assignments & Workflow

```bash
# Assign an issue to a specific user (email or display name)
jira issue assign ISSUE-KEY user@example.com

# Unassign an issue
jira issue assign ISSUE-KEY x
```

## Issue Management

```bash
# Create a new issue in a project
jira issue create --project YOUR_PROJECT_KEY --type Task --summary "My new task"

# Clone an existing issue
jira issue clone ISSUE-KEY

# Delete an issue (use with care!)
jira issue delete ISSUE-KEY
```

## Help & Miscellaneous

```bash
# Show help for any Jira command or subcommand
jira --help
jira issue --help
jira project --help

# Open an issue in your web browser
jira open ISSUE-KEY
```
