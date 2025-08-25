# Networking and Port Exposure in the Codex Sandbox

This document describes how the Codex sandbox handles nested Docker networking and how agents can expose services (web servers, APIs, etc.) running inside the sandbox back to the client machine.

## Background

The Codex CLI runs inside a Docker container (`codex`) which itself uses a Docker-in-Docker (DinD) daemon (`dind-daemon`) to launch user commands in isolated nested containers. By default, nested containers are isolated from the host network, so their published ports are not directly reachable on the client machine.

## Port Range Strategy

We define a **configurable port range** that the DinD daemon listens on, and map that same range from the sandbox back to the host. Agents (and end users) can then bind nested containers to any port in this range and reach them on `localhost:<port>` on the host.

### Configuration Variable: `DIND_PORT_RANGE`

Add or override this entry in your `.env` (see `.env.example`):

```dotenv
# Range of host ports to forward to nested Docker (dind-daemon) so that
# sandboxed containers can expose web servers
DIND_PORT_RANGE=8000-9000
```

  - The default range is **8000-9000**, but you can expand or shift it if needed.

### Compose Mapping in `docker-compose.yml`

The `dind-daemon` service maps the `DIND_PORT_RANGE` from host to guest:

```yaml
services:
  dind-daemon:
    image: docker:24-dind
    privileged: true
    ports:
      # Allow nested Docker containers to publish web ports through the sandbox
      - "${DIND_PORT_RANGE}:${DIND_PORT_RANGE}"
    environment:
      DOCKER_TLS_CERTDIR: /certs
    volumes:
      - dind-certs:/certs/client
      - dind-data:/var/lib/docker
```

This mapping is applied at container startup, so nested `docker run -p` calls inside the sandbox will bind through to the host.

## Exposing a Service Example

Inside the Codex CLI container (`codex`), you can start any service in a nested container, for example:

```bash
# Run a simple HTTP server on port 8080 in a nested container
docker run -d --rm -p 8080:80 nginx:stable-alpine

# On the host, open or curl the bound port:
curl http://localhost:8080
```

As long as `8080` is within your `DIND_PORT_RANGE`, the request will reach the nested container's port 80.

## Security Considerations

- Only the specified range of ports is forwarded; other ports remain isolated.
- Avoid exposing sensitive services or management endpoints on these ports.
- If you need multiple port ranges (e.g., 9001-9100), adjust `DIND_PORT_RANGE` accordingly, but be mindful of port conflicts on the host.

## Troubleshooting

- **Unable to reach service**: Ensure your nested container is actually listening on the inside port, and you specified `-p HOST:CONTAINER` inside the sandbox.
- **Port conflicts**: If the host port is already in use, pick another port within the configured range or adjust the range.
- **Range not applied**: Verify that `DIND_PORT_RANGE` is set in your `.env` and that you rebuilt/restarted the sandbox (`./build && ./start`).
- **Testing services inside the sandbox**: To verify a nested container's service before testing from the host, use `docker exec <container> curl http://localhost:<port>` for HTTP(s) and `docker exec <container> <other-tool>` (e.g. `telnet`, `redis-cli`, etc.) for other protocols.


---

_Document generated to help future Codex agents and maintainers understand the sandbox networking setup._
