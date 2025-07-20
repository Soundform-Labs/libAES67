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
 * time.h
 * Description:
 */

#ifndef libAES67_time_h
#define libAES67_time_h

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define AES67_NSEC_PER_SEC 1000000000ULL
#define AES67_NSEC_PER_MSEC 1000000ULL
#define AES67_NSEC_PER_USEC 1000ULL

typedef uint64_t aes67_timestamp_t;
typedef int64_t aes67_duration_t;

aes67_timestamp_t aes67_time_now(void);
aes67_timestamp_t aes67_time_add(aes67_timestamp_t time, aes67_duration_t duration);
aes67_duration_t aes67_time_diff(aes67_timestamp_t end, aes67_timestamp_t start);
bool aes67_time_less(aes67_timestamp_t t1, aes67_timestamp_t t2);

static inline aes67_duration_t aes67_duration_from_seconds(double seconds) {
    return (aes67_duration_t) (seconds * AES67_NSEC_PER_SEC);
}

#ifdef __cplusplus
}
#endif

#endif