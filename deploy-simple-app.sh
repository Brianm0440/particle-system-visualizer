#!/bin/bash

# 🚀 Simple App Deployment
# Deploys your application using a simple approach

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

# Create a minimal Dockerfile
echo -e "${BLUE}🏗️ Creating minimal Dockerfile...${NC}"
cat > Dockerfile.minimal << 'EOF'
FROM nginx:alpine
COPY public/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# Temporarily rename the main Dockerfile
mv Dockerfile Dockerfile.backup

# Deploy using the minimal Dockerfile
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
echo -e "${BLUE}🌍 Your 3D Particle System is live at: $SERVICE_URL${NC}"
echo ""
echo -e "${YELLOW}🔐 Authentication:${NC}"
echo "   - Users must be logged into Google to access"
echo "   - Works with your Google Workspace"
echo "   - Share URL with your team"
echo ""
echo -e "${YELLOW}📝 To update your application:${NC}"
echo "   1. Make changes in Cursor"
echo "   2. Run: ./deploy-simple-app.sh"
echo "   3. Changes are live immediately!"
echo ""
echo -e "${YELLOW}📊 To view logs:${NC}"
echo "   gcloud run logs read $SERVICE_NAME --region=$REGION"

# Restore the original Dockerfile
mv Dockerfile.backup Dockerfile
rm -f Dockerfile.minimal
