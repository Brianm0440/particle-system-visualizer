const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Serve static files from the public directory
app.use(express.static(path.join(__dirname, 'public')));

// Main route - serve your 3D Particle System
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        message: '3D Particle System Visualizer is running!'
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 3D Particle System Visualizer running on port ${PORT}`);
    console.log(`🌍 Environment: ${process.env.NODE_ENV || 'production'}`);
    console.log(`📁 Serving files from: ${path.join(__dirname, 'public')}`);
});
