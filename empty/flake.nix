{
  description = "Template flake for direnv shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: let
    additionalPackages = pkgs: [
      pkgs.git
    ];
  in
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.default = pkgs.mkShell {
      buildInputs = additionalPackages pkgs;

      shellHook = ''
        echo "🧪  Welcome to your dev shell!"
        echo "🔧  Tools included: ${toString (map (p: "🔹 ${pkgs.lib.getName p}") (additionalPackages pkgs))}"
      '';
    };
  });
}

