#!/bin/bash
# =============================================================================
# Bakery Order and Custom Cake Booking Platform - Startup Script
# =============================================================================

echo "================================================================="
echo "  🍰 Starting Bakery Order & Custom Cake Booking Platform...    "
echo "================================================================="

# Check Java
if ! command -v java &> /dev/null; then
    echo "Error: Java is not installed or not in PATH."
    exit 1
fi

# Check Maven
if ! command -v mvn &> /dev/null; then
    echo "Error: Maven (mvn) is not installed or not in PATH."
    exit 1
fi

# Compile and Launch Embedded Tomcat
mvn clean compile exec:java
