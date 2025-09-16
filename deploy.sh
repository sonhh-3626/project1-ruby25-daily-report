#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting deployment...${NC}"

# Pull latest code
echo -e "${YELLOW}Pulling latest code...${NC}"
git pull origin main

# Build and restart containers
echo -e "${YELLOW}Building and restarting containers...${NC}"
sudo docker-compose down
sudo docker-compose build --no-cache
sudo docker-compose up -d

# Run database migrations
echo -e "${YELLOW}Running database migrations...${NC}"
sudo docker-compose exec web bundle exec rails db:migrate RAILS_ENV=production

# Restart nginx
echo -e "${YELLOW}Restarting nginx...${NC}"
sudo docker-compose restart nginx

# Check if services are running
echo -e "${YELLOW}Checking services status...${NC}"
sudo docker-compose ps

echo -e "${GREEN}Deployment completed!${NC}"
