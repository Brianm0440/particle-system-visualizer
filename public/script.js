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
        this.trailLength = 15; // Increased trail length for better visual effect
        this.connectionDistance = 150; // Distance for particle connections
        
        // Ensure canvas is properly initialized
        if (!this.ctx) {
            console.error('Could not get 2D context from canvas');
            return;
        }
        
        console.log('ParticleSystem initialized with canvas:', canvas);
        this.init();
        this.setupEventListeners();
        this.animate();
    }
    
    init() {
        this.resize();
        this.createParticles();
        console.log('ParticleSystem initialized with', this.particles.length, 'particles');
    }
    
    resize() {
        // Get the actual display size of the canvas
        const rect = this.canvas.getBoundingClientRect();
        this.canvas.width = rect.width || window.innerWidth;
        this.canvas.height = rect.height || window.innerHeight;
        
        // Set the canvas size to match the display size
        this.canvas.style.width = this.canvas.width + 'px';
        this.canvas.style.height = this.canvas.height + 'px';
        
        this.centerX = this.canvas.width / 2;
        this.centerY = this.canvas.height / 2;
        
        console.log('Canvas resized to:', this.canvas.width, 'x', this.canvas.height);
    }
    
    createParticles() {
        this.particles = [];
        for (let i = 0; i < this.particleCount; i++) {
            // Ensure particles are within canvas bounds
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
        console.log('Created', this.particles.length, 'particles');
    }
    
    setupEventListeners() {
        // Particle count control
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
        
        // Speed control
        const speedSlider = document.getElementById('particleSpeed');
        const speedValue = document.getElementById('particleSpeedValue');
        
        if (speedSlider) {
            speedSlider.addEventListener('input', (e) => {
                this.speed = parseFloat(e.target.value);
                speedValue.textContent = this.speed.toFixed(1);
            });
        }
        
        // Size control
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
        
        // Color scheme control
        const colorSchemeSelect = document.getElementById('colorScheme');
        if (colorSchemeSelect) {
            colorSchemeSelect.addEventListener('change', (e) => {
                this.colorScheme = e.target.value;
                this.particles.forEach(particle => {
                    particle.updateColor(this.colorScheme);
                });
            });
        }
        
        // Reset button
        const resetBtn = document.getElementById('resetBtn');
        if (resetBtn) {
            resetBtn.addEventListener('click', () => {
                this.createParticles();
            });
        }
        
        // Pause button
        const pauseBtn = document.getElementById('pauseBtn');
        if (pauseBtn) {
            pauseBtn.addEventListener('click', () => {
                this.isPaused = !this.isPaused;
                pauseBtn.textContent = this.isPaused ? 'Resume' : 'Pause';
            });
        }
        
        // Window resize
        window.addEventListener('resize', () => {
            this.resize();
            this.createParticles();
        });
    }
    
    update(deltaTime) {
        if (this.isPaused) return;
        
        this.particles.forEach(particle => {
            particle.update(deltaTime * this.speed);
        });
    }
    
    draw() {
        // Clear canvas with a subtle fade effect
        this.ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
        
        // Draw connections between nearby particles
        this.drawConnections();
        
        // Draw particles
        this.particles.forEach(particle => {
            particle.draw(this.ctx);
        });
    }
    
    drawConnections() {
        this.ctx.strokeStyle = 'rgba(255, 255, 255, 0.1)';
        this.ctx.lineWidth = 0.5;
        
        for (let i = 0; i < this.particles.length; i++) {
            for (let j = i + 1; j < this.particles.length; j++) {
                const dx = this.particles[i].x - this.particles[j].x;
                const dy = this.particles[i].y - this.particles[j].y;
                const distance = Math.sqrt(dx * dx + dy * dy);
                
                if (distance < this.connectionDistance) {
                    const alpha = 1 - (distance / this.connectionDistance);
                    this.ctx.strokeStyle = `rgba(255, 255, 255, ${alpha * 0.1})`;
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
        
        // Update FPS counter
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
    constructor(x, y, z, size, colorScheme, trailLength = 15) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.vx = (Math.random() - 0.5) * 2;
        this.vy = (Math.random() - 0.5) * 2;
        this.vz = (Math.random() - 0.5) * 2;
        this.size = size;
        this.colorScheme = colorScheme;
        this.trail = [];
        this.trailLength = trailLength;
        this.life = Math.random() * Math.PI * 2;
        this.maxLife = Math.PI * 2;
        this.sparkleTimer = 0;
        
        this.updateColor(colorScheme);
    }
    
    updateColor(scheme) {
        this.colorScheme = scheme;
        switch (scheme) {
            case 'rainbow':
                this.color = `hsl(${Math.random() * 360}, 80%, 60%)`;
                break;
            case 'fire':
                const fireColors = ['#ff4500', '#ff6347', '#ff7f50', '#ff8c00', '#ffa500'];
                this.color = fireColors[Math.floor(Math.random() * fireColors.length)];
                break;
            case 'ocean':
                const oceanColors = ['#00bfff', '#1e90ff', '#4169e1', '#4682b4', '#5f9ea0'];
                this.color = oceanColors[Math.floor(Math.random() * oceanColors.length)];
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
            case 'galaxy': // New: Galaxy color scheme
                const galaxyColors = [
                    '#4b0082', '#8a2be2', '#9370db', '#ba55d3', '#dda0dd',
                    '#e6e6fa', '#f8f8ff', '#fff0f5', '#ffe4e1', '#ffb6c1'
                ];
                this.color = galaxyColors[Math.floor(Math.random() * galaxyColors.length)];
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
        
        // Update sparkle timer
        this.sparkleTimer += deltaTime;
        
        // Wrap around screen edges
        if (this.x < 0) this.x = window.innerWidth;
        if (this.x > window.innerWidth) this.x = 0;
        if (this.y < 0) this.y = window.innerHeight;
        if (this.y > window.innerHeight) this.y = 0;
    }
    
    draw(ctx) {
        // Draw trail with enhanced glow effect
        this.trail.forEach((point, index) => {
            const alpha = point.alpha * 0.4;
            const size = Math.max(1, this.size * point.alpha * 0.8);
            
            ctx.save();
            ctx.globalAlpha = alpha;
            
            // Enhanced glow effect for trail
            const gradient = ctx.createRadialGradient(point.x, point.y, 0, point.x, point.y, size * 3);
            gradient.addColorStop(0, this.color);
            gradient.addColorStop(1, 'transparent');
            
            ctx.fillStyle = gradient;
            ctx.beginPath();
            ctx.arc(point.x, point.y, size * 3, 0, Math.PI * 2);
            ctx.fill();
            
            ctx.restore();
        });
        
        // Draw main particle with enhanced effects
        const alpha = 1.0;
        const size = Math.max(2, this.size);
        
        ctx.save();
        ctx.globalAlpha = alpha;
        
        // Enhanced glow effect
        const glowGradient = ctx.createRadialGradient(this.x, this.y, 0, this.x, this.y, size * 4);
        glowGradient.addColorStop(0, this.color);
        glowGradient.addColorStop(0.5, this.color + '80');
        glowGradient.addColorStop(1, 'transparent');
        
        ctx.fillStyle = glowGradient;
        ctx.beginPath();
        ctx.arc(this.x, this.y, size * 4, 0, Math.PI * 2);
        ctx.fill();
        
        // Main particle
        ctx.fillStyle = this.color;
        ctx.beginPath();
        ctx.arc(this.x, this.y, size, 0, Math.PI * 2);
        ctx.fill();
        
        // Sparkle effect
        if (this.sparkleTimer > 2000 && Math.random() < 0.1) {
            ctx.save();
            ctx.globalAlpha = 0.8;
            ctx.strokeStyle = '#ffffff';
            ctx.lineWidth = 1;
            ctx.beginPath();
            ctx.moveTo(this.x - size * 2, this.y);
            ctx.lineTo(this.x + size * 2, this.y);
            ctx.moveTo(this.x, this.y - size * 2);
            ctx.lineTo(this.x, this.y + size * 2);
            ctx.stroke();
            ctx.restore();
            this.sparkleTimer = 0;
        }
        
        ctx.restore();
    }
}

// Initialize the particle system when the page loads
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM loaded, initializing particle system...');
    const canvas = document.getElementById('particleCanvas');
    if (canvas) {
        console.log('Canvas found:', canvas);
        // Ensure canvas is visible and properly sized
        canvas.style.display = 'block';
        canvas.style.position = 'absolute';
        canvas.style.top = '0';
        canvas.style.left = '0';
        canvas.style.width = '100%';
        canvas.style.height = '100%';
        canvas.style.zIndex = '1';
        
        new ParticleSystem(canvas);
    } else {
        console.error('Canvas element not found!');
    }
}); 