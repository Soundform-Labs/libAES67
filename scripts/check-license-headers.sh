#!/bin/sh
##===----------------------------------------------------------------------===##
##
## This source file is part of the libAES67 open source project
##
## Copyright (c) 2025 Soundform Labs. All rights reserved.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     https://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
##===----------------------------------------------------------------------===##

set -e

ROOT_DIR=$(git rev-parse --show-toplevel)
LICENSE_TEMPLATE="$ROOT_DIR/dev/source.license.template"
EXTENSIONS="h hpp hxx m mm c cpp cc cxx"

normalize() {
    sed 's/[[:space:]]\+$//' "$1" | tr -d '\r'
}

EXPECTED_HEADER=$(normalize "$LICENSE_TEMPLATE")
HEADER_LINE_COUNT=$(printf "%s\n" "$EXPECTED_HEADER" | wc -l | tr -d ' ')

echo "=> Checking license headers in: $ROOT_DIR"
echo "=> Using header from: $LICENSE_TEMPLATE"

for ext in $EXTENSIONS; do
    find "$ROOT_DIR" \( -path "$ROOT_DIR/build" -o -path "$ROOT_DIR/build/*" \) -prune -o -type f -name "*.$ext" -print | while read -r file; do
        FILE_HEADER=$(head -n "$HEADER_LINE_COUNT" "$file" | sed 's/[[:space:]]\+$//' | tr -d '\r')

        NORMALIZED_FILE_HEADER=$(printf "%s\n" "$FILE_HEADER" | sed -E 's/[0-9]{4}/<YEAR>/g')
        NORMALIZED_EXPECTED=$(printf "%s\n" "$EXPECTED_HEADER" | sed -E 's/[0-9]{4}/<YEAR>/g')

        if [ "$NORMALIZED_FILE_HEADER" != "$NORMALIZED_EXPECTED" ]; then
            echo "✗ Missing or incorrect license header: $file"
            exit 1
        fi
    done
done

if [ $? -eq 0 ]; then
    echo "[SUCCESS]: All files contain the correct license header. Exiting with code 0."
    exit 0
else
    echo "[WARN]: Some files are missing or have incorrect license headers."
    exit 1
fi