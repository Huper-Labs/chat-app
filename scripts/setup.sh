#!/bin/bash

# Create volume directories
mkdir -p volumes/{postgres,redis,open-webui}

# Copy environment template
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Please edit .env file with your values"
fi

# Pull latest images
docker-compose pull

# Start services
docker-compose up -d

echo "Setup complete! Services starting up..."
echo "Open WebUI will be available at http://localhost:3000"
echo "LiteLLM will be available at http://localhost:4000"