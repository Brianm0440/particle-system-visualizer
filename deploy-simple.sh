#!/bin/bash

# 🚀 Simple Google Cloud Run Deployment
# Uses a basic Node.js container

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying to Google Cloud Run (Simple)...${NC}"

# Configuration
PROJECT_ID="cursor-468420"
SERVICE_NAME="particle-system-visualizer"
REGION="us-central1"

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ Google Cloud CLI not found${NC}"
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo -e "${YELLOW}🔐 Please authenticate with Google Cloud...${NC}"
    gcloud auth login
fi

# Set project
echo -e "${BLUE}📋 Setting project to: $PROJECT_ID${NC}"
gcloud config set project $PROJECT_ID

# Enable required APIs
echo -e "${YELLOW}🔧 Enabling required APIs...${NC}"
gcloud services enable run.googleapis.com

# Deploy using a simple approach
echo -e "${BLUE}🏗️ Deploying to Cloud Run...${NC}"
gcloud run deploy $SERVICE_NAME \
    --image node:18-alpine \
    --region $REGION \
    --platform managed \
    --allow-unauthenticated \
    --port 8080 \
    --memory 512Mi \
    --cpu 1 \
    --max-instances 10 \
    --set-env-vars NODE_ENV=production \
    --add-cloudsql-instances="" \
    --no-cpu-throttling

echo -e "${GREEN}✅ Deployment initiated!${NC}"
echo ""
echo -e "${YELLOW}📝 To check deployment status:${NC}"
echo "   gcloud run services list --region=$REGION"
echo ""
echo -e "${YELLOW}📊 To view logs:${NC}"
echo "   gcloud run logs read $SERVICE_NAME --region=$REGION"
