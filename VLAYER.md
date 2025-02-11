# 🚀 **VLAYER TESTNET & DEVNET SETUP GUIDE**  

## 🛠 **VLAYER TESTNET**  
### ✅ **Update Vlayer Test: simple-web-proof**  
**VPS:** Ubuntu 24.04 (Contabo)  

### 🔹 **Step 1: Update & Install Dependencies**  
Run the following command:  
```bash
sudo apt update && sudo apt install -y git curl wget unzip tar build-essential
```

### 🔹 **Step 2: Install Foundry**  
```bash
curl -L https://foundry.paradigm.xyz | bash
source /root/.bashrc
foundryup
forge --version
```

### 🔹 **Step 3: Install Vlayer**  
```bash
curl -SL https://install.vlayer.xyz | bash
source /root/.bashrc
vlayerup
vlayer --version
```

### 🔹 **Step 4: Install Bun**  
```bash
curl -fsSL https://bun.sh/install | bash
source /root/.bashrc
```

### 🔹 **Step 5: Install Viem & Project Setup**  
```bash
bun add viem
rm -rf bun.lockb node_modules
bun install
```

### 📌 **Create a New Project** (Change `YOUR-PROJECT-NAME`)  
```bash
vlayer init YOUR-PROJECT-NAME --template simple-web-proof
cd YOUR-PROJECT-NAME
forge build
```

### 📌 **Run Inside a Screen Session**  
```bash
screen -S vlayer
cd vlayer
nano .env.testnet.local
```
**Edit and Add Your API Key:**  
```env
VLAYER_API_TOKEN=APIKEY_VLAYER
EXAMPLES_TEST_PRIVATE_KEY=0xYOUR-PRIVATE-KEY
CHAIN_NAME=optimismSepolia
JSON_RPC_URL=https://sepolia.optimism.io
```

### 🔹 **Install Vlayer SDK & Run Prover**  
```bash
bun add @vlayer/sdk
bun run prove:testnet
```

### ✅ **Detached Screen:**  
Press `CTRL + A + D` to exit the screen session.  

---

## 🛠 **VLAYER DEVNET (Docker Setup)**  

### 📌 **Create a Screen Session**  
```bash
screen -S devnet
```

### 🔹 **Update System & Install Dependencies**  
```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

### 🔹 **Install Docker**  
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce
```

### 🔹 **Install Docker Compose**  
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 🔹 **Run Devnet Node**  
```bash
bun run devnet
bun run prove:dev
bun run deploy:dev
bun run deploy:testnet
```

### ✅ **Check Docker Status**  
```bash
docker ps
```

🎉 **DONE! Your Vlayer Testnet & Devnet are set up successfully!** 🚀  

---
