#!/bin/bash

# Script save path
SCRIPT_PATH="$HOME/t3rn.sh"
LOGFILE="$HOME/executor/executor.log"
EXECUTOR_DIR="$HOME/executor"

# Check if the script is running as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    echo "Please try using 'sudo -i' to switch to the root user and run this script again."
    exit 1
fi

# Main menu function
function main_menu() {
    while true; do
        clear
        echo "Script written by the Dadu Community, Twitter @ferdie_jhovie, open source and free. Do not trust paid versions."
        echo "If you have any issues, contact via Twitter. This is the only official account."
        echo "================================================================"
        echo "To exit the script, press Ctrl + C."
        echo "Select an operation to execute:"
        echo "1) Run script"
        echo "2) View logs"
        echo "3) Delete node"
        echo "5) Exit"
        
        read -p "Enter your choice [1-3]: " choice
        
        case $choice in
            1)
                execute_script
                ;;
            2)
                view_logs
                ;;
            3)
                delete_node
                ;;
            5)
                echo "Exiting script."
                exit 0
                ;;
            *)
                echo "Invalid choice, please try again."
                ;;
        esac
    done
}

# Execute script function
function execute_script() {
    # Check if pm2 is installed; if not, install it
    if ! command -v pm2 &> /dev/null; then
        echo "pm2 is not installed. Installing pm2..."
        sudo npm install -g pm2
        if [ $? -eq 0 ]; then
            echo "pm2 installed successfully."
        else
            echo "pm2 installation failed. Please check npm configuration."
            exit 1
        fi
    else
        echo "pm2 is already installed. Continuing..."
    fi

    # Download the latest version of the file
    echo "Downloading the latest version of executor..."
    curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
    grep -Po '"tag_name": "\K.*?(?=")' | \
    xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz

    # Check if download was successful
    if [ $? -eq 0 ]; then
        echo "Download successful."
    else
        echo "Download failed. Please check your network connection or the download URL."
        exit 1
    fi

    # Extract files to the current directory
    echo "Extracting files..."
    LATEST_FILE=$(ls executor-linux-*.tar.gz | sort -V | tail -n 1)

    if [ -f "$LATEST_FILE" ]; then
    tar -xzf "$LATEST_FILE"
    echo "Extraction successful."
    else
    echo "Extraction failed. No valid tar.gz file found."
    exit 1
    fi

    # Check if the extracted files contain 'executor'
    echo "Checking if the extracted files contain 'executor'..."
    if ls | grep -q 'executor'; then
        echo "Check passed. Found files or directories containing 'executor'."
    else
        echo "No files or directories containing 'executor' found. The file name might be incorrect."
        exit 1
    fi

    # Prompt user for environment variable, defaulting EXECUTOR_MAX_L3_GAS_PRICE to 100
    read -p "Enter the value for EXECUTOR_MAX_L3_GAS_PRICE [default 100]: " EXECUTOR_MAX_L3_GAS_PRICE
    EXECUTOR_MAX_L3_GAS_PRICE="${EXECUTOR_MAX_L3_GAS_PRICE:-100}"

    # Set environment variables
    export ENVIRONMENT=testnet
    export LOG_LEVEL=debug
    export LOG_PRETTY=false
    export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,unichain-sepolia,optimism-sepolia,l2rn'
    export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true
    export EXECUTOR_PROCESS_ORDERS_API_ENABLED=false
    export EXECUTOR_MAX_L3_GAS_PRICE="$EXECUTOR_MAX_L3_GAS_PRICE"

    # Additional environment variables
    export EXECUTOR_ENABLE_BATCH_BIDING=true
    export EXECUTOR_PROCESS_BIDS_ENABLED=true
    export EXECUTOR_PROCESS_ORDERS_ENABLED=true
    export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
    export RPC_ENDPOINTS='{
    "l2rn": ["https://b2n.rpc.caldera.xyz/http"],
    "arbt": ["https://arbitrum-sepolia.drpc.org", "https://sepolia-rollup.arbitrum.io/rpc"],
    "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.drpc.org"],
    "opst": ["https://sepolia.optimism.io", "https://optimism-sepolia.drpc.org"],
    "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"]
    }'

    # Prompt user for private key
    read -p "Enter the value for PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

    # Set private key variable
    export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"

    # Delete compressed file
    echo "Deleting compressed package..."
    rm executor-linux-*.tar.gz

    # Change directory to executor/bin
    echo "Switching directory and preparing to start executor with pm2..."
    cd ~/executor/executor/bin

    # Start executor with pm2
    echo "Starting executor with pm2..."
    pm2 start ./executor --name "executor" --log "$LOGFILE" --env NODE_ENV=testnet

    # Display pm2 process list
    pm2 list

    echo "executor has been started using pm2."

    # Prompt user to return to main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# View logs function
function view_logs() {
    if [ -f "$LOGFILE" ]; then
        echo "Displaying log file in real-time (press Ctrl+C to exit):"
        tail -f "$LOGFILE"  # Use tail -f to follow log file updates
    else
        echo "Log file does not exist."
    fi
}

# Delete node function
function delete_node() {
    echo "Stopping node process..."

    # Stop executor process using pm2
    pm2 stop "executor"

    # Delete executor directory
    if [ -d "$EXECUTOR_DIR" ]; then
        echo "Deleting node directory..."
        rm -rf "$EXECUTOR_DIR"
        echo "Node directory deleted."
    else
        echo "Node directory does not exist. It may have already been deleted."
    fi

    echo "Node deletion complete."

    # Prompt user to return to main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# Start main menu
main_menu
