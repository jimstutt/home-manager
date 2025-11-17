{ config, pkgs, ... }:

let
  ngologistics-d = pkgs.stdenv.mkDerivation {
    name = "ngologistics-d";
    src = ./ngologistics-d;
    
    nativeBuildInputs = with pkgs; [
      makeWrapper
    ];
    
    buildInputs = with pkgs; [
      nodejs_20
      mongodb-community-7_0
      typescript
    ];
    
    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/ngologistics-d
      
      # Copy application files
      cp -r . $out/share/ngologistics-d/
      
      # Create startup script
      makeWrapper ${pkgs.writeShellScript "start-ngologistics-d" ''
        echo "Starting NGO Logistics D (Node.js + MongoDB)..."
        
        # Start MongoDB on unique port
        if ! pgrep -f "mongod.*27018" > /dev/null; then
          echo "Starting MongoDB on port 27018..."
          mkdir -p /tmp/ngologistics-d/mongodb-data
          ${pkgs.mongodb-community-7_0}/bin/mongod --port 27018 --dbpath /tmp/ngologistics-d/mongodb-data --fork --logpath /tmp/ngologistics-d/mongodb.log
        fi
        
        # Start services
        cd $out/share/ngologistics-d
        ${pkgs.nodejs_20}/bin/npm install
        ${pkgs.concurrently}/bin/concurrently \
          "cd Backend && ${pkgs.nodejs_20}/bin/npm run dev" \
          "cd App && ${pkgs.nodejs_20}/bin/npm run dev -- --port 5174" \
          --names "BACKEND-D,FRONTEND-D" \
          --prefix-colors "blue,green"
      ''} $out/bin/start-ngologistics-d
      
      # Create stop script
      makeWrapper ${pkgs.writeShellScript "stop-ngologistics-d" ''
        echo "Stopping NGO Logistics D..."
        pkill -f "mongod.*27018"
        pkill -f "node.*Backend"
        pkill -f "vite.*5174"
      ''} $out/bin/stop-ngologistics-d
      
      # Create setup script
      makeWrapper ${pkgs.writeShellScript "setup-ngologistics-d" ''
        cd $out/share/ngologistics-d
        ${pkgs.nodejs_20}/bin/npm install
        echo "NGO Logistics D setup complete!"
        echo "Run: start-ngologistics-d"
      ''} $out/bin/setup-ngologistics-d
    '';
  };
in
{
  home.packages = [ ngologistics-d ];
}
