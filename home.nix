# home.nix
{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "jim";
  home.homeDirectory = "/home/jim";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [

    # General Haskell Tools
    cabal-install
    haskell-language-server
    
    # The specific WASM compiler globally (optional, usually better in devShell)
    wasmFlake.ghc-wasm32-wasi
    
    # WASM Runtimes (Replacing the need for scripts/run-wasm.sh )
    wasmtime
    wabt # for wasm-objdump, etc.

    (writeShellScriptBin "setup-ngologistics-d" ''
      echo "Setting up NGO Logistics D (Node.js + FerretDB)..."
      if [ -d "$HOME/Dev/NGOLogisticsD" ]; then
        cd "$HOME/Dev/NGOLogisticsD"
        npm install
        echo "NGO Logistics D setup complete!"
      else
        echo "Error: NGO Logistics D project not found"
      fi
    '')

    (writeShellScriptBin "start-ngologistics-d" ''
      echo "Starting NGO Logistics D (Node.js + FerretDB)..."
      if [ ! -d "$HOME/Dev/NGOLogisticsD" ]; then
        echo "Error: Project directory not found"
        exit 1
      fi

      if ! pgrep -f "ferretdb" > /dev/null; then
        echo "Starting FerretDB on port 27017..."
        ${pkgs.ferretdb}/bin/ferretdb --listen-addr 127.0.0.1:27017 &
        sleep 2
      fi

      cd "$HOME/Dev/NGOLogisticsD"
      ${pkgs.concurrently}/bin/concurrently \
        "cd Backend && npm run dev" \
        "cd App && npm run dev -- --port 5174" \
        --names "BACKEND-D,FRONTEND-D" \
        --prefix-colors "blue,green"
    '')

    (writeShellScriptBin "stop-ngologistics-d" ''
      echo "Stopping NGO Logistics D..."
      pkill -f "ferretdb"
      pkill -f "node.*Backend.*NGOLogisticsD"
      pkill -f "vite.*5174"
    '')

    nodejs_20
    ferretdb
    git
    vim
    curl
    wget
    jq
    concurrently
    sqlite
    obelisk
    pandoc
  ];
}
