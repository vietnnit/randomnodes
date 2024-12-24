#!/bin/bash

# Script save path
SCRIPT_PATH="$HOME/t3rn.sh"
LOGFILE="$HOME/executor/executor.log"
EXECUTOR_DIR="$HOME/executor"

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script needs to be run with root privileges."
    echo "Please try using 'sudo -i' to switch to the root user, then run this script again."
    exit 1
fi

# Main menu function
function main_menu() {
    while true; do
        clear
        echo "Script written by Big Bet Community, hahahaha, Twitter @ferdie_jhovie, free and open source, do not believe in paid services"
        echo "If you have questions, contact Twitter; there is only one account"
        echo "================================================================"
        echo "To exit the script, press ctrl + C on the keyboard to exit"
        echo "Please select the operation to execute:"
        echo "1) Execute the script"
        echo "2) View logs"
        echo "3) Delete node"
        echo "4) Restart node (use after claiming water)"
        echo "5) Exit"
        
        read -p "Enter your choice [1-4]: " choice
        
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
                echo "Exiting the script."
                exit 0
                ;;
            *)
                echo "Invalid choice, please try again."
                ;;
        esac
    done
}

# Restart node function
function restart_node() {
    echo "Restarting node process..."

    # Find and terminate the executor process
    pkill -f executor

    # Change directory and execute the script
    echo "Switching directory and executing ./executor..."
    cd ~/executor/executor/bin

    # Set environment variables
    export NODE_ENV=testnet
    export LOG_LEVEL=debug
    export LOG_PRETTY=false
    export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'
    export EXECUTOR_MAX_L3_GAS_PRICE=100

    # Additional environment variables
    export EXECUTOR_PROCESS_ORDERS=true
    export EXECUTOR_PROCESS_CLAIMS=true

    # Prompt user for private key
    read -p "Enter the value for PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

    # Set private key variable
    export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"

    # Redirect log output
    ./executor > "$LOGFILE" 2>&1 &

    # Show background process PID
    echo "Executor process restarted, PID: $!"

    echo "Restart operation complete."

    # Prompt user to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# Execute script function
function execute_script() {
    # Download file
    echo "Downloading executor-linux-v0.29.0.tar.gz..."
    wget https://github.com/t3rn/executor-release/releases/download/v0.29.0/executor-linux-v0.29.0.tar.gz

    # Check if download was successful
    if [ $? -eq 0 ]; then
        echo "Download successful."
    else
        echo "Download failed, please check your network connection or download URL."
        exit 1
    fi

    # Extract file to the current directory
    echo "Extracting file..."
    tar -xvzf executor-linux-v0.29.0.tar.gz

    # Check if extraction was successful
    if [ $? -eq 0 ]; then
        echo "Extraction successful."
    else
        echo "Extraction failed, please check the tar.gz file."
        exit 1
    fi

    # Check if the extracted filename contains 'executor'
    echo "Checking if the extracted file or directory name contains 'executor'..."
    if ls | grep -q 'executor'; then
        echo "Check passed, found a file or directory containing 'executor'."
    else
        echo "No file or directory containing 'executor' found; the filename may be incorrect."
        exit 1
    fi

    # Set environment variables
    export NODE_ENV=testnet
    export LOG_LEVEL=debug
    export LOG_PRETTY=false
    export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l1rn'

    # Additional environment variables
    export EXECUTOR_PROCESS_ORDERS=true
    export EXECUTOR_PROCESS_CLAIMS=true

    # Prompt user for private key
    read -p "Enter the value for PRIVATE_KEY_LOCAL: " PRIVATE_KEY_LOCAL

    # Set private key variable
    export PRIVATE_KEY_LOCAL="$PRIVATE_KEY_LOCAL"

    # Delete compressed file
    echo "Deleting compressed package..."
    rm executor-linux-v0.31.0.tar.gz

    # Change directory and execute the script
    echo "Switching directory and executing ./executor..."
    cd ~/executor/executor/bin

    # Redirect log output
    ./executor > "$LOGFILE" 2>&1 &

    # Show background process PID
    echo "Executor process started, PID: $!"

    echo "Operation complete."

    # Prompt user to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# View logs function
function view_logs() {
    if [ -f "$LOGFILE" ]; then
        echo "Displaying log file contents in real-time (press Ctrl+C to exit):"
        tail -f "$LOGFILE"  # Use tail -f to track log file in real time
    else
        echo "Log file does not exist."
    fi
}

# Delete node function
function delete_node() {
    echo "Stopping node process..."

    # Find and terminate the executor process
    pkill -f executor

    # Delete node directory
    if [ -d "$EXECUTOR_DIR" ]; then
        echo "Deleting node directory..."
        rm -rf "$EXECUTOR_DIR"
        echo "Node directory deleted."
    else
        echo "Node directory does not exist; it may have already been deleted."
    fi

    echo "Node deletion operation complete."

    # Prompt user to return to the main menu
    read -n 1 -s -r -p "Press any key to return to the main menu..."
    main_menu
}

# Start the main menu
main_menu
