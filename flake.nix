{
  description = "Utilities for working with the SGX stream format.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        defaultPackage = rustPlatform.buildRustPackage rec {
          pname = "sgxs-tools";
          version = "0.8.5";

          src = fetchCrate {
            inherit pname version;
            sha256 = "sha256-zKzZOpdO3H1/4tKSdHLbyhY0iAuLoscEfgFDHsQbK3w=";
          };

          cargoSha256 = "sha256-8PxIL/ZaJIocDlYD2fTZ6M2QYkssUq1LqlEHlOUO+U8=";

          nativeBuildInputs = [
            clang_11
            llvmPackages_11.libclang.lib
            pkg-config
            protobuf
            rust-bin.nightly."2021-11-04".default
          ];

          buildInputs = [
            openssl.dev
          ];
        };
      }
    );
}
