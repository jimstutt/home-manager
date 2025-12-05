{
  description = "Jim's HM — ghc-wasm-meta as input";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    ghc-wasm-meta.url = "git+file:///home/jim/Dev/ghc-wasm-meta";
  };

  outputs = { self, nixpkgs, home-manager, ghc-wasm-meta, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
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

      devShells.${system} = {
        default = pkgs.mkShell {
          packages = [ pkgs.git ];
          shellHook = "echo '✅ Default shell ready'";
        };

        ngologistics-d = pkgs.mkShell {
          name = "NGOLogisticsD";
          packages = with pkgs; [
            nodejs_20 ferretdb git vim curl wget typescript
          ];
          shellHook = "echo '🚀 NGOLogisticsD shell active'";
        };

        ngologistics-cg = pkgs.mkShell {
          name = "NGOLogisticsCG";
          inputsFrom = [ ghc-wasm-meta.devShells.${system}.default ];
          packages = with pkgs; [
            reflex pandoc nodejs_20 mariadb git tree vim curl wget
            emscripten binaryen wasm-pack
          ];
          shellHook = ''
            echo '🚀 NGOLogisticsCG + GHC-WASM'
            ghc --version 2>/dev/null | head -1
          '';
        };
      };
    };
}
