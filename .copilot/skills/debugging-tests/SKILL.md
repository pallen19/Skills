---
name: debugging-tests
description: Debug test failures by ensuring containers are torn down and rebuilt when changes are detected. Use this when tests are failing, when debugging test issues, or when tests worked before but now fail.
---

To debug failing tests, follow this process to ensure a clean Docker environment:

1. Check for changes in `api/`, `cir/`, `src/`, or `core/` directories:
   ```bash
   git status --porcelain api/ cir/ src/ core/
   ```

2. If ANY changes are detected, tear down existing containers first:
   ```bash
   docker compose down
   ```

3. Rebuild and start fresh containers:
   ```bash
   docker compose up --build -d
   ```

4. Wait for all containers to be healthy or running (timeout 300 seconds):
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

5. Verify containers are stable (not restarting) for at least 10 seconds:
   ```bash
   sleep 10
   docker compose ps
   ```

6. Run tests: `dotnet test <solution>` or fall back to `make test` / `pytest`

7. If tests still fail, check container logs for issues:
   ```bash
   docker compose logs --tail=100
   docker compose logs <specific-service>
   ```

The key difference from `building-backend` is that this skill enforces a full container teardown when changes are detected, ensuring no stale state interferes with debugging.
