#!/usr/bin/env bash
# scripts/rollback.sh
# Rolls back to the previous release symlink if a deployment fails.

set -euo pipefail

ENVIRONMENT="${1:-dev}"
APP_NAME="sample-platform-service"
RELEASES_DIR="/opt/${APP_NAME}/releases"
CURRENT_LINK="/opt/${APP_NAME}/current"

echo "=== Rolling back ${APP_NAME} in environment: ${ENVIRONMENT} ==="

PREVIOUS_RELEASE=$(ls -1dt "${RELEASES_DIR}"/*/ | sed -n '2p')

if [ -z "${PREVIOUS_RELEASE}" ]; then
  echo "No previous release found to roll back to." >&2
  exit 1
fi

echo "Rolling back to: ${PREVIOUS_RELEASE}"
ln -sfn "${PREVIOUS_RELEASE%/}" "${CURRENT_LINK}"

echo "Restarting application service..."
sudo systemctl restart "${APP_NAME}" || true

echo "Rollback complete. Active release: ${PREVIOUS_RELEASE}"

