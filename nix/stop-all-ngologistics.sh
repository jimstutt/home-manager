#!/bin/bash

# Stop both NGO Logistics systems

echo "Stopping all NGO Logistics systems..."

# Stop NGO Logistics D
stop-ngologistics-d

# Stop NGO Logistics CG  
stop-ngologistics-cg

echo "All NGO Logistics systems stopped."
