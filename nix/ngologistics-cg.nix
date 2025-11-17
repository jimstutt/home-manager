{ config, pkgs, ... }:

let
  ngologistics-cg = pkgs.stdenv.mkDerivation {
    name = "ngologistics-cg";
    src = ./ngologistics-cg;
    
    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];
    
    buildInputs = with pkgs; [
      nodejs_20
      mariadb
      emscripten
      binaryen
      wasm-pack
    ];
    
    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/ngologistics-cg
      
      # Copy application files
      cp -r . $out/share/ngologistics-cg/
      
      # Create startup script
      makeWrapper ${pkgs.writeShellScript "start-ngologistics-cg" ''
        echo "Starting NGO Logistics CG (WebAssembly + MariaDB)..."
        
        # Start MariaDB on unique port
        if ! pgrep -f "mariadbd.*3307" > /dev/null; then
          echo "Starting MariaDB on port 3307..."
          mkdir -p /tmp/ngologistics-cg/mariadb-data
          ${pkgs.mariadb}/bin/mariadbd --port=3307 --datadir=/tmp/ngologistics-cg/mariadb-data --socket=/tmp/ngologistics-cg/mariadb.sock &
          sleep 3
        fi
        
        # Initialize database
        if [ ! -f /tmp/ngologistics-cg/db-initialized ]; then
          echo "Initializing MariaDB database..."
          ${pkgs.mariadb}/bin/mysql --port=3307 --host=localhost --protocol=tcp -e "CREATE DATABASE IF NOT EXISTS NGOLogisticsCG;" || true
          touch /tmp/ngologistics-cg/db-initialized
        fi
        
        # Start services
        cd $out/share/ngologistics-cg
        ${pkgs.nodejs_20}/bin/npm install
        ${pkgs.concurrently}/bin/concurrently \
          "cd Backend && ${pkgs.nodejs_20}/bin/npm run dev" \
          "cd Frontend && ${pkgs.nodejs_20}/bin/npm run dev -- --port 5175" \
          --names "BACKEND-CG,FRONTEND-CG" \
          --prefix-colors "yellow,magenta"
      ''} $out/bin/start-ngologistics-cg
      
      # Create stop script
      makeWrapper ${pkgs.writeShellScript "stop-ngologistics-cg" ''
        echo "Stopping NGO Logistics CG..."
        pkill -f "mariadbd.*3307"
        pkill -f "node.*Backend"
        pkill -f "vite.*5175"
      ''} $out/bin/stop-ngologistics-cg
      
      # Create setup script
      makeWrapper ${pkgs.writeShellScript "setup-ngologistics-cg" ''
        cd $out/share/ngologistics-cg
        ${pkgs.nodejs_20}/bin/npm install
        echo "NGO Logistics CG setup complete!"
        echo "Run: start-ngologistics-cg"
      ''} $out/bin/setup-ngologistics-cg
    '';
  };
in
{
  home.packages = [ ngologistics-cg ];
}
