FROM debian:stable-20250520-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update; \
    apt install -y curl;

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -

RUN apt update; \
    apt install -y nodejs;

RUN npm install -g @openai/codex

ENTRYPOINT ["codex"]