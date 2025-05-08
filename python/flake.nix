{
  description = "Template flake for direnv shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        additionalPackages = [
          pkgs.python312
          pkgs.poetry
          pkgs.libxml2
          pkgs.xmlsec
          pkgs.openssl
          pkgs.pkg-config
          pkgs.zlib
          pkgs.libtool
        ];

        envVars = {
          # PKG_CONFIG_PATH is critical for python-xmlsec to find system libs
          PKG_CONFIG_PATH = pkgs.lib.makeSearchPath "lib/pkgconfig" [
            pkgs.libxml2
            pkgs.xmlsec
            pkgs.openssl
            pkgs.zlib
            pkgs.libtool
          ];
          PIP_NO_BINARY = "xmlsec";
        };

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = additionalPackages;
          shellHook = ''
            echo "🧪  Welcome to your dev shell!"
            echo "🔧  Tools included:"
            echo "${pkgs.lib.strings.concatStringsSep "\n" (map (p: "🔹 ${pkgs.lib.getName p}") additionalPackages)}"
          '';
          inherit (envVars) PKG_CONFIG_PATH;
        };
      }
    );
}
