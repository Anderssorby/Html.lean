{
  description = "Html lib for Lean";

  inputs = {
    lean = {
      url = "github:leanprover/lean4/v4.0.0-m5";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    # A lean dependency
    # lean-ipld = {
    #   url = "github:yatima-inc/lean-ipld";
    #   # Compile dependencies with the same lean version
    #   inputs.lean.follows = "lean";
    # };
  };

  outputs = { self, lean, flake-utils, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      inherit (flake-utils) lib;
    in
    lib.eachSystem supportedSystems (system:
      let
        leanPkgs = lean.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
        name = "Html";  # must match the name of the top-level .lean file
        project = leanPkgs.buildLeanPackage {
          inherit name;
          # deps = [ lean-ipld.project.${system} ];
          # Where the lean files are located
          src = ./src;
        };
        test = leanPkgs.buildLeanPackage {
          name = "Tests";
          deps = [ project ];
          # Where the lean files are located
          src = ./test;
        };
      in
      {
        inherit project test;
        packages = project // {
          ${name} = project.executable;
          test = test.executable;
        };

        defaultPackage = self.packages.${system}.${name};
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              elan
            ];
            LEAN_PATH = "./src:./test";
            LEAN_SRC_PATH = "./src:./test";
          };
          lean-dev = pkgs.mkShell {
            inputsFrom = [ project.executable ];
            buildInputs = with pkgs; [
              leanPkgs.lean-dev
            ];
            LEAN_PATH = "./src:./test";
            LEAN_SRC_PATH = "./src:./test";
          };
        };
      });
}
