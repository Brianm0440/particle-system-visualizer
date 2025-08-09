# 🚀 Live Deployment Guide for Google Workspace

## Overview
This guide will help you deploy your 3D Particle System Visualizer to a live URL that integrates with your Google Workspace, allowing you to edit in Cursor and see changes immediately.

## 🎯 Recommended Solution: Google Cloud Platform

**Why Google Cloud Platform?**
- ✅ Professional hosting with high performance
- ✅ Integrated with Google Workspace
- ✅ Automatic HTTPS and CDN
- ✅ Easy updates and continuous deployment
- ✅ Free tier available (very cost-effective for static sites)
- ✅ Custom domain support

## 🚀 Quick Start (5 minutes)

### Step 1: Install Google Cloud CLI
```bash
# For macOS
brew install google-cloud-sdk

# For other platforms
# https://cloud.google.com/sdk/docs/install
```

### Step 2: Authenticate and Setup
```bash
# Login to Google Cloud
gcloud auth login

# List your projects
gcloud projects list

# Set your project (replace with your actual project ID)
gcloud config set project YOUR_PROJECT_ID
```

### Step 3: Deploy Your Site
```bash
# Make the script executable
chmod +x deploy.sh

# Run the deployment
./deploy.sh
```

### Step 4: Get Your Live URL
After deployment, you'll get a URL like:
```
https://storage.googleapis.com/particle-system-visualizer-1234567890/index.html
```

## 🔄 Continuous Deployment Options

### Option 1: Manual Updates (Recommended for beginners)
```bash
# Update all files
./update.sh YOUR_BUCKET_NAME

# Update specific file
gsutil cp index.html gs://YOUR_BUCKET_NAME/
```

### Option 2: Automatic File Watching (Advanced)
```bash
# Install fswatch (macOS)
brew install fswatch

# Start watching for changes
./watch-and-deploy.sh YOUR_BUCKET_NAME
```

### Option 3: GitHub Actions (Professional)
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Google Cloud
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: google-github-actions/setup-gcloud@v0
      with:
        project_id: ${{ secrets.GCP_PROJECT_ID }}
        service_account_key: ${{ secrets.GCP_SA_KEY }}
    - run: |
        gsutil cp index.html gs://${{ secrets.BUCKET_NAME }}/
        gsutil cp script.js gs://${{ secrets.BUCKET_NAME }}/
        gsutil cp styles.css gs://${{ secrets.BUCKET_NAME }}/
```

## 🌐 Custom Domain Setup

### Step 1: Add Custom Domain
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Navigate to Cloud Storage > Browser
3. Select your bucket
4. Go to "Permissions" tab
5. Add your domain

### Step 2: Configure DNS
Add a CNAME record pointing to:
```
c.storage.googleapis.com
```

## 📊 Monitoring and Analytics

### Google Analytics Integration
Add this to your `index.html` before `</head>`:
```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

## 🔧 Advanced Configuration

### Performance Optimization
```bash
# Enable compression
gsutil -h "Content-Encoding:gzip" cp index.html gs://YOUR_BUCKET_NAME/

# Set cache headers
gsutil -h "Cache-Control:public,max-age=3600" cp script.js gs://YOUR_BUCKET_NAME/
```

### Security Headers
Create a `cors.json` file:
```json
[
  {
    "origin": ["*"],
    "method": ["GET"],
    "responseHeader": ["Content-Type"],
    "maxAgeSeconds": 3600
  }
]
```

Apply it:
```bash
gsutil cors set cors.json gs://YOUR_BUCKET_NAME
```

## 🎨 Google Workspace Integration

### Option 1: Google Sites Embed
1. Go to [sites.google.com](https://sites.google.com)
2. Create a new site
3. Add an "Embed" element
4. Use your live URL as the source

### Option 2: Google Drive Integration
1. Upload your files to Google Drive
2. Share the folder with your team
3. Use the shared link for access

### Option 3: Google Apps Script
Create a web app that serves your content:
```javascript
function doGet() {
  return HtmlService.createHtmlOutputFromFile('index')
    .setTitle('3D Particle System')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}
```

## 🚨 Troubleshooting

### Common Issues

**1. "Permission denied" error**
```bash
# Re-authenticate
gcloud auth login
gcloud auth application-default login
```

**2. Bucket not found**
```bash
# List all buckets
gsutil ls

# Check bucket permissions
gsutil iam get gs://YOUR_BUCKET_NAME
```

**3. Files not updating**
```bash
# Clear cache headers
gsutil -h "Cache-Control:no-cache" cp index.html gs://YOUR_BUCKET_NAME/

# Force browser refresh (Cmd+Shift+R)
```

**4. CORS issues**
```bash
# Set CORS policy
gsutil cors set cors.json gs://YOUR_BUCKET_NAME
```

## 📈 Cost Optimization

### Free Tier Limits
- 5GB storage
- 1GB/day outbound bandwidth
- 50,000 Class A operations/month
- 5,000 Class B operations/month

### Cost Monitoring
```bash
# Check usage
gcloud billing accounts list
gcloud billing accounts describe ACCOUNT_ID
```

## 🎯 Next Steps

1. **Deploy your site** using the quick start guide above
2. **Set up automatic updates** with file watching
3. **Add custom domain** for professional branding
4. **Integrate analytics** for user insights
5. **Set up monitoring** for performance tracking

## 📞 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review Google Cloud documentation
3. Check browser console for errors
4. Verify file permissions and CORS settings

---

**Ready to deploy?** Run `./deploy.sh` to get started! 🚀


