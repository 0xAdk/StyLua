{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
  };

  outputs = inputs: let
    # @type (system: string) -> (pkgs: nixpkgs) -> { ${system} = any }
    forAllSystems = f: builtins.mapAttrs f inputs.nixpkgs.legacyPackages;
  in {
    packages = forAllSystems (system: pkgs: let
      inherit (pkgs) lib;
      craneLib = inputs.crane.mkLib pkgs;
    in {
      default = let
        unfilteredRoot = ./.;

        src = lib.fileset.toSource {
          root = unfilteredRoot;

          fileset = lib.fileset.unions [
            (craneLib.fileset.commonCargoSources unfilteredRoot)
            ./tests
          ];
        };
      in
        craneLib.buildPackage {inherit src;};
    });
  };
}
