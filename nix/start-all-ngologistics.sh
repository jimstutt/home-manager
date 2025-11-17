#!/bin/bash

# Start both NGO Logistics systems without interference

echo "Starting both NGO Logistics systems..."

# Function to check port availability
check_port() {
    if lsof -Pi :$1 -sTCP:LISTEN -t >/dev/null ; then
        echo "Port $1 is already in use!"
        return 1
    fi
    return 0
}

# Check all required ports
echo "Checking port availability..."
ports=(5174 5175 5001 5002 27018 3307)
for port in "''${ports[@]}"; do
    if ! check_port $port; then
        echo "Please stop services using these ports and try again."
        exit 1
    fi
done

echo "All ports available. Starting systems..."

# Start NGO Logistics D in background
echo "Starting NGO Logistics D..."
start-ngologistics-d &

# Wait a moment for services to initialize
sleep 5

# Start NGO Logistics CG in background  
echo "Starting NGO Logistics CG..."
start-ngologistics-cg &

echo ""
echo "Both systems started successfully!"
echo ""
echo "=== NGO Logistics D (Node.js + MongoDB) ==="
echo "Frontend: http://localhost:5174"
echo "Backend:  http://localhost:5001"
echo "MongoDB:  localhost:27018"
echo ""
echo "=== NGO Logistics CG (WebAssembly + MariaDB) ==="
echo "Frontend: http://localhost:5175"
echo "Backend:  http://localhost:5002"
echo "MariaDB:  localhost:3307"
echo ""
echo "To stop all systems: stop-all-ngologistics"
echo "To stop individually: stop-ngologistics-d or stop-ngologistics-cg"
