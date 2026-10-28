#!/bin/bash

set -e

echo "🐳 Laravel version - Docker Setup"
echo "===================================="

# Build containers
echo ""
echo "📦 Building Docker containers..."
docker compose build

# Start containers
echo ""
echo "🚀 Starting containers..."
docker compose up -d

# Install dependencies
echo ""
echo "📚 Installing Composer dependencies..."
docker compose run --rm php composer install

echo ""
echo "✅ Setup complete!"
echo ""
echo "Available commands:"
echo "  make test          - Run PHPUnit tests"
echo "  make cs-check      - Check code style"
echo "  make cs-fix        - Fix code style"
echo "  make shell         - Access container shell"
echo "  make help          - Show all available commands"
