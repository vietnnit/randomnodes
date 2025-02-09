# VLAYER TESTNET

# 1. VLAYER TESTNET
- Update Vlayer Test simple-web-proof 
- VPS Ubuntu 24.04 Contabo

- 1st: Run Command 
```
sudo apt update && apt install git
sudo apt install -y curl wget unzip tar build-essential
```
- 2nd: Run Command 
```
curl -L https://foundry.paradigm.xyz | bash
source /root/.bashrc
foundryup
forge --version
```
- 3rd: Run Command 
```
curl -SL https://install.vlayer.xyz | bash
source /root/.bashrc
vlayerup
vlayer --version
```
- 4th: Run Command 
```
curl -fsSL https://bun.sh/install | bash
source /root/.bashrc
```
- 5th: Run Command 
```
bun add viem
rm -rf bun.lockb node_modules
bun install
```
- Create Project ( Change name of project )
```
vlayer init YOUR-PROJECT-NAME --template simple-web-proof
cd YOUR-PROJECT-NAME
forge build
```
- Create a screen 
```
screen -S vlayer
```
```
cd vlayer 
nano .env.testnet.local
```
- Edit Your Api Key and Paste in inside .env file.
```
VLAYER_API_TOKEN=APIKEY VLAYER
EXAMPLES_TEST_PRIVATE_KEY=0xYOUR-PRIVATE-KEY
CHAIN_NAME=optimismSepolia
JSON_RPC_URL=https://sepolia.optimism.io
```
- Install sdk vlayer
```
bun add @vlayer/sdk
```
- Run
```
bun run prove:testnet
```
- Detached SCREEN 


- FULL VIDEO GUIDE:  https://www.youtube.com/watch?v=-Jpcg7NJFdU
-------------------------------------------------------------------

# 2. VLAYER DEVNET DOCKER

Create Screen 
```
screen -S devnet
```

```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- Install Docker:
```
sudo apt update
sudo apt install docker-ce
```

- Install Docker Compose:
```
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

- RUN Devnet Node vlayer:
```
 bun run devnet
```
```
bun run prove:dev
```
```
bun run deploy:dev
bun run deploy:testnet
```
- Check Docker Status
```
docker ps

```
- DONE!


















