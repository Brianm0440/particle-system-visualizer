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
        this.trailLength = 10; // New: trail length for particles
        
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
            
            // Wrap around screen
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
        
        // Draw particles
        if (this.particles.length > 0) {
            this.particles.forEach((particle, index) => {
                particle.draw(this.ctx);
            });
        } else {
            console.log('No particles to draw!');
        }
        
        // Draw connections between nearby particles
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
        
        // FPS calculation
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
        this.trail = []; // New: particle trail
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
            case 'aurora': // New: Aurora color scheme
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