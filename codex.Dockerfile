FROM debian:stable-20250520-slim

ARG NODE_MAJOR=22
ARG CODEX_VERSION=0.1.2505172129
# ARG CODEX_VERSION=0.1.2505291658
# ARG CODEX_VERSION=latest
ARG GO_VERSION=1.24.2
ARG PRECOMMIT_VERSION=4.2.0
ENV DEBIAN_FRONTEND=noninteractive \
    GOPATH=/root/go \
    PATH=/root/go/bin:$PATH

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# Install system and language dependencies, Docker CLI, and Codex CLI
# hadolint ignore=SC2086,DL3008
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
      git \
      curl \
      gnupg \
      ca-certificates; \
    install -m0755 -d /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc; \
    chmod a+r /etc/apt/keyrings/docker.asc; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
      | tee /etc/apt/sources.list.d/docker.list > /dev/null; \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin; \
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_MAJOR}.x" | bash -; \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        nodejs \
        ripgrep \
        fd-find \
        bat \
        fzf \
        jq \
        python3 \
        python3-pip \
        less \
        file \
        tar \
        php \
        php-cli \
        composer \
        shellcheck \
        ruby-full \
        bundler \
        perl \
        cpanminus; \
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz; \
    ln -s /usr/local/go/bin/go /usr/local/bin/go; \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt; \
    ln -s /usr/bin/fdfind /usr/local/bin/fd; \
    ln -s /usr/bin/batcat /usr/local/bin/bat; \
    pip3 install --no-cache-dir pre-commit==${PRECOMMIT_VERSION} --break-system-packages; \
    npm install -g @openai/codex@${CODEX_VERSION}; \
    go install golang.org/x/tools/gopls@latest; \
    go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest; \
    # Install hadolint binary for the hadolint pre-commit hook
    curl -fsSL https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint; \
    chmod +x /usr/local/bin/hadolint; \
    git config --global safe.directory '*'; \
    rm -rf /var/lib/apt/lists/*

# Add Go workspace bin to PATH for login shells
RUN printf "export PATH=/root/go/bin:\$PATH\n" > /etc/profile.d/gopath.sh

WORKDIR /app

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
