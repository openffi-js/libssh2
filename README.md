# Static libssh2

Use libssh2 seamlessly in JavaScript without any external dependencies. This package provides libssh2 as a dynamic library, statically compiled against its dependencies. This enables usage of the library with Bun/Node.js FFI.

## Installation

The `@openffi/libssh2` package will install the appropriate library for your OS and architecture.

```bash
npm install @openffi/libssh2 # with npm
bun add @openffi/libssh2     # with Bun
```

Alternatively, if you need the libraries for all platforms, you can install the `@openffi/libssh2-all` package.

## Usage

### Bun FFI Example

```typescript
import { dlopen, FFIType } from "bun:ffi";
import libssh2 from "@openffi/libssh2";

const {
  symbols: { libssh2_version },
} = dlopen(libssh2, {
  libssh2_version : {
    args: ["int"],
    returns: FFIType.cstring,
  },
});

const ret = libssh2_version(0);
console.log(ret); // "1.11.1"
```

## Platform Support

- ✅ Linux (x64, ARM64)
- ✅ macOS (x64, ARM64)
- ✅ Windows (x64)

## Development

This project uses Nix for reproducible builds. To build the static libraries:

```bash
nix build
```

## License

MIT License - see LICENSE file for details.
