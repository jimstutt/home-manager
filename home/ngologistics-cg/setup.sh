#!/bin/bash

# NGO Logistics CG Setup Script
# Run this from ~/projects/ngologistics-cg

echo "Setting up NGO Logistics CG (WebAssembly + MariaDB)..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "Error: Please run this script from the ngologistics-cg project directory"
    echo "Current directory: $(pwd)"
    echo "Expected package.json in: ~/projects/ngologistics-cg/"
    exit 1
fi

# Install dependencies
echo "Installing Node.js dependencies..."
npm install

# Create environment files
echo "Creating environment configuration..."

# Backend .env
cat > Backend/.env << 'EOF'
NODE_ENV=development
PORT=5002
DB_PORT=3307
DB_HOST=localhost
DB_TYPE=mariadb
DB_NAME=NGOLogisticsCG
JWT_SECRET=ngologistics_cg_super_secret_key_2024
JWT_EXPIRES_IN=90d
EOF

# Frontend .env
cat > Frontend/.env << 'EOF'
VITE_API_URL=http://localhost:5002
VITE_APP_NAME="NGO Logistics CG"
EOF

echo "Setup complete!"
echo ""
echo "To start the development servers:"
echo "  npm run dev    # From ~/projects/ngologistics-cg/"
echo ""
echo "Or use the Nix commands:"
echo "  start-ngologistics-cg"
