# 🚀 Google Cloud Run Deployment Guide

## 🎯 **Perfect Solution: Build in Cursor → Deploy to Google Cloud → Behind Google Credentials**

This solution gives you exactly what you want:
- ✅ **Build applications in Cursor**
- ✅ **Deploy directly to Google Cloud**
- ✅ **Behind Google credentials**
- ✅ **Live updates with one command**

## 🏗️ **Architecture**

```
Cursor (Development) → Google Cloud Run → Authenticated Users
```

- **Frontend**: Your HTML/CSS/JS files served by Node.js
- **Backend**: Express.js server with authentication
- **Deployment**: Google Cloud Run with automatic scaling
- **Authentication**: Google Cloud Run built-in auth

## 🚀 **Quick Start**

### Step 1: Deploy Your Application
```bash
./deploy-cloud-run.sh
```

### Step 2: Access Your Application
- Visit the provided URL
- Log in with your Google account
- Enjoy your 3D Particle System!

## 📁 **Project Structure**

```
your-project/
├── public/                 # Static files served by the app
│   ├── index.html         # Your main HTML file
│   ├── script.js          # Your JavaScript
│   └── styles.css         # Your CSS
├── server.js              # Express.js server
├── package.json           # Node.js dependencies
├── Dockerfile             # Container configuration
└── deploy-cloud-run.sh    # Deployment script
```

## 🔄 **Development Workflow**

### 1. **Make Changes in Cursor**
Edit your files in the `public/` directory:
- `public/index.html`
- `public/script.js`
- `public/styles.css`

### 2. **Deploy with One Command**
```bash
./deploy-cloud-run.sh
```

### 3. **See Changes Live**
Your application updates immediately with all your new features!

## 🔐 **Authentication**

Your application is automatically protected by Google Cloud Run authentication:

- **Development**: Accessible locally for testing
- **Production**: Requires Google account login
- **Team Access**: Share URL with your Google Workspace team
- **Security**: Built-in rate limiting and security headers

## 🎨 **Features Included**

Your 3D Particle System Visualizer includes:
- ✨ **Particle trails** - Beautiful fading trails
- 🌈 **Multiple color schemes** - Rainbow, Fire, Ocean, Neon, Aurora
- ⚡ **Real-time controls** - Adjust speed, size, count
- 🔄 **Live updates** - Deploy changes instantly
- 🔐 **Secure access** - Google authentication required

## 📊 **Monitoring & Management**

### View Logs
```bash
gcloud run logs read particle-system-visualizer --region=us-central1
```

### Check Service Status
```bash
gcloud run services list --region=us-central1
```

### Update Configuration
```bash
gcloud run services update particle-system-visualizer --region=us-central1
```

## 💰 **Cost Optimization**

Google Cloud Run is very cost-effective:
- **Free tier**: 2 million requests/month
- **Pay per use**: Only pay when your app is accessed
- **Auto-scaling**: Scales to zero when not in use
- **No server management**: Fully managed by Google

## 🔧 **Customization**

### Environment Variables
Add to `deploy-cloud-run.sh`:
```bash
--set-env-vars KEY=VALUE
```

### Resource Limits
Modify in `deploy-cloud-run.sh`:
```bash
--memory 1Gi --cpu 2 --max-instances 20
```

### Custom Domain
```bash
gcloud run domain-mappings create --service=particle-system-visualizer --domain=your-domain.com
```

## 🚨 **Troubleshooting**

### Common Issues

1. **Authentication Error**
   - Ensure you're logged into Google Cloud
   - Check project permissions

2. **Deployment Fails**
   - Verify all files are in `public/` directory
   - Check `package.json` dependencies

3. **App Not Loading**
   - Check Cloud Run logs
   - Verify service is running

### Debug Commands
```bash
# Check service status
gcloud run services describe particle-system-visualizer --region=us-central1

# View recent logs
gcloud run logs read particle-system-visualizer --region=us-central1 --limit=50

# Test locally
npm install && npm start
```

## 🎯 **Next Steps**

1. **Deploy your application**: `./deploy-cloud-run.sh`
2. **Share with your team**: Send them the Cloud Run URL
3. **Make updates**: Edit files and redeploy
4. **Monitor usage**: Check logs and metrics

## ✨ **Benefits of This Approach**

- **Perfect Integration**: Works seamlessly with your Google Workspace
- **Professional Hosting**: Google Cloud infrastructure
- **Automatic Scaling**: Handles any amount of traffic
- **Cost Effective**: Pay only for what you use
- **Secure**: Built-in authentication and security
- **Easy Updates**: One command to deploy changes

This solution gives you the exact workflow you wanted: build in Cursor, deploy to Google Cloud, and access behind Google credentials!
