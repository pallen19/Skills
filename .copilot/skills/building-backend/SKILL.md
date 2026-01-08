# building-backend

Ensure backend tests run with proper Docker Compose build and container readiness.

## Description

This skill knows that our backend microservices use Sticker and Sorbet. To run tests reliably we must run `docker compose up --build -d` and wait for all containers to be up and healthy before executing tests. When changes are made to `api` or `cir` services, containers must be rebuilt for changes to take effect.

## Usage

- When asked to run tests or verify the backend, run `docker compose up --build -d` and wait for containers to be healthy/running.
- Prefer `dotnet test <solution.sln>`; look for `--solution`, the `SOLUTION_NAME` env var, or the first `*.sln` file if not provided.
- If `dotnet` is not available, fall back to `make test` or `pytest`.
- A repo-provided `scripts/run_backend_tests.sh` is optional; if present use it but still ensure containers are rebuilt when `api/` or `cir/` change.

## Steps

1. Run `docker compose up --build -d`
2. Wait for containers to report HEALTH=healthy or State=running
3. Run `dotnet test <solution>` (discover with --solution, SOLUTION_NAME env, or first *.sln)
4. Fallback: `make test` or `pytest`

## Examples

**Run the backend test suite:**
Run `docker compose up --build -d` then wait for readiness and run `dotnet test <solution>` (or use `SOLUTION_NAME` or `--solution` to select)

**I changed api; make sure tests run with rebuilt containers:**
Run `docker compose up --build -d` and re-run tests so containers pick up the changes

## Notes

The skill prefers to run .NET tests via `dotnet test <solution>` (use `--solution` or `SOLUTION_NAME`), falls back to `make test` or `pytest` if needed. If a repository includes `scripts/run_backend_tests.sh` the assistant may use it, but the skill must not depend on its presence.
