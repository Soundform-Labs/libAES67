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
 * Description: Definition of audio-related data types used in the library.
 */

#ifndef LIBAES67_AUDIO_TYPES_H
#define LIBAES67_AUDIO_TYPES_H

#include <stdint.h>

typedef uint8_t UInt8;
typedef uint16_t UInt16;
typedef uint32_t UInt32;
typedef uint64_t UInt64;
typedef float Float32;
typedef double Float64;

typedef enum {
    kAES67SampleFormatS16LE,
    kAES67SampleFormatS24LE,
    kAES67SampleFormatS32LE,
    kAES67SampleFormatFloat32,
    kAES67SampleFormatFloat64
} AES67SampleFormat;

typedef UInt16 AES67ChannelMask;
typedef UInt8 AES67ChannelCount;

typedef uint32_t AES67SampleRate;
typedef uint16_t AES67BitDepth;
typedef uint64_t AES67FrameCount;
typedef uint64_t AES67Timestamp;

typedef struct {
    AES67SampleFormat format;
    AES67SampleRate sample_rate;
    AES67ChannelCount channels;
    AES67BitDepth bit_depth;
} AES67AudioFormat;

typedef struct {
    AES67Timestamp presentation_time;
    AES67FrameCount frame_count;
    void* data;
} AES67AudioBuffer;

#endif