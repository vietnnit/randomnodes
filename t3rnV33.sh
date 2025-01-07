#!/bin/bash

# Check if the script is run as root user
if [ "$(id -u)" != "0" ]; then
    echo "This script needs to be run with root privileges."
    echo "Please try to switch to the root user using the 'sudo -i' command and then run this script again."
    exit 1
fi

# Main menu function
function main_menu() {
    while true; do
        clear
        echo "The script was written by the big gambling community hahahaha, Twitter @ferdie_jhovie, free and open source, please don't believe in the charges"
        echo "If you have any questions, please contact Twitter. There is only one number for this."
        echo "================================================ ================"
        echo "To exit the script, press ctrl + C on your keyboard to exit"
        echo "Please select the action to perform:"
        echo "1) Execute the script"
        echo "2) View the log"
        echo "3) Delete node"
        echo "4) Exit"
        
        read -p "Please enter your choice [1-4]: " choice
        
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
            4)
                echo "Exiting script."
                exit 0
                ;;
            *)
                echo "Invalid selection, please re-enter."
                ;;
        esac
    done
}

# Execute script function
function execute_script() {
    # Download the file
    echo "Downloading executor-linux-v0.33.0.tar.gz..."
    wget https://github.com/t3rn/executor-release/releases/download/v0.33.0/executor-linux-v0.33.0.tar.gz

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Download successful."
    else
        echo "Download failed, please check the network connection or download address."
        exit 1
    fi

    # Unzip the file to the current directory
    echo "Unzipping files..."
    tar -xvzf executor-linux-v0.33.0.tar.gz

    # Check if the decompression is successful
    if [ $? -eq 0 ]; then
        echo "Decompression successful."
    else
        echo "Unzip failed, please check the tar.gz file."
        rm executor-linux-v0.33.0.tar.gz
        exit 1
    fi

    # Check if the decompressed file name contains 'executor'
    echo "Checking if the decompressed file or directory name contains 'executor'..."
    if ls | grep -q 'executor'; then
        echo "Check passed, found a file or directory containing 'executor'."
    else
        echo "The file or directory containing 'executor' was not found. The file name may be incorrect."
        exit 1
    fi

    # Prompt the user to enter RPC values
    read -p "Enter RPC_ENDPOINTS_ARBT: " RPC_ENDPOINTS_ARBT
    read -p "Enter RPC_ENDPOINTS_BSSP: " RPC_ENDPOINTS_BSSP
    read -p "Enter RPC_ENDPOINTS_OPSP: " RPC_ENDPOINTS_OPSP
    read -p "Enter RPC_ENDPOINTS_BLSS: " RPC_ENDPOINTS_BLSS
    read -p "Enter EXECUTOR_MAX_L3_GAS_PRICE (default: 100): " EXECUTOR_MAX_L3_GAS_PRICE

    # Set default value if EXECUTOR_MAX_L3_GAS_PRICE is empty
    EXECUTOR_MAX_L3_GAS_PRICE="${EXECUTOR_MAX_L3_GAS_PRICE:-100}"

    # Prompt the user to enter a private key
    read -p "Please enter the value of PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

    # Create a systemd service file
    sudo tee /etc/systemd/system/t3rn-executor.service > /dev/null <<EOF
    [Unit]
    Description=t3rn Executor Service
    After=network.target

    [Service]
    ExecStart=/root/executor/executor/bin/executor
    Environment="NODE_ENV=testnet"
    Environment="LOG_LEVEL=debug"
    Environment="LOG_PRETTY=false"
    Environment="ENABLED_NETWORKS=arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn"
    Environment="RPC_ENDPOINTS_L1RN=https://brn.rpc.caldera.xyz/"
    Environment="RPC_ENDPOINTS_ARBT=$RPC_ENDPOINTS_ARBT"
    Environment="RPC_ENDPOINTS_BSSP=$RPC_ENDPOINTS_BSSP"
    Environment="RPC_ENDPOINTS_BLSS=$RPC_ENDPOINTS_BLSS"
    Environment="RPC_ENDPOINTS_OPSP=$RPC_ENDPOINTS_OPSP"
    Environment="EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false"
    Environment="EXECUTOR_MAX_L3_GAS_PRICE=$EXECUTOR_MAX_L3_GAS_PRICE"
    Environment="EXECUTOR_PROCESS_ORDERS=true"
    Environment="EXECUTOR_PROCESS_CLAIMS=true"
    Environment="PRIVATE_KEY_LOCAL=$PRIVATE_KEY_LOCAL"
    Restart=always
    RestartSec=5
    User=$USER

    [Install]
    WantedBy=multi-user.target
EOF

    # Reload systemd, enable dan start service
    sudo systemctl daemon-reload
    sudo systemctl enable t3rn-executor.service
    sudo systemctl start t3rn-executor.service

    # Prompt the user to press any key to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# View logs function
function view_logs() {
    echo "Fetching logs for the t3rn-executor service..."
    journalctl -u t3rn-executor.service -f
    # Prompt the user to press any key to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# Delete node function
function delete_node() {
    echo "Stopping the t3rn-executor service..."
    sudo systemctl stop t3rn-executor.service

    echo "Disabling the t3rn-executor service..."
    sudo systemctl disable t3rn-executor.service

    echo "Removing systemd service file..."
    sudo rm /etc/systemd/system/t3rn-executor.service

    echo "Removing executor files..."
    sudo rm -rf /root/executor

    # Reload systemd to reflect the changes
    sudo systemctl daemon-reload

    echo "Node has been deleted successfully."

    # Prompt the user to press any key to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# Start the main menu
main_menu
