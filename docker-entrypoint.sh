#!/usr/bin/env sh
# Exit on error (retain full environment from Dockerfile/env-file)
set -eux

# Parse the first argument for dispatching
first_arg=${1:-}

# Normalize Jira token env var and auto-generate config when invoking codex or jira (or no args)
if [ -z "$first_arg" ] || [ "$first_arg" = "codex" ] || [ "$first_arg" = "jira" ]; then
{
    if [ ! -f "$HOME/.config/.jira/.config.yml" ] && \
        [ -n "${JIRA_API_TOKEN:-}" ] && \
        [ -n "${JIRA_CLOUD_PROJECT:-}" ] && \
        [ -n "${JIRA_CLOUD_BOARD:-}" ] && \
        [ -n "${JIRA_CLOUD_ENDPOINT:-}" ] && \
        [ -n "${JIRA_CLOUD_USER_EMAIL:-}" ] ; then
    {
		jira init --help
		jira init --installation cloud \
			--project "${JIRA_CLOUD_PROJECT}" \
			--board "${JIRA_CLOUD_BOARD}" \
			--server "${JIRA_CLOUD_ENDPOINT}" \
			--login "${JIRA_CLOUD_USER_EMAIL}"
	}
	fi
}
fi

# Dispatch to the appropriate binary
if [ -z "$first_arg" ]; then
{
  exec codex
}
elif [ "$first_arg" = "codex" ]; then
{
  shift
  exec codex "$@"
}
elif [ "$first_arg" = "jira" ]; then
{
  shift
  exec jira "$@"
}
else
{
  exec "$@"
}
fi
