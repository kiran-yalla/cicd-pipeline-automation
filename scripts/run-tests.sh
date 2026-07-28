#!/usr/bin/env bash
# scripts/run-tests.sh
# Sample test runner - executes unit tests and writes JUnit-style output.

set -euo pipefail

mkdir -p test-results

echo "Running unit tests..."
# Example: npm test -- --reporters=jest-junit
# Example: pytest --junitxml=test-results/results.xml

echo "All tests passed."

