#!/bin/bash

# Quick Start Guide for NGO Logistics Systems

echo "=== NGO Logistics Systems Quick Start ==="
echo ""

# Create project directories if they don't exist
mkdir -p ~/projects/ngologistics-d
mkdir -p ~/projects/ngologistics-cg

echo "1. First, apply the Home Manager configuration:"
echo "   home-manager switch"
echo ""

echo "2. Then navigate to the project directories:"
echo "   For NGO Logistics D:"
echo "   cd ~/projects/ngologistics-d"
echo "   npm run setup"
echo "   npm run dev"
echo ""
echo "   For NGO Logistics CG:"
echo "   cd ~/projects/ngologistics-cg" 
echo "   npm run setup"
echo "   npm run dev"
echo ""

echo "3. Or use the Nix commands (after home-manager switch):"
echo "   start-ngologistics-d    # Start D system only"
echo "   start-ngologistics-cg   # Start CG system only"
echo "   start-all-ngologistics  # Start both systems"
echo ""

echo "4. Access points:"
echo "   NGO Logistics D: http://localhost:5174"
echo "   NGO Logistics CG: http://localhost:5175"
echo ""

echo "5. Default credentials for both:"
echo "   Email: admin@example.org"
echo "   Password: password123"
