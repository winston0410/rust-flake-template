{
  description = "Flake for my portfolio";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    mkNodePackage = {
      url = "github:winston0410/mkNodePackage/develop";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlay ];
        });
      in {
        packages = {
            identity = (pkgs.callPackage ./identity.nix {});
        };
        devShell = (({ pkgs, ... }:
          pkgs.mkShell {
            buildInputs = with pkgs; [
              cargo
              rust-bin.stable.latest.default
            ];

            shellHook = "";
          }) { inherit pkgs; });
      });

}
