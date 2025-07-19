#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running clang-format..."
find "$PROJECT_ROOT/libAES67" -regex '.*\.\(c\|h\)$' -exec clang-format -i {} +

echo "Running clang-tidy..."
for file in $(find "$PROJECT_ROOT/libAES67" -name '*.c'); do
  clang-tidy "$file" -- -I"$PROJECT_ROOT/libAES67/include"
done

echo "Running cppcheck..."
cppcheck --enable=all --inconclusive --std=c23 --quiet \
  -I "$PROJECT_ROOT" \
  -I "$PROJECT_ROOT/libAES67/include" \
  "$PROJECT_ROOT/libAES67"

echo "Lint and format complete."