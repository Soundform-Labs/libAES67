#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running format target via cmake..."
cmake --build "$PROJECT_ROOT/build" --target format

echo "Running lint target via cmake..."
cmake --build "$PROJECT_ROOT/build" --target lint

echo "Lint and format complete."