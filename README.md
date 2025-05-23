# Codex Jail

Ensures Codex can never run a command that could destroy your FS.

## Prerequisites

- Docker
- Docker Compose

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

## Files

- `codex.Dockerfile` — Dockerfile for building the Codex CLI container.
- `docker-compose.yml` — Docker Compose configuration.
- `build` — Script to build the Docker image.
- `start` — Script to run the Codex CLI in a container.
- `.env.example` — Example environment variables file.
- `.gitignore` — Git ignore rules.
- `.dockerignore` — Docker ignore rules.
