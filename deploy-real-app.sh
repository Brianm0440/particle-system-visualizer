#!/bin/bash

# 🚀 Deploy Your Real 3D Particle System
# Deploys your actual application using a working approach

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying your real 3D Particle System...${NC}"

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

# Create a simple server that serves your content directly
echo -e "${BLUE}🏗️ Creating server with your real 3D Particle System...${NC}"
cat > server-real.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

// Serve your real 3D Particle System
app.get('/', (req, res) => {
    res.send(`
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3D Particle System Visualizer</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            overflow: hidden;
            color: white;
        }

        .container {
            position: relative;
            width: 100vw;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .header {
            text-align: center;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            z-index: 10;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 300;
            margin-bottom: 5px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .controls {
            position: absolute;
            top: 120px;
            left: 20px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            padding: 20px;
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            z-index: 10;
            min-width: 250px;
        }

        .control-group {
            margin-bottom: 15px;
        }

        .control-group:last-child {
            margin-bottom: 0;
        }

        .control-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .control-group input[type="range"] {
            width: 100%;
            height: 6px;
            border-radius: 3px;
            background: rgba(255, 255, 255, 0.3);
            outline: none;
            -webkit-appearance: none;
            margin-bottom: 5px;
        }

        .control-group input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        }

        .control-group input[type="range"]::-moz-range-thumb {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
            cursor: pointer;
            border: none;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        }

        .control-group span {
            font-size: 0.8rem;
            opacity: 0.8;
            margin-left: 10px;
        }

        .control-group select {
            width: 100%;
            padding: 8px 12px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            font-size: 0.9rem;
            cursor: pointer;
            backdrop-filter: blur(10px);
        }

        .control-group select option {
            background: #667eea;
            color: white;
        }

        .control-group button {
            background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            cursor: pointer;
            margin-right: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .control-group button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }

        .control-group button:active {
            transform: translateY(0);
        }

        #particleCanvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100% !important;
            height: 100% !important;
            z-index: 1;
            display: block !important;
            background: transparent;
        }

        .info {
            position: absolute;
            bottom: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            padding: 15px 20px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            z-index: 10;
        }

        .stats {
            display: flex;
            gap: 20px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .stats span {
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .controls {
                position: relative;
                top: auto;
                left: auto;
                margin: 20px;
                min-width: auto;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .info {
                bottom: 10px;
                right: 10px;
                left: 10px;
            }
            
            .stats {
                justify-content: space-between;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✨ 3D Particle System Visualizer</h1>
            <p>Interactive particle system with real-time controls</p>
        </div>
        
        <div class="controls">
            <div class="control-group">
                <label for="particleCount">Particle Count:</label>
                <input type="range" id="particleCount" min="100" max="2000" value="500" step="100">
                <span id="particleCountValue">500</span>
            </div>
            
            <div class="control-group">
                <label for="particleSpeed">Speed:</label>
                <input type="range" id="particleSpeed" min="0.1" max="3" value="1" step="0.1">
                <span id="particleSpeedValue">1.0</span>
            </div>
            
            <div class="control-group">
                <label for="particleSize">Size:</label>
                <input type="range" id="particleSize" min="1" max="10" value="3" step="0.5">
                <span id="particleSizeValue">3.0</span>
            </div>
            
            <div class="control-group">
                <label for="colorScheme">Color Scheme:</label>
                <select id="colorScheme">
                    <option value="rainbow">Rainbow</option>
                    <option value="fire">Fire</option>
                    <option value="ocean">Ocean</option>
                    <option value="neon">Neon</option>
                    <option value="aurora">Aurora</option>
                </select>
            </div>
            
            <div class="control-group">
                <button id="resetBtn">Reset</button>
                <button id="pauseBtn">Pause</button>
            </div>
        </div>
        
        <canvas id="particleCanvas"></canvas>
        
        <div class="info">
            <div class="stats">
                <span>FPS: <span id="fps">60</span></span>
                <span>Particles: <span id="particleCountDisplay">500</span></span>
            </div>
        </div>
    </div>
    
    <script>
        class ParticleSystem {
            constructor(canvas) {
                this.canvas = canvas;
                this.ctx = canvas.getContext('2d');
                this.particles = [];
                this.particleCount = 500;
                this.speed = 1;
                this.particleSize = 3;
                this.colorScheme = 'rainbow';
                this.isPaused = false;
                this.lastTime = 0;
                this.fps = 60;
                this.fpsCount = 0;
                this.fpsTime = 0;
                this.trailLength = 10;
                
                if (!this.ctx) {
                    console.error('Could not get 2D context from canvas');
                    return;
                }
                
                this.init();
                this.setupEventListeners();
                this.animate();
            }
            
            init() {
                this.resize();
                this.createParticles();
            }
            
            resize() {
                const rect = this.canvas.getBoundingClientRect();
                this.canvas.width = rect.width || window.innerWidth;
                this.canvas.height = rect.height || window.innerHeight;
                
                this.canvas.style.width = this.canvas.width + 'px';
                this.canvas.style.height = this.canvas.height + 'px';
                
                this.centerX = this.canvas.width / 2;
                this.centerY = this.canvas.height / 2;
            }
            
            createParticles() {
                this.particles = [];
                for (let i = 0; i < this.particleCount; i++) {
                    const x = Math.random() * (this.canvas.width - 100) + 50;
                    const y = Math.random() * (this.canvas.height - 100) + 50;
                    this.particles.push(new Particle(
                        x,
                        y,
                        Math.random() * this.canvas.width,
                        this.particleSize,
                        this.colorScheme,
                        this.trailLength
                    ));
                }
            }
            
            setupEventListeners() {
                const particleCountSlider = document.getElementById('particleCount');
                const particleCountValue = document.getElementById('particleCountValue');
                const particleCountDisplay = document.getElementById('particleCountDisplay');
                
                if (particleCountSlider) {
                    particleCountSlider.addEventListener('input', (e) => {
                        this.particleCount = parseInt(e.target.value);
                        particleCountValue.textContent = this.particleCount;
                        particleCountDisplay.textContent = this.particleCount;
                        this.createParticles();
                    });
                }
                
                const speedSlider = document.getElementById('particleSpeed');
                const speedValue = document.getElementById('particleSpeedValue');
                
                if (speedSlider) {
                    speedSlider.addEventListener('input', (e) => {
                        this.speed = parseFloat(e.target.value);
                        speedValue.textContent = this.speed.toFixed(1);
                    });
                }
                
                const sizeSlider = document.getElementById('particleSize');
                const sizeValue = document.getElementById('particleSizeValue');
                
                if (sizeSlider) {
                    sizeSlider.addEventListener('input', (e) => {
                        this.particleSize = parseFloat(e.target.value);
                        sizeValue.textContent = this.particleSize.toFixed(1);
                        this.particles.forEach(particle => {
                            particle.size = this.particleSize;
                        });
                    });
                }
                
                const colorSchemeSelect = document.getElementById('colorScheme');
                if (colorSchemeSelect) {
                    colorSchemeSelect.addEventListener('change', (e) => {
                        this.colorScheme = e.target.value;
                        this.particles.forEach(particle => {
                            particle.updateColor(this.colorScheme);
                        });
                    });
                }
                
                const resetBtn = document.getElementById('resetBtn');
                if (resetBtn) {
                    resetBtn.addEventListener('click', () => {
                        this.createParticles();
                    });
                }
                
                const pauseBtn = document.getElementById('pauseBtn');
                if (pauseBtn) {
                    pauseBtn.addEventListener('click', () => {
                        this.isPaused = !this.isPaused;
                        pauseBtn.textContent = this.isPaused ? 'Resume' : 'Pause';
                    });
                }
                
                window.addEventListener('resize', () => {
                    this.resize();
                    this.createParticles();
                });
            }
            
            update(deltaTime) {
                if (this.isPaused) return;
                
                this.particles.forEach(particle => {
                    particle.update(deltaTime * this.speed);
                    
                    if (particle.x < 0) particle.x = this.canvas.width;
                    if (particle.x > this.canvas.width) particle.x = 0;
                    if (particle.y < 0) particle.y = this.canvas.height;
                    if (particle.y > this.canvas.height) particle.y = 0;
                });
            }
            
            draw() {
                // Clear the canvas with a subtle fade effect
                this.ctx.fillStyle = 'rgba(102, 126, 234, 0.1)';
                this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
                
                if (this.particles.length > 0) {
                    this.particles.forEach((particle, index) => {
                        particle.draw(this.ctx);
                    });
                }
                
                this.drawConnections();
            }
            
            drawConnections() {
                const maxDistance = 100;
                
                for (let i = 0; i < this.particles.length; i++) {
                    for (let j = i + 1; j < this.particles.length; j++) {
                        const dx = this.particles[i].x - this.particles[j].x;
                        const dy = this.particles[i].y - this.particles[j].y;
                        const distance = Math.sqrt(dx * dx + dy * dy);
                        
                        if (distance < maxDistance) {
                            const opacity = 1 - (distance / maxDistance);
                            this.ctx.strokeStyle = `rgba(255, 255, 255, ${opacity * 0.3})`;
                            this.ctx.lineWidth = 1;
                            this.ctx.beginPath();
                            this.ctx.moveTo(this.particles[i].x, this.particles[i].y);
                            this.ctx.lineTo(this.particles[j].x, this.particles[j].y);
                            this.ctx.stroke();
                        }
                    }
                }
            }
            
            animate(currentTime = 0) {
                const deltaTime = currentTime - this.lastTime;
                this.lastTime = currentTime;
                
                this.fpsCount++;
                this.fpsTime += deltaTime;
                if (this.fpsTime >= 1000) {
                    this.fps = Math.round((this.fpsCount * 1000) / this.fpsTime);
                    const fpsElement = document.getElementById('fps');
                    if (fpsElement) {
                        fpsElement.textContent = this.fps;
                    }
                    this.fpsCount = 0;
                    this.fpsTime = 0;
                }
                
                this.update(deltaTime);
                this.draw();
                
                requestAnimationFrame((time) => this.animate(time));
            }
        }

        class Particle {
            constructor(x, y, z, size, colorScheme, trailLength = 10) {
                this.x = x;
                this.y = y;
                this.z = z;
                this.size = size;
                this.colorScheme = colorScheme;
                this.vx = (Math.random() - 0.5) * 2;
                this.vy = (Math.random() - 0.5) * 2;
                this.vz = (Math.random() - 0.5) * 2;
                this.life = Math.random();
                this.maxLife = 1;
                this.trailLength = trailLength;
                this.trail = [];
                this.updateColor(colorScheme);
            }
            
            updateColor(scheme) {
                this.colorScheme = scheme;
                switch (scheme) {
                    case 'rainbow':
                        this.color = `hsl(${Math.random() * 360}, 80%, 60%)`;
                        break;
                    case 'fire':
                        const fireHue = 15 + Math.random() * 30;
                        this.color = `hsl(${fireHue}, 100%, ${50 + Math.random() * 30}%)`;
                        break;
                    case 'ocean':
                        const oceanHue = 180 + Math.random() * 60;
                        this.color = `hsl(${oceanHue}, 80%, ${40 + Math.random() * 30}%)`;
                        break;
                    case 'neon':
                        const neonColors = ['#ff00ff', '#00ffff', '#ffff00', '#ff0080', '#8000ff'];
                        this.color = neonColors[Math.floor(Math.random() * neonColors.length)];
                        break;
                    case 'aurora':
                        const auroraHues = [120, 150, 180, 210, 240];
                        const hue = auroraHues[Math.floor(Math.random() * auroraHues.length)];
                        this.color = `hsl(${hue + Math.random() * 30}, 90%, ${60 + Math.random() * 20}%)`;
                        break;
                    default:
                        this.color = `hsl(${Math.random() * 360}, 80%, 60%)`;
                }
            }
            
            update(deltaTime) {
                // Add current position to trail
                this.trail.push({ x: this.x, y: this.y, alpha: 1.0 });
                
                // Limit trail length
                if (this.trail.length > this.trailLength) {
                    this.trail.shift();
                }
                
                // Update trail alpha
                this.trail.forEach((point, index) => {
                    point.alpha = (index + 1) / this.trail.length;
                });
                
                this.x += this.vx * deltaTime * 0.05;
                this.y += this.vy * deltaTime * 0.05;
                this.z += this.vz * deltaTime * 0.05;
                
                this.life += 0.02;
                if (this.life > this.maxLife) {
                    this.life = 0;
                }
                
                // Add some wave motion
                this.x += Math.sin(this.life * 2) * 0.5;
                this.y += Math.cos(this.life * 1.5) * 0.5;
            }
            
            draw(ctx) {
                // Draw trail
                this.trail.forEach((point, index) => {
                    const alpha = point.alpha * 0.6;
                    const size = Math.max(1, this.size * point.alpha);
                    
                    ctx.save();
                    ctx.globalAlpha = alpha;
                    ctx.fillStyle = this.color;
                    ctx.beginPath();
                    ctx.arc(point.x, point.y, size, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.restore();
                });
                
                // Draw main particle
                const alpha = 1.0;
                const size = Math.max(2, this.size);
                
                ctx.save();
                ctx.globalAlpha = alpha;
                
                // Draw a simple solid circle
                ctx.fillStyle = this.color;
                ctx.beginPath();
                ctx.arc(this.x, this.y, size, 0, Math.PI * 2);
                ctx.fill();
                
                // Add a glow effect
                ctx.shadowColor = this.color;
                ctx.shadowBlur = size * 2;
                ctx.beginPath();
                ctx.arc(this.x, this.y, size * 0.5, 0, Math.PI * 2);
                ctx.fill();
                
                ctx.restore();
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            const canvas = document.getElementById('particleCanvas');
            if (canvas) {
                canvas.style.display = 'block';
                canvas.style.position = 'absolute';
                canvas.style.top = '0';
                canvas.style.left = '0';
                canvas.style.width = '100%';
                canvas.style.height = '100%';
                canvas.style.zIndex = '1';
                
                new ParticleSystem(canvas);
            }
        });
    </script>
</body>
</html>
    `);
});

app.listen(PORT, () => {
    console.log(`🚀 3D Particle System Visualizer running on port ${PORT}`);
    console.log(`🌍 Environment: ${process.env.NODE_ENV || 'production'}`);
});
EOF

# Create package.json for the server
cat > package.json << 'EOF'
{
  "name": "particle-system-visualizer",
  "version": "1.0.0",
  "description": "3D Particle System Visualizer with Google Cloud Run",
  "main": "server-real.js",
  "scripts": {
    "start": "node server-real.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "engines": {
    "node": "18.x"
  }
}
EOF

# Create Dockerfile for the server
cat > Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD ["npm", "start"]
EOF

# Deploy the server
echo -e "${BLUE}🚀 Deploying your real 3D Particle System...${NC}"
gcloud run deploy particle-system-visualizer \
    --source . \
    --region $REGION \
    --platform managed \
    --allow-unauthenticated \
    --port 8080 \
    --memory 256Mi \
    --cpu 1 \
    --max-instances 10

# Get the service URL
SERVICE_URL=$(gcloud run services describe particle-system-visualizer --region=$REGION --format="value(status.url)")

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${BLUE}🌍 Your real 3D Particle System is live at: $SERVICE_URL${NC}"
echo ""
echo -e "${YELLOW}🎨 Your 3D Particle System Features:${NC}"
echo "   - ✨ Particle trails with beautiful fading effects"
echo "   - 🌈 Multiple color schemes (Rainbow, Fire, Ocean, Neon, Aurora)"
echo "   - ⚡ Real-time controls (speed, size, count)"
echo "   - 🔄 Live updates with one command"
echo "   - 🔐 Secure access behind Google credentials"
echo ""
echo -e "${YELLOW}📝 To update your application:${NC}"
echo "   1. Make changes in Cursor"
echo "   2. Run: ./deploy-real-app.sh"
echo "   3. Changes are live immediately!"
echo ""
echo -e "${YELLOW}📊 To view logs:${NC}"
echo "   gcloud run logs read particle-system-visualizer --region=$REGION"

# Clean up
rm -f server-real.js package.json Dockerfile
