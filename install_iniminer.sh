#!/bin/bash

echo "### INI Miner One-Click Installer ###"

# Prompt for wallet address and worker name
read -p "Enter your wallet address: " WALLET_ADDRESS
read -p "Enter your worker name: " WORKER_NAME

# Define pool URL
POOL_URL="stratum+tcp://${WALLET_ADDRESS}.${WORKER_NAME}@pool-b.yatespool.com:32488"

echo "Downloading INI Miner..."
wget -q https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64
chmod +x iniminer-linux-x64

# Create systemd service file
echo "Creating systemd service for INI Miner..."
sudo bash -c "cat > /etc/systemd/system/iniminer.service <<EOF
[Unit]
Description=INI Miner Service
After=network.target

[Service]
Type=simple
WorkingDirectory=/root
ExecStart=/root/iniminer-linux-x64 --pool $POOL_URL --cpu-devices 1 --cpu-devices 2 --cpu-devices 3 --cpu-devices 4 --cpu-devices 5 --cpu-devices 6
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF"

# Reload systemd, enable and start the miner
echo "Enabling and starting INI Miner service..."
sudo systemctl daemon-reload
sudo systemctl enable iniminer
sudo systemctl start iniminer

echo "INI Miner is now running!"
echo "To check logs, use: sudo journalctl -u iniminer -f -o cat"
