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

## Jira CLI Integration

Codex can manage Jira issues directly using the upstream [jira-cli](https://github.com/ankitpokhrel/jira-cli). To enable the agent to run Jira commands from within the CLI container:

1. **Install `jira-cli`**
   Rebuild the container or install locally into your environment:
   ```bash
   go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest
   ```

2. **Configure credentials**
   Copy the Jira variables from `.env.example` into your `.env` so they are loaded into the Codex session, or run `jira init` inside the container to generate a `$HOME/.config/.jira/config.yml`. For example:
```bash
JIRA_CLOUD_ENDPOINT=https://your-domain.atlassian.net
JIRA_CLOUD_USER_EMAIL=you@example.com
JIRA_CLOUD_PROJECT=YOUR_PROJECT_KEY
JIRA_CLOUD_BOARD=YOUR_BOARD_NAME
JIRA_API_TOKEN=your-api-token
```
   For more configuration options, see the upstream docs:
   https://github.com/ankitpokhrel/jira-cli#configuration

3. **Use Jira commands**
   Once installed and configured, the agent or you can invoke Jira commands directly:
   ```bash
   jira issue list --project YOUR_PROJECT_KEY
   jira issue view YOUR_PROJECT_KEY-123
   ```

## Configuration

The following environment variables can be set in your `.env` file (copied from `.env.example`):

- `OPENAI_API_KEY` (required): Your OpenAI API key.
- `OPENAI_ORGANIZATION` (optional): Your OpenAI organization ID.
- `OPENAI_API_BASE` (optional): The base URL for the OpenAI API.
- `OPENAI_API_TYPE` (optional): Set to `azure` if using Azure OpenAI Service.
- `OPENAI_API_VERSION` (optional): The API version to use (e.g., `2023-03-15-preview`).


## Troubleshooting

- **Build failures**: Ensure Docker and Docker Compose are installed and running.
- **Permissions issues**: If you encounter permission errors, check that your user has access to Docker and the working directory.
- **Environment variables**: Make sure you have copied `.env.example` to `.env` and filled in your OpenAI credentials.
- **Docker daemon timeout**: If the Codex CLI can't connect to Docker, wait for the daemon to start or adjust the healthcheck retries in `docker-compose.yml`.

## Files

- `codex.Dockerfile` — Dockerfile for building the Codex CLI container.
- `docker-compose.yml` — Docker Compose configuration.
- `build` — Script to build the Docker image.
- `start` — Script to run the Codex CLI in a container.
- `.env.example` — Example environment variables file.
- `.gitignore` — Git ignore rules.
- `.editorconfig` — EditorConfig for consistent coding styles.
- `.pre-commit-config.yaml` — Pre-commit hook configuration (shellcheck, hadolint, markdownlint).
- `.github/workflows/ci.yml` — CI workflow for linting and Docker Compose validation.
