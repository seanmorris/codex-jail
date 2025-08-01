#!/usr/bin/env sh
# Exit on error (retain full environment from Dockerfile/env-file)
set -e

# Parse the first argument for dispatching
first_arg=${1:-}

# Auto-generate Jira CLI config when invoking codex or jira (or no args)
if [ -z "$first_arg" ] || [ "$first_arg" = "codex" ] || [ "$first_arg" = "jira" ]; then
	if [ ! -f "$HOME/.config/.jira/.config.yml" ] && [ -n "${JIRA_CLOUD_ENDPOINT:-}" ] && [ -n "${JIRA_CLOUD_USER_EMAIL:-}" ] && [ -n "${JIRA_CLOUD_API_TOKEN:-}" ]; then
	  mkdir -p "$HOME/.config/.jira"
	  cat > "$HOME/.config/.jira/.config.yml" <<-EOF
installation: cloud
server:    "${JIRA_CLOUD_ENDPOINT}"
login:     "${JIRA_CLOUD_USER_EMAIL}"
auth_type: basic
password:  "${JIRA_CLOUD_API_TOKEN}"
EOF
	fi
	fi


# Dispatch to the appropriate binary
if [ -z "$first_arg" ]; then
  exec codex
elif [ "$first_arg" = "codex" ]; then
  shift
  exec codex "$@"
elif [ "$first_arg" = "jira" ]; then
  shift
  exec jira "$@"
else
  exec "$@"
fi
