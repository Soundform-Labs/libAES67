cmake_minimum_required(VERSION 4.0)
project(libAES67 LANGUAGES C)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

file(GLOB_RECURSE LIBAES67_SOURCES CONFIGURE_DEPENDS libAES67/src/*.c)
file(GLOB_RECURSE LIBAES67_HEADERS CONFIGURE_DEPENDS libAES67/include/libAES67/*.h)

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

add_library(libAES67 STATIC ${LIBAES67_SOURCES} ${LIBAES67_HEADERS})
target_include_directories(libAES67 PUBLIC ${CMAKE_SOURCE_DIR}/libAES67/include)

if(MSVC)
    target_compile_options(libAES67 PRIVATE /W4)
else()
    target_compile_options(libAES67 PRIVATE
        -Wall -Wextra -Werror -Wpedantic -Wunused-parameter -Wshadow -Wconversion -Wcast-align -Wnull-dereference
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

# ===============================
# clang-tidy (if available)
# ===============================
find_program(CLANG_TIDY_EXE NAMES clang-tidy)
if(CLANG_TIDY_EXE)
    message(STATUS "clang-tidy found: ${CLANG_TIDY_EXE}")
    set(CMAKE_C_CLANG_TIDY "${CLANG_TIDY_EXE}")
endif()

# ===============================
# clang-format
# ===============================
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

# ===============================
# cppcheck
# ===============================
find_program(CPPCHECK_EXE NAMES cppcheck)
if(CPPCHECK_EXE)
    add_custom_target(lint
        COMMAND ${CPPCHECK_EXE}
            --enable=all
            --inconclusive
            --std=c23
            --quiet
            -I ${CMAKE_SOURCE_DIR}
            -I ${CMAKE_SOURCE_DIR}/libAES67/include
            ${CMAKE_SOURCE_DIR}/libAES67/src
        COMMENT "Running cppcheck")
endif()