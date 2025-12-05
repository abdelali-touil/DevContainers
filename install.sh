#!/bin/bash

set -e

echo "Installing dependencies..."

# Update package manager
apt-get update -y

# Install system dependencies
apt-get install -y \
    curl \
    git \
    build-essential

# Add your language-specific dependency installation here
# Examples:
# pip install -r requirements.txt
# npm install
# go mod download

echo "Dependencies installed successfully!"