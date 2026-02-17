#!/bin/bash

set -e

echo "Installing dependencies..."

apt-get update -y

apt-get install -y \
    curl \
    git \
    build-essential

echo "Dependencies installed successfully!"