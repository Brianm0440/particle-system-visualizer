#!/bin/bash

# 🚀 Authenticated Google Cloud Storage Deployment
# Deploys your app with Google authentication required

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying with Google Authentication...${NC}"

# Configuration
PROJECT_ID="cursor-468420"
BUCKET_NAME="particle-system-visualizer-$(date +%s)"
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
gcloud services enable storage-component.googleapis.com
gcloud services enable storage-api.googleapis.com

# Create bucket
echo -e "${BLUE}📦 Creating bucket: $BUCKET_NAME${NC}"
gsutil mb -p $PROJECT_ID -l $REGION gs://$BUCKET_NAME

# Upload files
echo -e "${BLUE}📤 Uploading files...${NC}"
gsutil -h "Cache-Control:no-cache" cp public/index.html gs://$BUCKET_NAME/
gsutil -h "Cache-Control:no-cache" cp public/script.js gs://$BUCKET_NAME/
gsutil -h "Cache-Control:no-cache" cp public/styles.css gs://$BUCKET_NAME/

# Set bucket to require authentication
echo -e "${BLUE}🔐 Setting up authentication...${NC}"
gsutil iam ch allAuthenticatedUsers:objectViewer gs://$BUCKET_NAME

# Set website configuration
echo -e "${BLUE}⚙️ Configuring website...${NC}"
gsutil web set -m index.html gs://$BUCKET_NAME

# Get the URL
SERVICE_URL="https://storage.googleapis.com/$BUCKET_NAME/index.html"

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${BLUE}🌍 Your app is live at: $SERVICE_URL${NC}"
echo ""
echo -e "${YELLOW}🔐 Authentication:${NC}"
echo "   - Users must be logged into Google to access"
echo "   - Works with your Google Workspace"
echo "   - Share URL with your team"
echo ""
echo -e "${YELLOW}📝 To update your deployment:${NC}"
echo "   ./update.sh $BUCKET_NAME"
echo ""
echo -e "${YELLOW}📊 To view bucket contents:${NC}"
echo "   gsutil ls gs://$BUCKET_NAME"
echo ""
echo -e "${BLUE}💡 Save this bucket name: $BUCKET_NAME${NC}"
