# Claude.md

## Project Overview

This is a **Copilot Skills repository** that provides AI-assisted backend testing capabilities. The skills include:

- **building-backend** - Ensures backend tests run reliably by managing Docker Compose services and waiting for container readiness before executing tests.
- **debugging-tests** - Helps debug test failures by enforcing full container teardown and rebuild when changes are detected in API or core projects.

## Tech Stack

- **Bash/Shell** - Primary scripting language for test orchestration
- **Docker Compose** - Service orchestration for backend containers
- **GitHub Actions** - CI/CD workflow automation
- **.NET/Dotnet** - Preferred test runner
- **Python/Pytest** - Fallback test framework
- **Make** - Alternative test runner support

## Project Structure

```
Skills/
├── .copilot/skills/                    # Copilot skill definitions
│   ├── building-backend/
│   │   └── SKILL.md                    # Backend build/test skill
│   └── debugging-tests/
│       └── SKILL.md                    # Test debugging skill
├── .github/workflows/                  # CI/CD workflows
│   └── backend-tests.yml               # Backend test workflow
├── docs/                               # Documentation
│   ├── BUILDING_BACKEND.md             # Backend skill documentation
│   └── DEBUGGING_TESTS.md              # Debugging skill documentation
├── scripts/                            # Executable scripts
│   └── run_backend_tests.sh            # Test runner script
└── README.md                           # Project overview
```

## Common Commands

```bash
# Run backend tests (full workflow)
./scripts/run_backend_tests.sh

# Run with custom timeout (seconds)
./scripts/run_backend_tests.sh --timeout 600

# Run with specific solution file
./scripts/run_backend_tests.sh --solution MyProject.sln

# Start Docker services manually
docker compose up --build -d

# Run dotnet tests directly
dotnet test <solution.sln>

# Debug tests (full teardown and rebuild)
docker compose down && docker compose up --build -d

# Check container status
docker compose ps --format "table {{.Name}}\t{{.Status}}"

# View container logs
docker compose logs --tail=50
```

## Development Guidelines

1. **Skill Definitions**: Skill JSON files in `.copilot/skills/` define triggers, usage instructions, and preferred commands
2. **Scripts**: Test runner scripts should handle Docker Compose lifecycle and support multiple test frameworks
3. **Documentation**: Keep `docs/BUILDING_BACKEND.md` and `docs/DEBUGGING_TESTS.md` updated when modifying skill behavior

## Testing

The test workflow:
1. Builds and starts Docker Compose services
2. Waits for all containers to be healthy (default 300s timeout)
3. Runs tests via dotnet/make/pytest (in order of preference)
4. Reports results

## CI/CD

GitHub Actions workflow triggers on changes to:
- `api/**`
- `cir/**`
- `docker-compose.yml`
- `.github/workflows/backend-tests.yml`
