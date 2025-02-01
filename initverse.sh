#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${NC}"
echo -e "${GREEN}Welcome to BOBO's Mining Script${NC}"
echo -e "${YELLOW}--------------------------------${NC}"
echo ""

# Variables
WALLET_ADDRESS=""
WORKER_NAME="Worker001"
CPU_CORES=$(nproc)
POOL_ADDRESSES=("pool-a.yatespool.com:31588" "pool-b.yatespool.com:32488")
MINER_URL="https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64"
RESTART_INTERVAL=7200  # 2 Hours

# Wallet Validation Function
validate_wallet() {
    [[ $1 =~ ^0x[a-fA-F0-9]{40}$ ]] || { echo -e "${RED}Invalid wallet address${NC}"; return 1; }
}

# Function to start mining with automatic restart
run_with_restart() {
    local MINING_CMD=$1
    echo -e "${GREEN}Starting mining...${NC}"
    while true; do
        ./iniminer $MINING_CMD
        echo -e "${YELLOW}Restarting in 2 hours...${NC}"
        sleep $RESTART_INTERVAL
        pkill -f iniminer
    done
}

# Mining Setup
setup_mining() {
    echo -e "${CYAN}Select Pool:${NC}"
    select POOL_ADDRESS in "${POOL_ADDRESSES[@]}"; do break; done

    while [ -z "$WALLET_ADDRESS" ] || ! validate_wallet "$WALLET_ADDRESS"; do
        read -p "Enter Wallet Address (0x...): " WALLET_ADDRESS
    done

    read -p "Worker Name (default: Worker001): " input_worker
    WORKER_NAME=${input_worker:-$WORKER_NAME}

    # Select number of CPU cores to use
    echo -e "${CYAN}Enter number of CPU cores to use (1-${CPU_CORES}, default: 1):${NC}"
    read cores
    cores=${cores:-1}

    # Prepare mining command with selected cores
    MINING_CMD="--pool stratum+tcp://${POOL_ADDRESS} --user ${WALLET_ADDRESS}.${WORKER_NAME}"

    for ((i=0; i<cores; i++)); do
        MINING_CMD+=" --cpu-devices $i"
    done

    mkdir -p ini-miner && cd ini-miner
    wget -q "$MINER_URL" -O iniminer && chmod +x iniminer

    [[ -f "iniminer" ]] || { echo -e "${RED}Failed to download miner!${NC}"; exit 1; }

    # Start mining with automatic restart
    run_with_restart "$MINING_CMD"
}

# Main Menu
clear
echo -e "${CYAN}1. Start Mining\n2. Exit${NC}"
read -p "Choose an option: " choice
case $choice in
    1) setup_mining ;;
    2) exit 0 ;;
    *) echo -e "${RED}Invalid choice!${NC}" ;;
esac
