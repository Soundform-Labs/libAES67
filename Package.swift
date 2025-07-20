// swift-tools-version: 6.2
//===----------------------------------------------------------------------===//
//
// This source file is part of the libAES67 open source project
//
// Copyright (c) 2025 Soundform Labs. and the libAES67 project authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "libAES67",
    platforms: [.macOS(.v26), .iOS(.v26)],
    products: [
        .library(
            name: "libAES67",
            targets: ["libAES67"]
        ),
    ],
    targets: [
        .target(
            name: "libAES67",
            path: "libAES67",
            publicHeadersPath: "include/libAES67",
            cSettings: [
                .headerSearchPath("include"),
                .define("PLATFORM_MACOS", .when(platforms: [.macOS])),
                .define("PLATFORM_IOS", .when(platforms: [.iOS]))
            ],
            cxxSettings: [
                .headerSearchPath("include"),
                .define("PLATFORM_MACOS", .when(platforms: [.macOS])),
                .define("PLATFORM_IOS", .when(platforms: [.iOS]))
            ],
            swiftSettings: []
        ),
    ]
)
