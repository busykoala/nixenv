{
  description = "Symfony dev shell with PHP, Composer, Symfony CLI, and more";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        php = pkgs.php83;

        additionalPackages = [
          pkgs.git
          php
          php.packages.composer         # ✅ use composer from PHP packages
          pkgs.symfony-cli
          pkgs.nodejs_20
          pkgs.mysql-client
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = additionalPackages;

          shellHook = ''
            echo "🔧 Symfony Dev Shell Ready"
            echo "✅ PHP: $(php -v | head -n 1)"
            echo "✅ Composer: $(composer --version)"
            echo "✅ Symfony CLI: $(symfony version)"
            echo "📦 Tools: ${toString (map (p: pkgs.lib.getName p) additionalPackages)}"
          '';
        };
      }
    );
}
