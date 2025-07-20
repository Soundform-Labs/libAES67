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

cmake_minimum_required(VERSION 4.0)
project(libAES67 LANGUAGES C CXX OBJC OBJCXX)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)

option(BUILD_SHARED_LIBS "Build shared libraries instead of static ones" OFF)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

file(GLOB_RECURSE LIBAES67_SOURCES CONFIGURE_DEPENDS
    libAES67/src/*.c
    libAES67/src/*.cpp
    libAES67/src/*.m
    libAES67/src/*.mm
)

file(GLOB_RECURSE LIBAES67_HEADERS CONFIGURE_DEPENDS
    libAES67/include/libAES67/*.h
    libAES67/include/libAES67/*.hpp
)

if(WIN32)
    message(STATUS "Configuring for Windows")
    add_definitions(-DPLATFORM_WINDOWS)
elseif(UNIX AND NOT APPLE)
    message(STATUS "Configuring for Linux")
    add_definitions(-DPLATFORM_LINUX)
elseif(APPLE)
    message(STATUS "Configuring for macOS")
    add_definitions(-DPLATFORM_MACOS)
endif()

add_library(libAES67 ${LIBAES67_SOURCES} ${LIBAES67_HEADERS})

if(APPLE)
    set(FRAMEWORK_IDENTIFIER "com.soundformlabs.libAES67")
    set(FRAMEWORK_NAME "libAES67")
    set(FRAMEWORK_VERSION "0.1.0")
    set(FRAMEWORK_SHORT_VERSION "0.1")

    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.in"
        "${CMAKE_CURRENT_BINARY_DIR}/Info.plist"
        @ONLY
    )

    set_target_properties(libAES67 PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        MACOSX_FRAMEWORK_IDENTIFIER ${FRAMEWORK_IDENTIFIER}
        MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${FRAMEWORK_SHORT_VERSION}
        MACOSX_FRAMEWORK_BUNDLE_VERSION ${FRAMEWORK_VERSION}
        XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development"
        RESOURCE "${CMAKE_CURRENT_BINARY_DIR}/Info.plist"
    )
endif()

find_library(FOUNDATION_FRAMEWORK Foundation)
if(FOUNDATION_FRAMEWORK)
    target_link_libraries(libAES67 PRIVATE ${FOUNDATION_FRAMEWORK})
endif()

target_include_directories(libAES67
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/libAES67/include>
    PRIVATE
        ${CMAKE_SOURCE_DIR}/libAES67/src
)

if(APPLE)
    install(TARGETS libAES67
        EXPORT libAES67Targets
        FRAMEWORK DESTINATION Library/Frameworks
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
else()
    install(TARGETS libAES67
        EXPORT libAES67Targets
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
endif()

install(DIRECTORY libAES67/include/libAES67/
        DESTINATION include/libAES67)

if(MSVC)
    target_compile_options(libAES67 PRIVATE /W4)
else()
    target_compile_options(libAES67 PRIVATE
        -Wall -Wextra -Werror -Wpedantic -Wunused-parameter -Wshadow -Wconversion -Wcast-align -Wnull-dereference -Wobjc-missing-property-synthesis
    )

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        target_compile_options(libAES67 PRIVATE
            -fsanitize=address -fsanitize=undefined -g -O0
        )
        target_link_options(libAES67 PRIVATE -fsanitize=address -fsanitize=undefined)
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        target_compile_options(libAES67 PRIVATE -O2 -fstack-protector-strong)
    elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
        target_compile_options(libAES67 PRIVATE -O2 -g -fstack-protector-strong)
    endif()
endif()

if(NOT MSVC)
    target_compile_definitions(libAES67 PRIVATE _FORTIFY_SOURCE=2)
endif()

set_target_properties(libAES67 PROPERTIES POSITION_INDEPENDENT_CODE ON)

set_target_properties(libAES67 PROPERTIES
    PUBLIC_HEADER "${LIBAES67_HEADERS}"
)

install(EXPORT libAES67Targets
    FILE libAES67Targets.cmake
    NAMESPACE libAES67::
    DESTINATION lib/cmake/libAES67
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/libAES67ConfigVersion.cmake"
    VERSION 1.0.0
    COMPATIBILITY SameMajorVersion
)

# libAES67Config.cmake.in is in 'dev/' folder for cleanliness:
configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/dev/libAES67Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/libAES67Config.cmake"
    INSTALL_DESTINATION lib/cmake/libAES67
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/libAES67Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/libAES67ConfigVersion.cmake"
    DESTINATION lib/cmake/libAES67
)

include(CheckCSourceCompiles)
check_c_source_compiles("
    #if __STDC_VERSION__ < 202311L
    #error Not C23
    #endif
    int main() { return 0; }" HAS_C23)

if(NOT HAS_C23)
    message(FATAL_ERROR "C23 not supported by this compiler")
endif()

include(CTest)
enable_testing()
add_subdirectory(libAES67Tests)

if(CMAKE_C_COMPILER_ID MATCHES "Clang")
    target_compile_options(libAES67 PRIVATE
        -Weverything
        -Wno-documentation
        -Wno-c++98-compat
        -Wno-c++98-compat-pedantic
        -Wno-padded
    )
endif()

# clang-tidy
find_program(CLANG_TIDY_EXE NAMES clang-tidy)
if(CLANG_TIDY_EXE)
    message(STATUS "clang-tidy found: ${CLANG_TIDY_EXE}")
    set(CMAKE_C_CLANG_TIDY "${CLANG_TIDY_EXE}")
endif()

# clang-format target
file(GLOB_RECURSE ALL_SOURCE_FILES CONFIGURE_DEPENDS
    ${CMAKE_SOURCE_DIR}/libAES67/src/*.c
    ${CMAKE_SOURCE_DIR}/libAES67/include/libAES67/*.h
)

find_program(CLANG_FORMAT_EXE NAMES clang-format)
if(CLANG_FORMAT_EXE)
    add_custom_target(format
        COMMAND ${CLANG_FORMAT_EXE} -i ${ALL_SOURCE_FILES}
        COMMENT "Running clang-format on all source/header files")
endif()

# cppcheck target
find_program(CPPCHECK_EXE NAMES cppcheck)
if(CPPCHECK_EXE)
    add_custom_target(lint
        COMMAND ${CPPCHECK_EXE}
            --enable=all
            --inconclusive
            --std=c23
            --quiet
            --suppress=missingIncludeSystem
            --suppress=unmatchedSuppression
            -I ${CMAKE_SOURCE_DIR}
            -I ${CMAKE_SOURCE_DIR}/libAES67/include
            ${CMAKE_SOURCE_DIR}/libAES67/src
        COMMENT "Running cppcheck")
endif()