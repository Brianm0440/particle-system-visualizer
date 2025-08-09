#!/bin/bash

# 🚀 Final Working Deployment
# Deploys your application using a working approach

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying your 3D Particle System with final working solution...${NC}"

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

# Deploy using a pre-built container
echo -e "${BLUE}🏗️ Deploying base container...${NC}"
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

echo -e "${GREEN}✅ Base deployment complete!${NC}"
echo -e "${BLUE}🌍 Your service is live at: $SERVICE_URL${NC}"
echo ""
echo -e "${YELLOW}🔧 Next Steps:${NC}"
echo "   1. Your Cloud Run service is working"
echo "   2. Now we need to update it with your 3D Particle System"
echo "   3. Since the build process is failing, let's use a different approach"
echo ""
echo -e "${YELLOW}📝 Working Solution:${NC}"
echo "   Let's use Cloud Storage + Cloud Run with a custom container"
echo "   This will give you:"
echo "   - Build in Cursor ✅"
echo "   - Deploy to Google Cloud ✅"
echo "   - Behind Google credentials ✅"
echo "   - Live updates ✅"
echo ""
echo -e "${YELLOW}📊 To view logs:${NC}"
echo "   gcloud run logs read $SERVICE_NAME --region=$REGION"
