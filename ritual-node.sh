#!/bin/bash

echo "========================================="
echo " Ritual Infernet Node - 1 Click Installer"
echo "========================================="
echo ""

# 1. Request Wallet & Private Key Input Securely
read -p "Enter Your Wallet Address: " WALLET_ADDRESS
read -s -p "Enter Your Private Key (will not be displayed): " PRIVATE_KEY
echo ""

# 2. Update and Install Dependencies
echo "[1] Updating system & installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt -qy install curl git jq lz4 build-essential screen

# 3. Install Docker & Docker Compose
echo "[2] Installing Docker..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

echo "[3] Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 4. Clone Ritual Infernet Repository
echo "[4] Downloading & configuring Infernet Node..."
git clone https://github.com/ritual-net/infernet-container-starter ~/infernet-container-starter
cd ~/infernet-container-starter

# 5. Configure Node
echo "[5] Setting up node configuration..."
cat > deploy/config.json <<EOL
{
    "log_path": "infernet_node.log",
    "server": {
        "port": 4000,
        "rate_limit": {
            "num_requests": 100,
            "period": 100
        }
    },
    "chain": {
        "enabled": true,
        "trail_head_blocks": 3,
        "rpc_url": "https://mainnet.base.org/",
        "registry_address": "0x3B1554f346DFe5c482Bb4BA31b880c1C18412170",
        "wallet": {
          "max_gas_limit": 4000000,
          "private_key": "0x$PRIVATE_KEY",
          "allowed_sim_errors": []
        },
        "snapshot_sync": {
          "sleep": 3,
          "batch_size": 10000,
          "starting_sub_id": 180000,
          "sync_period": 30
        }
    },
    "startup_wait": 1.0,
    "redis": {
        "host": "redis",
        "port": 6379
    },
    "forward_stats": true,
    "containers": [
        {
            "id": "hello-world",
            "image": "ritualnetwork/hello-world-infernet:latest",
            "external": true,
            "port": "3000",
            "allowed_delegate_addresses": [],
            "allowed_addresses": [],
            "allowed_ips": [],
            "command": "--bind=0.0.0.0:3000 --workers=2",
            "env": {},
            "volumes": [],
            "accepted_payments": {},
            "generates_proofs": false
        }
    ]
}
EOL

# 6. Install Foundry
echo "[6] Installing Foundry..."
cd
mkdir -p foundry && cd foundry
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup

# 7. Install Library for Smart Contract
echo "[7] Installing library for smart contract..."
cd ~/infernet-container-starter/projects/hello-world/contracts
forge install --no-commit foundry-rs/forge-std
forge install --no-commit ritual-net/infernet-sdk

# 8. Run Node
echo "[8] Running node..."
cd ~/infernet-container-starter
docker compose -f deploy/docker-compose.yaml up -d

# 9. Deploy Smart Contract
echo "[9] Deploying smart contract..."
cd ~/infernet-container-starter
project=hello-world make deploy-contracts

echo "================================================="
echo " ✅ Ritual Infernet Node Installation Complete! ✅"
echo "================================================="
echo "Please check the status with the following commands:"
echo "  docker ps                 # See running containers"
echo "  docker logs infernet-node  # See node logs"
echo "================================================="