# Claude.md

## Project Overview

This is a **Copilot Skills repository** that provides AI-assisted backend testing capabilities. The primary skill, "building-backend", ensures backend tests run reliably by managing Docker Compose services and waiting for container readiness before executing tests.

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
├── .copilot/skills/          # Copilot skill definitions
│   └── building-backend.json # Main skill configuration
├── .github/workflows/        # CI/CD workflows
│   └── backend-tests.yml     # Backend test workflow
├── docs/                     # Documentation
│   └── BUILDING_BACKEND.md   # Detailed skill documentation
├── scripts/                  # Executable scripts
│   └── run_backend_tests.sh  # Test runner script
└── README.md                 # Project overview
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
```

## Development Guidelines

1. **Skill Definitions**: Skill JSON files in `.copilot/skills/` define triggers, usage instructions, and preferred commands
2. **Scripts**: Test runner scripts should handle Docker Compose lifecycle and support multiple test frameworks
3. **Documentation**: Keep `docs/BUILDING_BACKEND.md` updated when modifying skill behavior

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
