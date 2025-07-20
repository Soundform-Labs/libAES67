/*
 * Copyright (c) 2025 Soundform Labs. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * types.h
 * Description: Definition of various data types used in the library.
 */

#include <stddef.h>
#include <stdint.h>

#ifndef libAES67_types_h
#define libAES67_types_h

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned char aes67_byte_t;
typedef size_t aes67_size_t;

typedef uint32_t aes67_flags_t;

/* Opaque handles */
typedef struct aes67_stream_s aes67_stream_t;
typedef struct aes67_clock_s aes67_clock_t;
typedef struct aes67_session_s aes67_session_t;

typedef uint8_t aes67_bool_t;

#define AES67_TRUE true
#define AES67_FALSE false

#ifdef __cplusplus
}
#endif

#endif /* libAES67_types_h */
