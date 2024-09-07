# Define your GitHub repository URL and directories
$repoUrl = "https://github.com/brijrajk/docker-spark.git"
$repoDir = "docker-spark"

# Function to handle errors
function ExitWithError {
    param (
        [string]$message
    )
    Write-Error $message
    exit 1
}

# Clone or pull the repository
if (Test-Path $repoDir) {
    Write-Output "Repository already exists. Pulling the latest changes..."
    try {
        git pull
        git submodule update --init --recursive
        Set-Location $repoDir
    } catch {
        ExitWithError "Failed to pull the repository or update submodules. Please check your Git setup."
    }
} else {
    Write-Output "Cloning the repository from $repoUrl..."
    try {
        git clone --recurse-submodules $repoUrl
        Set-Location $repoDir
    } catch {
        ExitWithError "Failed to clone the repository. Please check your Git setup."
    }
}

# Build Docker images
Write-Output "Building Docker images..."
try {
    ./build.ps1
} catch {
    ExitWithError "Failed to build Docker images. Please check your build script."
}

# Navigate back to the parent directory
Set-Location ..

# Run docker-compose
Write-Output "Starting services with Docker Compose..."
try {
    docker-compose up --build
} catch {
    ExitWithError "Failed to start services with Docker Compose. Please check your Docker setup."
}

Write-Output "Setup complete. Spark cluster is up and running!"
