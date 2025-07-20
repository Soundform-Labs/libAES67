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

i=""

read -p "This will replace your current pasteboard. Continue? [y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then

	if [[ "$OSTYPE" == "darwin"* ]]; then
		macos=$(defaults read loginwindow SystemVersionStampAsString | cat -)
		xcodebuild_version=$(/usr/bin/xcodebuild -version | grep Xcode)
		xcodebuild_build=$(/usr/bin/xcodebuild -version | grep Build)
		xcodeselectpath=$(xcode-select -p | cat -)
		swiftversion=$(swift --version)
		unix_version_name=$(uname -a | tr ";" '\n')
		swift_path=$(command -v swift)
		clang_path=$(command -v clang)
		cmake_path=$(command -v cmake)
		gcc_path=$(command -v gcc)

		i="${i}macOS version: ${macos}\n"
		i="${i}Unix version: ${unix_version_name}\n"
		i="${i}Xcode-select path: ${xcodeselectpath}\n"
		i="${i}Xcode: ${xcodebuild_version} (${xcodebuild_build})\n"
		i="${i}Swift version: ${swiftversion}\n"
		i="${i}Swift path: ${swift_path}\n"
		i="${i}Clang path: ${clang_path}\n"
		i="${i}Clang version: $(clang --version | head -n 1)\n"
		i="${i}CMake path: ${cmake_path}\n"
		i="${i}CMake version: $(cmake --version | head -n 1)\n"
		i="${i}GCC path: ${gcc_path}\n"
		i="${i}GCC version: $(gcc --version | head -n 1)\n"
	elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
		arch=$(wmic os get osarchitecture | grep -Eo '[0-9]+-bit')
		msvc=$(where cl.exe >nul 2>&1 && cl.exe 2>&1 | findstr /C:"Version")
		i="${i}Architecture: ${arch}\n"
		i="${i}MSVC version: ${msvc}\n"
		i="${i}CMake version: $(cmake --version | head -n 1)\n"
	else
		arch=$(uname -m)
		linux_distro=$(cat /etc/*release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')
		i="${i}Architecture: ${arch}\n"
		i="${i}Linux distribution: ${linux_distro}\n"
		i="${i}Clang version: $(clang --version | head -n 1)\n"
		i="${i}CMake version: $(cmake --version | head -n 1)\n"
	fi

	if [[ "$OSTYPE" == "darwin"* ]]; then
		echo -e "$i" | pbcopy
		copy_status=$?
	elif command -v xclip &>/dev/null; then
		echo -e "$i" | xclip -selection clipboard
		copy_status=$?
	elif command -v wl-copy &>/dev/null; then
		echo -e "$i" | wl-copy
		copy_status=$?
	elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
		echo -e "$i" | clip
		copy_status=$?
	else
		echo "Could not copy to clipboard; unsupported system or missing clipboard tool."
		echo -e "$i"
		copy_status=1
	fi

	if [ ${copy_status:-0} -eq 0 ]; then
		echo "Your pasteboard now contains debug info, paste it on Github"
	else
		echo "An unexpected error occurred."
		exit 1
	fi
fi