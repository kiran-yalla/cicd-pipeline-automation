#!/usr/bin/env bash
# scripts/smoke-test.sh
# Basic post-deploy smoke tests to validate the service is healthy.

set -euo pipefail

ENVIRONMENT="${1:-dev}"

declare -A HEALTH_URLS=(
  [dev]="http://dev.internal.example.com/health"
  [staging]="http://staging.internal.example.com/health"
  [prod]="https://app.example.com/health"
)

URL="${HEALTH_URLS[${ENVIRONMENT}]:-}"

if [ -z "${URL}" ]; then
  echo "No health check URL configured for '${ENVIRONMENT}'." >&2
  exit 1
fi

echo "Running smoke test against ${URL}..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${URL}" || echo "000")

if [ "${HTTP_STATUS}" == "200" ]; then
  echo "Smoke test passed (HTTP ${HTTP_STATUS})."
else
  echo "Smoke test failed (HTTP ${HTTP_STATUS})." >&2
  exit 1
fi

