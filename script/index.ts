import { dlopen, FFIType } from "bun:ffi";

let path = process.argv[2];
if (!path) {
  console.error("Usage: bun run libgit.ts /path/to/library");
  process.exit(1);
}

const {
  symbols: { libssh2_version },
} = dlopen(path, {
  libssh2_version : {
    args: ["int"],
    returns: FFIType.cstring,
  },
});

const ret = libssh2_version(0);
console.log(ret);
