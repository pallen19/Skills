# Copilot Skill: building-backend ✅

## Purpose
This skill makes sure that when AI or contributors run tests for the backend, they do so reliably by building and starting Docker Compose services and waiting for container readiness. This avoids the common pitfall where tests are executed before services have picked up new code or are ready.

## Key rules
- Always run: `docker compose up --build -d` before running tests.
- Wait for containers to be healthy or at least running before running tests.
- If you change `api` or `cir`, rebuild containers so changes take effect.

## How to use
How to run tests if the repo does not include a helper script:

1. Build and start services with:

```
docker compose up --build -d
```

2. Wait for containers to be healthy or at least running (example loop):

```bash
# timeout in seconds
timeout=300
deadline=$((SECONDS + timeout))
services=$(docker compose ps --services)
for s in $services; do
  container=$(docker compose ps -q "$s")
  while [[ $SECONDS -lt $deadline ]]; do
    status=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$container" 2>/dev/null || true)
    [[ "$status" == "healthy" || "$status" == "running" ]] && break || sleep 2
  done
done
```

3. Run .NET tests (preferred):

```
dotnet test <solution.sln>
```

The script is optional — if present use `./scripts/run_backend_tests.sh --solution "<solution>"`; otherwise follow the steps above. You can also set `SOLUTION_NAME` environment variable to choose the solution file.

## Notes for Copilot/AI behavior
When the assistant is asked to run or verify tests, it should:
1. Run `docker compose up --build -d` in the repo root.
2. Wait for readiness using the repo helper or equivalent checks.
3. Run `make test` or `pytest`.

If the assistant detects changes to `api/` or `cir/`, it should re-run the `docker compose up --build -d` step.

## CI guidance
See `.github/workflows/backend-tests.yml` for a sample CI workflow.

---
