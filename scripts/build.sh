#!/usr/bin/env bash
# scripts/build.sh
# Sample build script - installs dependencies and produces a dist/ folder.

set -euo pipefail

echo "Installing dependencies..."
if [ -f package.json ]; then
  npm ci
elif [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

echo "Running build..."
mkdir -p dist
echo "Build artifacts would be generated here." > dist/BUILD_INFO.txt

echo "Build complete."

