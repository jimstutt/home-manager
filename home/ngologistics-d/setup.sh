#!/bin/bash

# NGO Logistics D Setup Script
# Run this from ~/projects/ngologistics-d

echo "Setting up NGO Logistics D (Node.js + MongoDB)..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "Error: Please run this script from the ngologistics-d project directory"
    echo "Current directory: $(pwd)"
    echo "Expected package.json in: ~/projects/ngologistics-d/"
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
PORT=5001
MONGODB_URI=mongodb://localhost:27018/NGOLogisticsD
JWT_SECRET=ngologistics_d_super_secret_key_2024
JWT_EXPIRES_IN=90d
GOOGLE_MAPS_API_KEY=AIzaSyBTmKzNwMM1OIruKtneSGHYUYbJHMUL6j0
EOF

# Frontend .env
cat > App/.env << 'EOF'
VITE_API_URL=http://localhost:5001
VITE_GOOGLE_MAPS_API_KEY=AIzaSyBTmKzNwMM1OIruKtneSGHYUYbJHMUL6j0
VITE_GOOGLE_MAPS_MAP_ID=1c58c0dd9e35ef9c4882d48a
EOF

echo "Setup complete!"
echo ""
echo "To start the development servers:"
echo "  npm run dev    # From ~/projects/ngologistics-d/"
echo ""
echo "Or use the Nix commands:"
echo "  start-ngologistics-d"

