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
 * Description: Definitions of network-related types used throughout the AES67 library.
 */

#ifndef libAES67_network_types_h
#define libAES67_network_types_h

#ifdef __cplusplus
extern "C" {
#endif

#include <libAES67/types.h>
#include <stdint.h>

typedef uint16_t aes67_port_t;

typedef struct {
    uint8_t bytes[16];
    aes67_bool_t is_ipv4;
} aes67_ip_address_t;

typedef enum {
    AES67_PROTOCOL_UDP,
    AES67_PROTOCOL_RTP
} aes67_protocol_t;

typedef struct {
    aes67_ip_address_t address;
    aes67_port_t port;
} aes67_socket_address_t;

typedef struct {
    aes67_socket_address_t local;
    aes67_socket_address_t remote;
    aes67_protocol_t protocol;
} aes67_connection_info_t;

typedef enum {
    AES67_ADDRESS_TYPE_UNICAST,
    AES67_ADDRESS_TYPE_MULTICAST,
    AES67_ADDRESS_TYPE_BROADCAST
} aes67_address_type_t;

typedef struct {
    aes67_ip_address_t address;
    aes67_port_t port;
    aes67_address_type_t addr_type;
} aes67_network_endpoint_t;

typedef struct {
    aes67_ip_address_t group_address;
    uint32_t interface_index;
} aes67_multicast_group_t;

#ifdef __cplusplus
}
#endif

#endif /* libAES67_network_types_h */
