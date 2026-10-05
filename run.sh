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

# Disable macOS AppleDouble file generation on external volumes
export COPYFILE_DISABLE=1

# Remove stray dot-underscore metadata files from workspace
find . -name "._*" -delete 2>/dev/null || true

# Compile
mvn clean compile

# Remove any stray dot-underscore metadata files from target
find target -name "._*" -delete 2>/dev/null || true
find . -name "._*" -delete 2>/dev/null || true

# Launch Embedded Tomcat
mvn exec:java
