#!/usr/bin/env bash
# scripts/deploy.sh
# Sample deployment automation script demonstrating environment-aware
# release orchestration for an application server fleet.

set -euo pipefail

ENVIRONMENT="${1:-dev}"
APP_NAME="sample-platform-service"
RELEASE_DIR="/opt/${APP_NAME}/releases/$(date +%Y%m%d%H%M%S)"
CURRENT_LINK="/opt/${APP_NAME}/current"

echo "=== Deploying ${APP_NAME} to environment: ${ENVIRONMENT} ==="

case "${ENVIRONMENT}" in
  dev|staging|prod)
    echo "Target environment validated: ${ENVIRONMENT}"
    ;;
  *)
    echo "Unknown environment '${ENVIRONMENT}'. Expected dev, staging, or prod." >&2
    exit 1
    ;;
esac

echo "Creating release directory: ${RELEASE_DIR}"
mkdir -p "${RELEASE_DIR}"

echo "Extracting build artifact..."
tar -xzf "build/artifacts/${APP_NAME}.tar.gz" -C "${RELEASE_DIR}"

echo "Running pre-deploy health check on current release..."
if [ -L "${CURRENT_LINK}" ]; then
  echo "Previous release found at $(readlink -f "${CURRENT_LINK}")"
fi

echo "Switching symlink to new release..."
ln -sfn "${RELEASE_DIR}" "${CURRENT_LINK}"

echo "Restarting application service..."
sudo systemctl restart "${APP_NAME}" || true

echo "Deployment to ${ENVIRONMENT} complete: ${RELEASE_DIR}"

