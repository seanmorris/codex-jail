 # Sandbox Reminders

- You are running inside the Codex sandbox container.
- Project files are mounted read-write under `/app`.
- If a needed CLI tool isn’t installed, you can invoke it via Docker (or rebuild the container):
  ```bash
  docker run --rm -v "$(pwd)":/app -w /app debian:stable-slim <tool> [args]
  ```
- Commonly available tools in this sandbox:
  - ripgrep (`rg`)
  - fd (`fd`)
  - bat (`bat`)
  - fzf (`fzf`)
  - jq (`jq`)
  - pre-commit
  - jira-cli (`jira`) – enables Codex to manage Jira issues (list, view, comment, transition)
- To add/install permanently, edit `codex.Dockerfile` and re-run `./build`.
- To launch a shell inside the sandbox:
  ```bash
  ./start bash
  ```

Happy hacking!