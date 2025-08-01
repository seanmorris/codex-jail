# Codex Jail

Ensures Codex can never run a command that could destroy your FS.

## Prerequisites

- Docker
- Docker Compose
- pre-commit (optional, for local linting and Git hooks; pre-installed inside the Codex container)

## Setup

1. Copy the example environment file and set your OpenAI API key:

   ```bash
   cp .env.example .env
   ```

2. Build the Codex CLI Docker image:

   ```bash
   ./build
   ```

3. Run the Codex CLI:

   ```bash
   ./start
   ```

- 4. (Optional) Install Git hooks for quality checks:

   ```bash
   pre-commit install
   ```

## Environment Variables

The `.env.example` file lists required and optional environment variables:

- `OPENAI_API_KEY` (required): Your OpenAI API key.
- `OPENAI_ORGANIZATION` (optional): Your OpenAI organization ID.
- `OPENAI_API_BASE` (optional): Custom API base URL (e.g., for Azure deployments).
- `OPENAI_API_TYPE` (optional): API type when using Azure.
- `OPENAI_API_VERSION` (optional): API version when using Azure.

## Troubleshooting

- If you encounter TLS errors connecting to the Docker daemon, ensure the `dind-daemon` container is healthy and certificates are properly generated.
- For daemon logs:
  ```bash
  docker logs dind-daemon
  ```
- If build or start scripts fail, verify your environment variables and installed Docker/Compose versions.
- For help with the Codex CLI:
  ```bash
  ./start --help
  ```

## Development

This project includes pre-commit hooks and a CI workflow for linting and validation.

> **Note:** pre-commit is bundled in the Codex CLI container—no need to install it on your host to run linting inside the sandbox.

1. Install pre-commit hooks:
   ```bash
   pre-commit install
   pre-commit run --all-files
   ```
2. CI actions are defined in `.github/workflows/ci.yml`.

## Jirafs Container

### Authentication
Jirafs requires JIRA credentials. You can configure them via environment variables (e.g., in your `.env` file):

```
JIRA_URL=https://your-domain.atlassian.net
JIRA_USER=you@example.com
JIRA_API_TOKEN=your_api_token
```

A lightweight container for running [jirafs] (filesystem interface to Atlassian JIRA).

### Standalone build & run
```bash
# Build the image
docker build -f jirafs.Dockerfile -t jirafs .

# Run jirafs interactively (mount current directory as /data)
docker run --rm -it -v "$(pwd)":/data jirafs --help
```

### Automatic FUSE mount via Compose
```bash
# Start jirafs and codex services; JIRA issues will be mounted under '/jira' in the Codex container
WORK_DIR=$(pwd) docker compose up -d jirafs codex
```

## Configuration

The following environment variables can be set in your `.env` file (copied from `.env.example`):

- `OPENAI_API_KEY` (required): Your OpenAI API key.
- `OPENAI_ORGANIZATION` (optional): Your OpenAI organization ID.
- `OPENAI_API_BASE` (optional): The base URL for the OpenAI API.
- `OPENAI_API_TYPE` (optional): Set to `azure` if using Azure OpenAI Service.
- `OPENAI_API_VERSION` (optional): The API version to use (e.g., `2023-03-15-preview`).

### JIRA integration (for Jirafs)
- `JIRA_URL` (required): Base URL for your JIRA instance (e.g., https://your-domain.atlassian.net).
- `JIRA_USER` (required): Your JIRA username or email address.
- `JIRA_API_TOKEN` (required): API token for authenticating to JIRA.

## Troubleshooting

- **Build failures**: Ensure Docker and Docker Compose are installed and running.
- **Permissions issues**: If you encounter permission errors, check that your user has access to Docker and the working directory.
- **Environment variables**: Make sure you have copied `.env.example` to `.env` and filled in your OpenAI credentials.
- **Docker daemon timeout**: If the Codex CLI can't connect to Docker, wait for the daemon to start or adjust the healthcheck retries in `docker-compose.yml`.

## Files

- `codex.Dockerfile` — Dockerfile for building the Codex CLI container.
- `jirafs.Dockerfile` — Dockerfile for building the Jirafs CLI container.
- `docker-compose.yml` — Docker Compose configuration.
- `build` — Script to build the Docker image.
- `start` — Script to run the Codex CLI in a container.
- `.env.example` — Example environment variables file.
- `.gitignore` — Git ignore rules.
- `.editorconfig` — EditorConfig for consistent coding styles.
- `.pre-commit-config.yaml` — Pre-commit hook configuration (shellcheck, hadolint, markdownlint).
- `.github/workflows/ci.yml` — CI workflow for linting and Docker Compose validation.
