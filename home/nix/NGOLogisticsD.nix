{ config, pkgs, ... }:

let
  NGOLogisticsD-dir = "/home/jim/NGOLogisticsD";
in
{
  # Create the project directory structure
  home.file."${NGOLogisticsD-dir}/.env".text = ''
    VITE_GOOGLE_MAPS_API_KEY=AIzaSyBTmKzNwMM1OIruKtneSGHYUYbJHMUL6j0
    VITE_API_URL=http://localhost:5000
  '';

  home.file."${NGOLogisticsD-dir}/README.md".text = ''
    # NGO Logistics Management System (NGOLogisticsD)
    
    A comprehensive web-based logistics management platform designed specifically for humanitarian organizations operating in East Africa.
    
    ## Quick Start
    
    1. Ensure MongoDB is running: `mongod --dbpath /home/jim/mongodb-data/db`
    2. Start backend: `cd Backend && npm install && npm run dev`
    3. Start frontend: `cd App && npm install && npm run dev`
    4. Access at: http://localhost:5173
    
    Default credentials: admin@example.org / password123
    
    See INSTALL.md for detailed instructions.
  '';

  home.file."${NGOLogisticsD-dir}/INSTALL.md".text = ''
    # Installation Guide - NGOLogisticsD
    
    ## Prerequisites
    - Node.js 14+
    - MongoDB 4.4+
    - Google Maps API Key
    
    ## Platform-Specific Instructions
    
    ### Linux
    ```bash
    # Install Node.js
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    
    # Install MongoDB
    wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    
    # Start MongoDB
    sudo systemctl start mongod
    ```
    
    ### Windows
    1. Download and install Node.js from nodejs.org
    2. Download and install MongoDB Community Server
    3. Run MongoDB as a service
    4. Use PowerShell for all commands
    
    ### macOS
    ```bash
    # Using Homebrew
    brew install node
    brew tap mongodb/brew
    brew install mongodb-community
    brew services start mongodb-community
    ```
    
    ### Android (Termux)
    ```bash
    pkg update && pkg upgrade
    pkg install nodejs mongodb
    mkdir -p ~/data/db
    mongod --dbpath ~/data/db &
    ```
    
    ### iOS (iSH Shell)
    ```bash
    apk update
    apk add nodejs npm
    # MongoDB not available on iOS - use cloud database
    ```
  '';

  # Backend package.json
  home.file."${NGOLogisticsD-dir}/Backend/package.json".text = builtins.toJSON {
    name = "NGOLogisticsD-backend";
    version = "1.0.0";
    type = "module";
    scripts = {
      dev = "node server.js";
      start = "node server.js";
      test = "node test-backend.js";
    };
    dependencies = {
      express = "^4.18.2";
      mongoose = "^8.0.3";
      "socket.io" = "^4.7.4";
      cors = "^2.8.5";
      "dotenv" = "^16.3.1";
      bcryptjs = "^2.4.3";
      "jsonwebtoken" = "^9.0.2";
      helmet = "^7.1.0";
      morgan = "^1.10.0";
      "express-validator" = "^7.0.1";
      compression = "^1.7.4";
      "rate-limiter-flexible" = "^4.0.1";
      nodemailer = "^6.9.7";
      winston = "^3.11.0";
    };
  };

  # Frontend package.json
  home.file."${NGOLogisticsD-dir}/App/package.json".text = builtins.toJSON {
    name = "NGOLogisticsD-frontend";
    version = "1.0.0";
    type = "module";
    scripts = {
      dev = "vite";
      build = "vite build";
      preview = "vite preview";
    };
    dependencies = {
      vue = "^3.3.11";
      "vue-router": "^4.2.5";
      pinia = "^2.1.7";
      axios = "^1.6.2";
      "socket.io-client": "^4.7.4";
      bootstrap = "^5.3.2";
      "vue-toastification": "^2.0.0-rc.5";
      "chart.js": "^4.4.0";
      quagga = "^0.12.1";
    };
    devDependencies = {
      vite = "^4.5.14";
      "@vitejs/plugin-vue": "^4.5.2";
    };
  };

  # Backend server.js
  home.file."${NGOLogisticsD-dir}/Backend/server.js".text = ''
    import express from 'express';
    import mongoose from 'mongoose';
    import cors from 'cors';
    import dotenv from 'dotenv';
    import helmet from 'helmet';
    import morgan from 'morgan';
    import compression from 'compression';
    import { createServer } from 'http';
    import { Server } from 'socket.io';

    // Load env vars
    dotenv.config({ path: './config/config.env' });

    const app = express();
    const server = createServer(app);
    const io = new Server(server, {
      cors: {
        origin: "http://localhost:5173",
        methods: ["GET", "POST"]
      }
    });

    // Middleware
    app.use(helmet());
    app.use(compression());
    app.use(cors());
    app.use(morgan('combined'));
    app.use(express.json());

    // MongoDB connection
    mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/NGOLogisticsD')
      .then(() => console.log('MongoDB connected for NGOLogisticsD'))
      .catch(err => console.error('MongoDB connection error:', err));

    // Basic health check
    app.get('/api/health', (req, res) => {
      res.json({ 
        status: 'OK', 
        project: 'NGOLogisticsD',
        timestamp: new Date().toISOString() 
      });
    });

    // Socket.io connection handling
    io.on('connection', (socket) => {
      console.log('NGOLogisticsD user connected:', socket.id);
      
      socket.on('disconnect', () => {
        console.log('NGOLogisticsD user disconnected:', socket.id);
      });
    });

    const PORT = process.env.PORT || 5000;
    server.listen(PORT, () => {
      console.log(\`NGOLogisticsD server running on port \${PORT}\`);
    });
  '';

  # Backend environment config
  home.file."${NGOLogisticsD-dir}/Backend/config/config.env".text = ''
    NODE_ENV=development
    PORT=5000
    MONGODB_URI=mongodb://localhost:27017/NGOLogisticsD
    JWT_SECRET=your_super_long_jwt_secret_key_for_NGOLogisticsD
    JWT_EXPIRES_IN=90d
  '';

  # Frontend main.js
  home.file."${NGOLogisticsD-dir}/App/src/main.js".text = ''
    import { createApp } from 'vue';
    import { createPinia } from 'pinia';
    import App from './App.vue';
    import router from './router';
    import 'bootstrap/dist/css/bootstrap.css';

    const app = createApp(App);
    app.use(createPinia());
    app.use(router);
    app.mount('#app');
  '';

  # Vue Router
  home.file."${NGOLogisticsD-dir}/App/src/router/index.js".text = ''
    import { createRouter, createWebHistory } from 'vue-router';
    import Login from '../views/Login.vue';
    import Dashboard from '../views/Dashboard.vue';
    import ShipmentsInventory from '../views/ShipmentsInventory.vue';
    import Reports from '../views/Reports.vue';
    import Admin from '../views/Admin.vue';

    const routes = [
      { path: '/', redirect: '/login' },
      { path: '/login', component: Login },
      { path: '/dashboard', component: Dashboard },
      { path: '/shipments', component: ShipmentsInventory },
      { path: '/reports', component: Reports },
      { path: '/admin', component: Admin }
    ];

    const router = createRouter({
      history: createWebHistory(),
      routes
    });

    // Auth guard - always show login first
    router.beforeEach((to, from, next) => {
      const isAuthenticated = localStorage.getItem('authenticated') === 'true';
      if (to.path !== '/login' && !isAuthenticated) {
        next('/login');
      } else {
        next();
      }
    });

    export default router;
  '';

  # Main App.vue
  home.file."${NGOLogisticsD-dir}/App/src/App.vue".text = ''
    <template>
      <div id="app">
        <router-view />
      </div>
    </template>

    <script setup>
    // Main app component
    </script>

    <style>
    #app {
      min-height: 100vh;
      background-color: #f8f9fa;
    }
    </style>
  '';

  # Vite config
  home.file."${NGOLogisticsD-dir}/App/vite.config.js".text = ''
    import { defineConfig } from 'vite'
    import vue from '@vitejs/plugin-vue'

    export default defineConfig({
      plugins: [vue()],
      server: {
        port: 5173,
        host: true
      }
    })
  '';

  # HTML entry point
  home.file."${NGOLogisticsD-dir}/App/index.html".text = ''
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <link rel="icon" type="image/svg+xml" href="/vite.svg" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>NGOLogisticsD - Humanitarian Logistics Management</title>
      </head>
      <body>
        <div id="app"></div>
        <script type="module" src="/src/main.js"></script>
      </body>
    </html>
  '';

  # Login Component (always loads first)
  home.file."${NGOLogisticsD-dir}/App/src/views/Login.vue".text = ''
    <template>
      <div class="login-modal">
        <div class="modal-content">
          <h2>NGOLogisticsD System</h2>
          <p class="text-muted">Humanitarian Logistics Management</p>
          <form @submit.prevent="handleLogin">
            <div class="mb-3">
              <label class="form-label">Email</label>
              <input v-model="email" type="email" class="form-control" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Password</label>
              <input v-model="password" type="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
          </form>
          <div class="demo-credentials mt-3">
            <small>Demo: admin@example.org / password123</small>
          </div>
        </div>
      </div>
    </template>

    <script setup>
    import { ref } from 'vue';
    import { useRouter } from 'vue-router';

    const email = ref('');
    const password = ref('');
    const router = useRouter();

    const handleLogin = () => {
      // Simple demo authentication
      if (email.value === 'admin@example.org' && password.value === 'password123') {
        localStorage.setItem('authenticated', 'true');
        router.push('/dashboard');
      } else {
        alert('Invalid credentials. Use demo credentials provided.');
      }
    };
    </script>

    <style scoped>
    .login-modal {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.5);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal-content {
      background: white;
      padding: 2rem;
      border-radius: 8px;
      width: 400px;
      max-width: 90%;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    </style>
  '';

  # Startup script
  home.file."${NGOLogisticsD-dir}/start-servers.sh".text = ''
    #!/bin/bash
    echo "Starting NGOLogisticsD - NGO Logistics Management System..."
    
    # Create MongoDB data directory
    mkdir -p /home/jim/mongodb-data/db
    
    # Start MongoDB
    echo "Starting MongoDB for NGOLogisticsD..."
    mongod --dbpath /home/jim/mongodb-data/db --fork --logpath /home/jim/mongodb-data/NGOLogisticsD-mongodb.log
    
    # Start backend
    echo "Starting NGOLogisticsD Backend Server..."
    cd Backend
    npm install
    npm run dev &
    BACKEND_PID=$!
    
    # Wait a moment for backend to start
    sleep 3
    
    # Start frontend  
    echo "Starting NGOLogisticsD Frontend Development Server..."
    cd ../App
    npm install
    npm run dev &
    FRONTEND_PID=$!
    
    echo "=================================================="
    echo "NGOLogisticsD System starting up..."
    echo "Frontend: http://localhost:5173"
    echo "Backend API: http://localhost:5000"
    echo "MongoDB: running on port 27017"
    echo "Project: NGOLogisticsD"
    echo "=================================================="
    echo "Use Ctrl+C to stop all services"
    
    # Handle cleanup on exit
    trap "kill $BACKEND_PID $FRONTEND_PID; echo 'NGOLogisticsD services stopped'; exit" INT
    
    wait
  '';

  # Make scripts executable
  home.file."${NGOLogisticsD-dir}/start-servers.sh".executable = true;
  home.file."${NGOLogisticsD-dir}/start-mongodb.sh".executable = true;
  home.file."${NGOLogisticsD-dir}/test-backend.sh".executable = true;
}
