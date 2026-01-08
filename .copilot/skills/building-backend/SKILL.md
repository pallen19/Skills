---
name: building-backend
description: Ensure backend tests run with proper Docker Compose build and container readiness. Use this when asked to run backend tests or build the backend.
---

To run backend tests reliably, follow this process:

1. Run `docker compose up --build -d` to build and start all services
2. Wait for all containers to be healthy or running before proceeding:
   ```bash
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
3. Run tests using the preferred test runner:
   - Prefer `dotnet test <solution.sln>` (discover via `--solution`, `SOLUTION_NAME` env, or first `*.sln`)
   - Fall back to `make test` if dotnet is unavailable
   - Fall back to `pytest` as last resort
4. If changes were made to `api/` or `cir/`, always rebuild containers first

If the repository includes `scripts/run_backend_tests.sh`, you may use it but must still ensure containers are rebuilt when `api/` or `cir/` change.
