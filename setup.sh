#!/bin/bash

# 🎯 Setup Script for Google Cloud Deployment
# Handles initial configuration and deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎯 Setting up Google Cloud deployment...${NC}"

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Google Cloud CLI...${NC}"
    if command -v brew >/dev/null 2>&1; then
        brew install google-cloud-sdk
    else
        echo -e "${RED}❌ Please install Google Cloud CLI manually:${NC}"
        echo "   https://cloud.google.com/sdk/docs/install"
        exit 1
    fi
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo -e "${YELLOW}🔐 Please authenticate with Google Cloud...${NC}"
    gcloud auth login
fi

# List available projects
echo -e "${BLUE}📋 Available projects:${NC}"
gcloud projects list --format="table(projectId,name)"

# Get project ID
if [ -z "$GOOGLE_CLOUD_PROJECT" ]; then
    echo ""
    read -p "Enter your Google Cloud Project ID: " PROJECT_ID
    export GOOGLE_CLOUD_PROJECT=$PROJECT_ID
else
    PROJECT_ID=$GOOGLE_CLOUD_PROJECT
    echo -e "${GREEN}✅ Using project: $PROJECT_ID${NC}"
fi

# Set the project
gcloud config set project $PROJECT_ID

# Enable required APIs
echo -e "${YELLOW}🔧 Enabling required APIs...${NC}"
gcloud services enable storage-component.googleapis.com
gcloud services enable storage-api.googleapis.com

# Make scripts executable
chmod +x deploy.sh
chmod +x update.sh
chmod +x watch-and-deploy.sh

echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo -e "${BLUE}🚀 Ready to deploy! Run:${NC}"
echo "   ./deploy.sh"
echo ""
echo -e "${BLUE}📚 For more information, see:${NC}"
echo "   LIVE_DEPLOYMENT_GUIDE.md"


