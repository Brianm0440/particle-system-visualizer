#!/bin/bash

# 🚀 GitHub Pages Setup Script
# Helps you set up GitHub repository and deploy to GitHub Pages

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up GitHub Pages for your 3D Particle System...${NC}"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git not found${NC}"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Not in a git repository${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Git repository initialized${NC}"

# Get the current directory name
PROJECT_NAME=$(basename "$PWD")
echo -e "${BLUE}📁 Project name: $PROJECT_NAME${NC}"

echo ""
echo -e "${YELLOW}🔧 Next Steps:${NC}"
echo ""
echo -e "${BLUE}1. Create GitHub Repository:${NC}"
echo "   - Go to https://github.com"
echo "   - Click the '+' button → 'New repository'"
echo "   - Name: $PROJECT_NAME"
echo "   - Description: 3D Particle System Visualizer"
echo "   - Choose visibility (Public or Private)"
echo "   - Click 'Create repository'"
echo ""
echo -e "${BLUE}2. Add GitHub Remote:${NC}"
echo "   After creating the repository, run:"
echo "   git remote add origin https://github.com/YOUR_USERNAME/$PROJECT_NAME.git"
echo ""
echo -e "${BLUE}3. Push to GitHub:${NC}"
echo "   git push -u origin main"
echo ""
echo -e "${BLUE}4. Enable GitHub Pages:${NC}"
echo "   - Go to your repository on GitHub"
echo "   - Click 'Settings' tab"
echo "   - Scroll down to 'Pages' section"
echo "   - Source: 'Deploy from a branch'"
echo "   - Branch: 'main'"
echo "   - Folder: '/ (root)'"
echo "   - Click 'Save'"
echo ""
echo -e "${BLUE}5. Access Your Site:${NC}"
echo "   Your site will be available at:"
echo "   https://YOUR_USERNAME.github.io/$PROJECT_NAME"
echo ""
echo -e "${YELLOW}🎯 Authentication Options:${NC}"
echo ""
echo -e "${GREEN}Public Repository:${NC}"
echo "   - Anyone can view your site"
echo "   - No authentication required"
echo "   - Perfect for public demos"
echo ""
echo -e "${GREEN}Private Repository:${NC}"
echo "   - Only repository collaborators can view"
echo "   - GitHub account required"
echo "   - Perfect for private projects"
echo ""
echo -e "${GREEN}Organization Repository:${NC}"
echo "   - Organization members only"
echo "   - GitHub account + organization membership required"
echo "   - Perfect for company/team projects"
echo ""
echo -e "${YELLOW}🔄 Update Process:${NC}"
echo ""
echo "To update your site:"
echo "1. Make changes in Cursor"
echo "2. git add ."
echo "3. git commit -m 'Update: [describe changes]'"
echo "4. git push origin main"
echo "5. GitHub Pages automatically deploys (1-2 minutes)"
echo ""
echo -e "${GREEN}✅ Your perfect workflow will be:${NC}"
echo "   - ✅ Build in Cursor"
echo "   - ✅ Push to GitHub"
echo "   - ✅ Automatic deployment"
echo "   - ✅ Live updates"
echo "   - ✅ Team access (if private repository)"
echo ""
echo -e "${BLUE}🚀 Ready to deploy!${NC}"
