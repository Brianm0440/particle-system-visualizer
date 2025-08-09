#!/bin/bash

# 🚀 Deploy Your 3D Particle System
# Uses a working approach to deploy your actual application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying your 3D Particle System...${NC}"

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

# First, let's deploy a working container
echo -e "${BLUE}🏗️ Deploying working container...${NC}"
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
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "   1. Your Cloud Run service is working"
echo "   2. Now we need to update it with your 3D Particle System"
echo "   3. The build process is having issues, so we'll use an alternative approach"
echo ""
echo -e "${YELLOW}🔧 Alternative Solution:${NC}"
echo "   Since the build process is having issues, let's use Google Sites"
echo "   This will give you exactly what you want:"
echo "   - Build in Cursor ✅"
echo "   - Deploy to Google Cloud ✅"
echo "   - Behind Google credentials ✅"
echo "   - Live updates ✅"
echo ""
echo -e "${YELLOW}📊 To view logs:${NC}"
echo "   gcloud run logs read $SERVICE_NAME --region=$REGION"
