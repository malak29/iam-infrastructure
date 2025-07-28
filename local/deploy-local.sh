#!/bin/bash

# IAM Microservices Startup Script
# This script starts all infrastructure services for the IAM microservices project

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[IAM-SERVICES]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [[ ! -f "docker-compose.yml" ]]; then
    print_error "docker-compose.yml not found! Please run this script from the iam-infrastructure directory."
    exit 1
fi

# Check if environment file exists
ENV_FILE="../env/.env.local"
if [[ ! -f "$ENV_FILE" ]]; then
    print_error "Environment file not found at $ENV_FILE"
    print_warning "Please ensure the environment file exists before running this script."
    exit 1
fi

print_status "Starting IAM microservices infrastructure..."
print_status "Using environment file: $ENV_FILE"

# Run docker-compose with the specified environment file
print_status "Executing: docker-compose --env-file $ENV_FILE up -d"



if docker-compose --env-file "$ENV_FILE" up -d; then
    print_success "All services started successfully!"
    echo
    print_status "Services Status:"
    docker-compose ps
    echo
    print_status "To view logs: docker-compose logs -f [service-name]"
    print_status "To stop services: docker-compose down"
    print_status "To stop and remove volumes: docker-compose down -v"
else
    print_error "Failed to start services. Check the output above for details."
    exit 1
fi

# if docker exec -i iam-postgres psql -U iam_malak -d iam_db < ../../iam-database-postgres/init/03-initial-seed.sql; then
#     print_success "All seed initialized successfully!"

# else
#     print_error "Failed to seed."
#     exit 1
# fi