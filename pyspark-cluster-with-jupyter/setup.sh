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
    
    # Check if we are on a branch or in a detached HEAD state
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$CURRENT_BRANCH" = "HEAD" ]; then
        # Not currently on any branch, switch to the default branch (e.g., main or master)
        echo "Currently not on any branch. Switching to the default branch..."
        git checkout master  # Change "main" to "master" if necessary
    fi
    
    # Pull the latest changes from the current branch
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

