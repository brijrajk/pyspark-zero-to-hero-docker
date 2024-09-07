#!/bin/bash

set -e

# Define your GitHub repository URL and directories
REPO_URL="https://github.com/brijrajk/docker-spark.git"
REPO_DIR="docker-spark"

git pull
git submodule update --init --recursive
# Clone or pull the repository
if [ -d "$REPO_DIR" ]; then
    echo "Repository already exists. Pulling the latest changes..."
    cd $REPO_DIR
    git pull
else
    echo "Cloning the repository from $REPO_URL..."
    git clone $REPO_URL
    cd $REPO_DIR
fi



# Build Docker images
echo "Building Docker images..."
./build.sh


cd ..

# Run docker-compose
echo "Starting services with Docker Compose..."
docker-compose up --build

echo "Setup complete. Spark cluster is up and running!"

