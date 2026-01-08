# Skills
AI skills repository

## Copilot skills

- **building-backend** — Ensures backend tests are run reliably by building Docker Compose services and waiting for containers to be healthy before running tests. See `.copilot/skills/building-backend/SKILL.md` for details.

- **debugging-tests** — Helps debug test failures by ensuring containers are torn down and rebuilt when changes are detected in API or core projects. Verifies container stability before running tests. See `.copilot/skills/debugging-tests/SKILL.md` for details.

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