# Skills
AI skills repository

## Copilot skills

- **building-backend** — Ensures backend tests are run reliably by building Docker Compose services and waiting for containers to be healthy before running tests. See `docs/BUILDING_BACKEND.md` and `.copilot/skills/building-backend.json` for details and usage.

### Quick start

follow these steps directly:

```bash
# build/start
docker compose up --build -d
# wait for containers (see docs for example loop)
# run tests (prefer .NET)
dotnet test <solution.sln>
```

The skill prefers `dotnet test` (discover via `--solution`, `SOLUTION_NAME` env var, or first `*.sln`)