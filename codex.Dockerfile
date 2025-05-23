FROM debian:stable-20250520-slim

ARG NODE_MAJOR=22
ARG CODEX_VERSION=latest
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install system and language dependencies, Docker CLI, and Codex CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        curl \
        gnupg \
    && install -m0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg \
        -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
        https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
        | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && \
    apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get update && \
    apt-get install -y --no-install-recommends nodejs \
    && npm install -g @openai/codex@${CODEX_VERSION} \
    && git config --global safe.directory '*' \
    && apt-get purge -y --auto-remove curl gnupg \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and working directory
RUN groupadd --gid ${GROUP_ID} codex && \
    useradd -m --uid ${USER_ID} --gid ${GROUP_ID} codex && \
    mkdir -p /app && chown codex:codex /app

USER codex
WORKDIR /app

ENTRYPOINT ["codex"]
