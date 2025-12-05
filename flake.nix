{
  description = "Jim's HM — full dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # ✅ Inline HM config (working)
      homeConfigurations.jim = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [{
          home.stateVersion = "24.05";
          home.username = "jim";
          home.homeDirectory = "/home/jim";
          programs.home-manager.enable = true;
          home.packages = [ pkgs.git pkgs.vim ];
          programs.git.enable = true;
        }];
      };

      # ✅ Full devShells
      devShells.${system} = {
        # Default shell
        default = pkgs.mkShell {
          packages = [ pkgs.git ];
          shellHook = "echo '✅ Default shell ready'";
        };

        # NGOLogisticsD: Node.js + FerretDB
        ngologistics-d = pkgs.mkShell {
          name = "NGOLogisticsD";
          packages = with pkgs; [
            nodejs_20 ferretdb git vim curl wget typescript
          ];
          shellHook = "echo '🚀 NGOLogisticsD shell active'";
        };

        # NGOLogisticsCG: WebAssembly + MariaDB
        ngologistics-cg = pkgs.mkShell {
          name = "NGOLogisticsCG";
          packages = with pkgs; [
            reflex pandoc nodejs_20 mariadb git tree vim curl wget
            emscripten binaryen wasm-pack
          ];
          shellHook = "echo '🚀 NGOLogisticsCG shell active'";
        };
      };
    };
}
