# Copilot Skill: debugging-tests

## Purpose
This skill helps debug test failures by ensuring the Docker environment is completely fresh before running tests. Unlike `building-backend`, this skill enforces a full container teardown when changes are detected, eliminating stale state that could interfere with debugging.

## Key Rules
1. **Check for changes** — Before running tests, check if there are changes to `api/`, `cir/`, `src/`, or `core/` directories.
2. **Tear down first** — If changes are detected, run `docker compose down` to remove existing containers.
3. **Rebuild containers** — Run `docker compose up --build -d` to build fresh containers.
4. **Verify stability** — Wait for containers to be healthy AND stable (not restarting) before running tests.
5. **Then run tests** — Only after verification, execute the test suite.

## How to Use

### Step 1: Check for Changes
Check if any files have changed in the API or core projects:
```bash
git status --porcelain api/ cir/ src/ core/
# Or check recent commits
git diff --name-only HEAD~1
```

### Step 2: Tear Down Existing Containers
If changes are detected, tear down containers to ensure a clean state:
```bash
docker compose down
```

### Step 3: Rebuild and Start Containers
Build and start fresh containers:
```bash
docker compose up --build -d
```

### Step 4: Verify Container Stability
Wait for containers to be healthy and stable (not restarting):

```bash
# Wait for containers to be healthy/running
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

# Verify stability - ensure containers aren't restarting
echo "Verifying container stability..."
sleep 10
docker compose ps
```

### Step 5: Run Tests
Once containers are verified stable:
```bash
dotnet test <solution.sln>
# Or fallback to:
make test
# Or:
pytest
```

### Step 6: Debug Failures
If tests still fail, check container logs:
```bash
docker compose logs --tail=100
docker compose logs <specific-service>
```

## Quick Reference Commands

```bash
# Full debugging workflow
docker compose down && \
docker compose up --build -d && \
sleep 30 && \
docker compose ps && \
dotnet test <solution.sln>

# Check container health
docker compose ps --format "table {{.Name}}\t{{.Status}}"

# View recent logs
docker compose logs --tail=50 --timestamps

# Follow logs in real-time
docker compose logs -f
```

## Notes for Copilot/AI Behavior

When debugging test failures:
1. **Always check for changes** in `api/`, `cir/`, `src/`, or `core/` directories.
2. **If changes exist**, run `docker compose down` before rebuilding.
3. **Always rebuild** with `docker compose up --build -d`.
4. **Verify stability** by checking container status after a brief wait.
5. **Run tests** only after containers are confirmed stable.
6. **Check logs** if tests continue to fail.

## Common Debugging Scenarios

| Scenario | Action |
|----------|--------|
| Tests fail after API changes | Full teardown and rebuild required |
| Tests were working yesterday | Force clean rebuild, check for uncommitted changes |
| Container keeps restarting | Check logs, may indicate code error or missing dependency |
| Tests timeout | Increase health check timeout, verify container readiness |

## CI Guidance
For CI pipelines, always use the full teardown workflow to ensure consistent test results. See `.github/workflows/backend-tests.yml` for reference.

---
