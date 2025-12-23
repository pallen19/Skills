#!/usr/bin/env bash
set -euo pipefail

# Script to reliably run backend tests in this repo.
# Usage: ./scripts/run_backend_tests.sh [--timeout SECONDS]

TIMEOUT=180
SOLUTION=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --timeout) TIMEOUT="$2"; shift 2;;
    --solution) SOLUTION="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

COMPOSE_CMD="docker compose"

echo "[build] Bringing up containers with build (detached)"
$COMPOSE_CMD up --build -d

services=$($COMPOSE_CMD ps --services)
if [[ -z "$services" ]]; then
  echo "No services found in docker compose. Proceeding without wait."
else
  echo "[wait] Detected services: $services"
  deadline=$((SECONDS + TIMEOUT))
  for s in $services; do
    container=$($COMPOSE_CMD ps -q $s)
    echo "[wait] Waiting for service '$s' (container: $container)"
    if [[ -z "$container" ]]; then
      echo "  could not find container for $s; continuing"
      continue
    fi

    ready=false
    while [[ $SECONDS -lt $deadline ]]; do
      # Prefer HEALTH check status when available
      status=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$container" 2>/dev/null || true)
      if [[ "$status" == "healthy" || "$status" == "running" ]]; then
        echo "  $s is ready (status=$status)"
        ready=true
        break
      fi
      sleep 2
    done

    if [[ "$ready" != true ]]; then
      echo "Warning: $s did not become healthy/running within $TIMEOUT seconds. Proceeding anyway."
    fi
  done
fi

# Run tests: prefer dotnet with solution file (use --solution or SOLUTION_NAME env var)
if [[ -z "${SOLUTION}" ]]; then
  SOLUTION="${SOLUTION_NAME:-}"
fi
# discover .sln if not specified
if [[ -z "${SOLUTION}" ]]; then
  slnfile=$(ls *.sln 2>/dev/null | head -n1 || true)
  if [[ -n "$slnfile" ]]; then
    SOLUTION="$slnfile"
  fi
fi

if [[ -n "$SOLUTION" && command -v dotnet >/dev/null 2>&1 ]]; then
  echo "[test] Running 'dotnet test "$SOLUTION"'"
  dotnet test "$SOLUTION"
else
  # Fallbacks: Makefile or pytest
  if [[ -f Makefile && $(grep -E "^test:" Makefile || true) ]]; then
    echo "[test] Running 'make test'"
    make test
  elif command -v pytest >/dev/null 2>&1; then
    echo "[test] Running 'pytest'"
    pytest
  else
    echo "No recognized test runner found (dotnet, Makefile/test, or pytest). Please run tests manually."
    exit 1
  fi
fi

echo "[done] Tests finished"
