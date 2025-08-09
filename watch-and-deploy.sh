#!/bin/bash

# 👀 File Watcher for Automatic Deployment
# Automatically deploys changes when files are modified

set -e

# Configuration
BUCKET_NAME=$1
WATCH_FILES="index.html script.js styles.css"

if [ -z "$BUCKET_NAME" ]; then
    echo "❌ Please provide the bucket name"
    echo "Usage: ./watch-and-deploy.sh [BUCKET_NAME]"
    echo ""
    echo "To find your bucket name, check deployment-info.txt or run:"
    echo "gsutil ls"
    exit 1
fi

echo "👀 Watching for changes in: $WATCH_FILES"
echo "🔄 Will automatically deploy to: $BUCKET_NAME"
echo "Press Ctrl+C to stop watching"
echo ""

# Function to deploy files
deploy_files() {
    echo "📤 Deploying changes..."
    gsutil -h "Cache-Control:no-cache" cp index.html gs://$BUCKET_NAME/
    gsutil -h "Cache-Control:no-cache" cp script.js gs://$BUCKET_NAME/
    gsutil -h "Cache-Control:no-cache" cp styles.css gs://$BUCKET_NAME/
    echo "✅ Deployed at $(date)"
    echo ""
}

# Check if fswatch is installed
if command -v fswatch >/dev/null 2>&1; then
    echo "🚀 Using fswatch for file watching..."
    fswatch -o . | while read f; do
        deploy_files
    done
else
    echo "⚠️  fswatch not found. Installing..."
    if command -v brew >/dev/null 2>&1; then
        brew install fswatch
        echo "🚀 Using fswatch for file watching..."
        fswatch -o . | while read f; do
            deploy_files
        done
    else
        echo "❌ Please install fswatch manually:"
        echo "   brew install fswatch"
        exit 1
    fi
fi


