#!/bin/bash

# 🔄 Update Script for 3D Particle System Visualizer
# Updates an existing Google Cloud Storage deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Starting update process...${NC}"

# Check if bucket name is provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Please provide the bucket name${NC}"
    echo "Usage: ./update.sh [BUCKET_NAME]"
    echo ""
    echo "To find your bucket name, check deployment-info.txt or run:"
    echo "gsutil ls"
    exit 1
fi

BUCKET_NAME=$1

# Check if bucket exists
if ! gsutil ls gs://$BUCKET_NAME > /dev/null 2>&1; then
    echo -e "${RED}❌ Bucket $BUCKET_NAME not found${NC}"
    echo "Available buckets:"
    gsutil ls
    exit 1
fi

echo -e "${GREEN}✅ Found bucket: $BUCKET_NAME${NC}"

# Upload updated files
echo -e "${YELLOW}📤 Uploading updated files...${NC}"
gsutil -h "Cache-Control:no-cache" cp index.html gs://$BUCKET_NAME/
gsutil -h "Cache-Control:no-cache" cp script.js gs://$BUCKET_NAME/
gsutil -h "Cache-Control:no-cache" cp styles.css gs://$BUCKET_NAME/

# Get the public URL
PUBLIC_URL="https://storage.googleapis.com/$BUCKET_NAME/index.html"

echo -e "${GREEN}✅ Update complete!${NC}"
echo -e "${BLUE}🌍 Your updated app is live at: $PUBLIC_URL${NC}"
echo ""
echo -e "${YELLOW}💡 Tip: Hard refresh your browser (Cmd+Shift+R) to see changes${NC}"


