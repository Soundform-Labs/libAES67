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
BUILD_DIR="${ROOT_DIR}/build"

usage() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  -r           Build type Release (default)"
  echo "  -d           Build type Debug"
  echo "  -c           Clean build directory before building"
  echo "  -t           Run tests after build"
  echo "  -i           Install the built target"
  echo "  -h           Show this help message"
  exit 0
}

BUILD_TYPE="Release"
CLEAN=0
RUN_TESTS=0
INSTALL=0

while getopts "rdctih" opt; do
  case ${opt} in
    r) BUILD_TYPE="Release" ;;
    d) BUILD_TYPE="Debug" ;;
    c) CLEAN=1 ;;
    t) RUN_TESTS=1 ;;
    i) INSTALL=1 ;;
    h|*) usage ;;
  esac
done

echo ""
echo "-- Build type: ${BUILD_TYPE}"
echo "-- Clean build dir: $([ $CLEAN -eq 1 ] && echo Yes || echo No)"
echo "-- Run tests: $([ $RUN_TESTS -eq 1 ] && echo Yes || echo No)"
echo "-- Install after build: $([ $INSTALL -eq 1 ] && echo Yes || echo No)"
echo ""

if [ $CLEAN -eq 1 ]; then
  echo "=> Cleaning build directory..."
  rm -rf "${BUILD_DIR}"
fi

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

echo "=> Configuring project with CMake..."
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} "${ROOT_DIR}"

echo "=> Building libAES67..."
cmake --build . --config ${BUILD_TYPE}

if [ $RUN_TESTS -eq 1 ]; then
  echo "=> Running tests..."
  ctest --output-on-failure -C ${BUILD_TYPE}
fi

if [ $INSTALL -eq 1 ]; then
  echo "=> Installing libAES67..."
  cmake --install . --config ${BUILD_TYPE}
fi

echo "[SUCCESS]: Build script completed successfully."