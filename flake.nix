# flake.nix
{
  description = "Jim's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.jim = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };

      devShells.${system} = {
        ngologistics-d = pkgs.mkShell {
          name = "NGOLogisticsD";
          buildInputs = with pkgs; [
            nodejs_20
            ferretdb
            git
            vim
            curl
            wget
            typescript
          ];
          shellHook = ''
            echo "NGOLogisticsD Development Shell (Node.js + FerretDB)"
            echo "Run: cd ~/Dev/NGOLogisticsD && npm run dev"
          '';
        };

        ngologistics-cg = pkgs.mkShell {
          name = "NGOLogisticsCG";
          buildInputs = with pkgs; [
            reflex-platform
            nodejs_20
            mariadb
            git
            vim
            curl
            wget
            emscripten
            binaryen
            wasm-pack
          ];
          shellHook = ''
            echo "NGOLogisticsCG Development Shell (WebAssembly + MariaDB)"
            echo "Run: cd ~/Dev/NGOLogisticsCG && npm run dev"
          '';
        };
      };
    };
}

