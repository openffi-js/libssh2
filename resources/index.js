import fs from "fs"
import os from "os"
import path from "path"
import { createRequire } from "module"

const require = createRequire(import.meta.url)

function findLib() {
  const platform = os.platform();
  const arch = os.arch();
  const packageName = `@openffi/libssh2-${platform}-${arch}`
  const extension = platform === "darwin" ? "dylib" : "so"
  const basename = platform == "win32" ? `libssh2-1.dll` : `libssh2.${extension}`

  try {
    // Use require.resolve to find the package
    const packageJsonPath = require.resolve(`${packageName}/package.json`)
    const packageDir = path.dirname(packageJsonPath)
    const libraryPath = path.join(packageDir, "lib", basename)

    if (!fs.existsSync(libraryPath)) {
      throw new Error(`Library not found at ${libraryPath}`)
    }

    return libraryPath
  } catch (error) {
    throw new Error(`Could not find package ${packageName}: ${error.message}`)
  }
}

const libraryPath = findLib()

/**
  * The path to the libssh2 shared library.
  * @type {string}
  */
export default libraryPath
