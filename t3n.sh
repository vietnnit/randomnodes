#!/bin/bash

# Script save path
SCRIPT_PATH="$HOME/t3rn.sh"
LOGFILE="$HOME/executor/executor.log"
EXECUTOR_DIR="$HOME/executor"

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
        echo "4) Restart the node (to be used after receiving water)"
        echo "5) Exit"
        
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
                restart_node
                ;;
            5)
                echo "Exiting script."
                exit 0
                ;;
            *)
                echo "Invalid selection, please re-enter."
                ;;
        esac
    done
}

# Restart node function
function restart_node() {
    echo "Restarting node process..."

    # Find the executor process and terminate it
    pkill -f executor

    # Change directory and execute the script
    echo "Change directory and execute ./executor..."
    cd ~/executor/executor/bin

    # Setting environment variables
    export NODE_ENV=testnet
    export LOG_LEVEL=debug
    export LOG_PRETTY=false
    export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
    export EXECUTOR_MAX_L3_GAS_PRICE=100

    # New environment variables
    export EXECUTOR_PROCESS_ORDERS=true
    export EXECUTOR_PROCESS_CLAIMS=true

    # Prompt the user to enter a private key
    read -p "Please enter the value of PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

    # Set private key variables
    export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"

    # Redirect log output
    ./executor > "$LOGFILE" 2>&1 &

    # Display background process PID
    echo "The executor process has been restarted, PID: $!"

    echo "Reboot operation completed."

    # Prompt the user to press any key to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# Execute script function
function execute_script() {
    # Download the file
    echo "Downloading executor-linux-v0.31.0.tar.gz..."
    wget https://github.com/t3rn/executor-release/releases/download/v0.31.0/executor-linux-v0.31.0.tar.gz 
    
    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Download successful."
    else
        echo "Download failed, please check the network connection or download address."
        exit 1
    fi

    # Unzip the file to the current directory
    echo "Unzipping files..."
    tar -xvzf executor-linux-v0.29.0.tar.gz

    # Check if the decompression is successful
    if [ $? -eq 0 ]; then
        echo "Decompression successful."
    else
        echo "Unzip failed, please check the tar.gz file."
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

    # Setting environment variables
    export NODE_ENV=testnet
    export LOG_LEVEL=debug
    export LOG_PRETTY=false
    export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'

    # New environment variables
    export EXECUTOR_PROCESS_ORDERS=true
    export EXECUTOR_PROCESS_CLAIMS=true

    # Prompt the user to enter a private key
    read -p "Please enter the value of PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

    # Set private key variables
    export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"

    # Delete compressed files
    echo "Delete compressed file..."
    rm executor-linux-v0.31.0.tar.gz

    # Change directory and execute the script
    echo "Change directory and execute ./executor..."
    cd ~/executor/executor/bin

    # Redirect log output
    ./executor > "$LOGFILE" 2>&1 &

    # Display background process PID
    echo "executor process started, PID: $!"

    echo "Operation completed."

    # Prompt the user to press any key to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# View log function
function view_logs() {
    if [ -f "$LOGFILE" ]; then
        echo "Real-time display of log file contents (press Ctrl+C to exit):"
        tail -f "$LOGFILE" # Use tail -f to track the log file in real time
    else
        echo "The log file does not exist."
    fi
}

# Delete node function
function delete_node() {
    echo "Stopping node process..."

    # Find the executor process and terminate it
    pkill -f executor

    # Delete the node directory
    if [ -d "$EXECUTOR_DIR" ]; then
        echo "Deleting node directory..."
        rm -rf "$EXECUTOR_DIR"
        echo "Node directory has been deleted."
    else
        echo "The node directory does not exist and may have been deleted."
    fi

    echo "Node deletion completed."

    # Prompt the user to press any key to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# Start the main menu
main_menu
