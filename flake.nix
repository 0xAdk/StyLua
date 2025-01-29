{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
      inherit (pkgs) lib;
      craneLib = inputs.crane.mkLib pkgs;
    in {
      packages.default = craneLib.buildPackage {
        # cleaning the source causes some tests to fail and I couldn't figure
        # out the right files required to get them passing
        src = ./.;
        # src = craneLib.cleanCargoSource ./.;
      };
    });
}
