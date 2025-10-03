{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        windowsPkgs = import nixpkgs {
          inherit system;
          crossSystem = {
            config = "x86_64-w64-mingw32";
          };
        };

        x64DarwinPkgs = import nixpkgs {
          inherit system;
          crossSystem = {
            config = "x86_64-darwin";
          };
        };

        aarch64LinuxPkgs = import nixpkgs {
          inherit system;
          crossSystem = {
            config = "aarch64-linux";
          };
        };

        version = pkgs.lib.strings.trim (builtins.readFile ./library-version.txt);

        build =
          targetPkgs: windows:
          targetPkgs.callPackage (
            {
              lib,
              stdenv,
              fetchurl,
              pkgsStatic,
            }:

            stdenv.mkDerivation (finalAttrs: {
              pname = "static-libssh2";
              version = "1.11.1";

              src = fetchurl {
                url = "https://www.libssh2.org/download/libssh2-${version}.tar.gz";
                hash = "sha256-2ex2y+NNuY7sNTn+LImdJrDIN8s+tGalaw8QnKv2WPc=";
              };

              cmakeFlags = [
                "-DBUILD_SHARED_LIBS=ON"
                "-DBUILD_TESTING=OFF"
                "-DCMAKE_BUILD_TYPE=Release"
              ];

              # this could be accomplished by updateAutotoolsGnuConfigScriptsHook, but that causes infinite recursion
              # necessary for FreeBSD code path in configure
              postPatch = ''
                substituteInPlace ./config.guess --replace-fail /usr/bin/uname uname
              '';

              propagatedBuildInputs = lib.optionals (!windows) [
                pkgsStatic.openssl
              ];

              buildInputs = [
                targetPkgs.zlib.static
              ];
            })
          ) { };
      in
      {
        packages.default = build pkgs false;
        packages.windows = build windowsPkgs true;
        packages.x64Darwin = build x64DarwinPkgs false;
        packages.aarch64Linux = build aarch64LinuxPkgs false;
      }
    );
}
