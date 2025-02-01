#!/bin/bash

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${NC}"
echo -e "${GREEN}Welcome to 0xtnp's Mining Script${NC}"
echo -e "${YELLOW}--------------------------------${NC}"
echo ""

# Variable
WALLET_ADDRESS=""
WORKER_NAME="Worker001"
CPU_CORES=$(nproc)
POOL_ADDRESSES=("pool-a.yatespool.com:31588" "pool-b.yatespool.com:32488")
MINER_URL="https://github.com/Project-InitVerse/ini-miner/releases/download/v1.0.0/iniminer-linux-x64"
RESTART_INTERVAL=7200  # 2 Jam

# Fungsi Validasi Wallet
validate_wallet() {
    [[ $1 =~ ^0x[a-fA-F0-9]{40}$ ]] || { echo -e "${RED}Invalid wallet address${NC}"; return 1; }
}

# Fungsi untuk memulai mining dengan restart otomatis
run_with_restart() {
    local MINING_CMD=$1
    echo -e "${GREEN}Memulai mining...${NC}"
    while true; do
        ./iniminer $MINING_CMD
        echo -e "${YELLOW}Restarting dalam 2 jam...${NC}"
        sleep $RESTART_INTERVAL
        pkill -f iniminer
    done
}

# Setup Mining
setup_mining() {
    echo -e "${CYAN}Pilih Pool:${NC}"
    select POOL_ADDRESS in "${POOL_ADDRESSES[@]}"; do break; done

    while [ -z "$WALLET_ADDRESS" ] || ! validate_wallet "$WALLET_ADDRESS"; do
        read -p "Masukkan Wallet Address (0x...): " WALLET_ADDRESS
    done

    read -p "Worker Name (default: Worker001): " input_worker
    WORKER_NAME=${input_worker:-$WORKER_NAME}

    # Memilih jumlah CPU cores untuk digunakan
    echo -e "${CYAN}Enter number of CPU cores to use (1-${CPU_CORES}, default: 1):${NC}"
    read cores
    cores=${cores:-1}

    # Persiapkan perintah untuk mining dengan core yang dipilih
    MINING_CMD="--pool stratum+tcp://${POOL_ADDRESS} --user ${WALLET_ADDRESS}.${WORKER_NAME}"

    for ((i=0; i<cores; i++)); do
        MINING_CMD+=" --cpu-devices $i"
    done

    mkdir -p ini-miner && cd ini-miner
    wget -q "$MINER_URL" -O iniminer && chmod +x iniminer

    [[ -f "iniminer" ]] || { echo -e "${RED}Download miner gagal!${NC}"; exit 1; }

    # Menjalankan mining dengan restart otomatis
    run_with_restart "$MINING_CMD"
}

# Menu Utama
clear
echo -e "${CYAN}1. Mulai Mining\n2. Keluar${NC}"
read -p "Pilih opsi: " choice
case $choice in
    1) setup_mining ;;
    2) exit 0 ;;
    *) echo -e "${RED}Pilihan tidak valid!${NC}" ;;
esac