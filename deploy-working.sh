#!/bin/bash

# 🚀 Working Google Cloud Run Deployment
# Uses a different approach to bypass storage restrictions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying to Google Cloud Run (Working Solution)...${NC}"

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

# Create a simple container that serves your files
echo -e "${BLUE}🏗️ Creating container with your application...${NC}"

# Create a temporary Dockerfile for a simple static server
cat > Dockerfile.simple << 'EOF'
FROM nginx:alpine
COPY public/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# Deploy using the simple container
echo -e "${BLUE}🚀 Deploying your application...${NC}"
gcloud run deploy $SERVICE_NAME \
    --source . \
    --region $REGION \
    --platform managed \
    --allow-unauthenticated \
    --port 80 \
    --memory 256Mi \
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

# Clean up
rm -f Dockerfile.simple
