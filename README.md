# libAES67

**A powerful, cross-platform AES67 networking library in C/C++.**

libAES67 provides the building blocks for high-performance, low-latency, real-time audio streaming over IP using the AES67 standard. Designed for portability, modularity, and integration with both embedded systems and desktop platforms, libAES67 powers interoperable media applications across networked environments.

> **Need to send or receive AES67-compliant audio streams?**  
> libAES67 delivers a clean, modern API with support for RTP, SDP, PTP timing, and multicast.

## Design



## Requirements

- CMake 4.0 or later
- C/C++20 toolchain
- Platforms:
  - Linux (x86_64 / ARM64)
  - macOS 15.0+ (Apple Silicon)
  - Windows 11+
  - Embedded (with POSIX sockets)

> For macOS-specific Swift/Objective-C integration, see [SwiftAES67](https://github.com/Soundform-Labs/SwiftAES67)

## Installation

## Adoption

## Testing

## Contributing

Contributions are welcome whether it’s fixing a bug, improving documentation, or suggesting new features.

If you’d like to get involved, please see the [CONTRIBUTING.md](./CONTRIBUTING.md) for how to get started.

Not sure where to begin? Check out the [issues](https://github.com/Soundform-Labs/libAES67/issues) or open a
 [discussion](https://github.com/Soundform-Labs/libAES67/discussions). I’m happy to collaborate and support
 contributors of all experience levels.

## Project Status

Version 0.1.0 is the first official release of libAES67. Earlier versions have no source stability guarantees.

Because the libAES67 library is under active development, source stability is only guaranteed within minor versions (for example, between 0.1.1 and 0.1.2). If you don't want potentially source-breaking package updates, you can specify your package dependency using .upToNextMinorVersion(from: "0.1.0") instead.

Future minor versions of the package may introduce changes to these rules as needed.

## License

libAES67 is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

You may freely use, modify, and distribute this software under the terms of the license. For more details, see the [LICENSE](./LICENSE) file included in this repository.

_© 2025 Soundform Labs and the libAES67 contributors._

## Related Projects

- [SwiftAES67](https://github.com/Soundform-Labs/SwiftAES67) — A Swift/Objective-C wrapper for libAES67, designed for integration into macOS and iOS applications.
- [CoreNetwork](https://github.com/N3v1/CoreNetwork) — A modern, async-first networking framework for Swift, used alongside libAES67 for API integration and service discovery.
