{
  description = "Jim's HM — inline, no files";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.jim = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [{
          # Critical: set stateVersion as STRING
          home.stateVersion = "24.05";

          home.username = "jim";
          home.homeDirectory = "/home/jim";
          programs.home-manager.enable = true;

          home.packages = [ pkgs.git pkgs.vim ];

          programs.git.enable = true;
        }];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.git ];
        shellHook = "echo '✅ Default shell ready'";
      };
    };
}
