FROM debian:stable-20250520-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update; \
	apt install -y git curl; \
	install -m 0755 -d /etc/apt/keyrings; \
	curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc; \
	chmod a+r /etc/apt/keyrings/docker.asc; \
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
		$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
		tee /etc/apt/sources.list.d/docker.list > /dev/null; \
    apt-get update; \
	apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; \
	curl -sL https://deb.nodesource.com/setup_22.x | bash -; \
	apt update; \
	apt install -y nodejs; \
	npm install -g @openai/codex; \
	git config --global safe.directory '*';

ENTRYPOINT ["codex"]
