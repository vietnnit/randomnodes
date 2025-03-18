#!/bin/bash

# Function to request input with a default value
ask_with_default() {
    local prompt="$1"
    local default_value="$2"
    read -p "$prompt [$default_value]: " input
    echo "${input:-$default_value}"
}

# Check and create folder if it doesn't exist
check_and_create_folder() {
    local folder_name="$1"
    if [ "$(basename "$PWD")" = "$folder_name" ]; then
        echo "✅ Already inside the folder '$folder_name'." 
    elif [ ! -d "$folder_name" ]; then
        echo "📂 Folder '$folder_name' not found. Creating folder..."
        mkdir -p "$folder_name"
    else
        echo "📂 Folder '$folder_name' already exists."
    fi
    cd "$folder_name" || { echo "❌ Failed to switch to folder $folder_name"; exit 1; }
}

# Setup working folder
check_and_create_folder "t3rn"

# Get the latest version from GitHub
LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
grep -Po '"tag_name": "\K.*?(?=")')

echo "🔄 Latest version: $LATEST_VERSION"

# Download file from GitHub using wget
EXECUTOR_FILE="executor-linux-${LATEST_VERSION}.tar.gz"
echo "🆕 Downloading executor version ${LATEST_VERSION}..."
wget "https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/${EXECUTOR_FILE}"

# Extract file
echo "📦 Extracting executor file..."
tar -xzf "$EXECUTOR_FILE"

# Remove tar file after extraction
rm -f "$EXECUTOR_FILE"

# Navigate to the executor binary directory
cd executor/executor/bin || { echo "❌ Failed to enter executor directory"; exit 1; }

# Interactive configuration
echo "⚙️  Configuring Executor"
ENVIRONMENT=$(ask_with_default "Enter ENVIRONMENT" "testnet")
LOG_LEVEL=$(ask_with_default "Enter LOG_LEVEL" "debug")
LOG_PRETTY=$(ask_with_default "LOG_PRETTY" "false")
EXECUTOR_PROCESS_ORDERS_ENABLED=$(ask_with_default "EXECUTOR_PROCESS_ORDERS_ENABLED" "true")
EXECUTOR_PROCESS_CLAIMS_ENABLED=$(ask_with_default "EXECUTOR_PROCESS_CLAIMS_ENABLED" "true")
EXECUTOR_PROCESS_BIDS_ENABLED=$(ask_with_default "EXECUTOR_PROCESS_BIDS_ENABLED" "true")
EXECUTOR_MAX_L3_GAS_PRICE=$(ask_with_default "Enter EXECUTOR_MAX_L3_GAS_PRICE" "100")
PRIVATE_KEY_LOCAL=$(ask_with_default "Enter PRIVATE_KEY_LOCAL" "")
ENABLED_NETWORKS=$(ask_with_default "Enter ENABLED_NETWORKS" "arbitrum-sepolia,base-sepolia,optimism-sepolia,l2rn")

# Configure RPC_ENDPOINTS
RPC_ENDPOINTS_L2RN=$(ask_with_default "Enter RPC_ENDPOINTS_L2RN" "https://b2n.rpc.caldera.xyz/http")
RPC_ENDPOINTS_ARBT=$(ask_with_default "Enter RPC_ENDPOINTS_ARBT" "https://arbitrum-sepolia.drpc.org,https://sepolia-rollup.arbitrum.io/rpc")
RPC_ENDPOINTS_BAST=$(ask_with_default "Enter RPC_ENDPOINTS_BAST" "https://base-sepolia-rpc.publicnode.com,https://base-sepolia.drpc.org")
RPC_ENDPOINTS_OPST=$(ask_with_default "Enter RPC_ENDPOINTS_OPST" "https://sepolia.optimism.io,https://optimism-sepolia.drpc.org")
RPC_ENDPOINTS_UNIT=$(ask_with_default "Enter RPC_ENDPOINTS_UNIT" "https://unichain-sepolia.drpc.org,https://sepolia.unichain.org")

# Format as JSON
RPC_ENDPOINTS_JSON=$(cat <<EOF
{
    "l2rn": ["$RPC_ENDPOINTS_L2RN"],
    "arbt": ["$(echo $RPC_ENDPOINTS_ARBT | sed 's/,/", "/g')"],
    "bast": ["$(echo $RPC_ENDPOINTS_BAST | sed 's/,/", "/g')"],
    "opst": ["$(echo $RPC_ENDPOINTS_OPST | sed 's/,/", "/g')"],
    "unit": ["$(echo $RPC_ENDPOINTS_UNIT | sed 's/,/", "/g')"]
}
EOF
)

# Set environment variables
export ENVIRONMENT
export LOG_LEVEL
export LOG_PRETTY
export EXECUTOR_PROCESS_BIDS_ENABLED
export EXECUTOR_PROCESS_ORDERS_ENABLED
export EXECUTOR_PROCESS_CLAIMS_ENABLED
export EXECUTOR_MAX_L3_GAS_PRICE
export PRIVATE_KEY_LOCAL
export ENABLED_NETWORKS
export RPC_ENDPOINTS="$RPC_ENDPOINTS_JSON"

echo "✅ Environment variables have been set:"
printenv | grep -E 'ENVIRONMENT|LOG_LEVEL|LOG_PRETTY|EXECUTOR|PRIVATE_KEY_LOCAL|ENABLED_NETWORKS|RPC_ENDPOINTS'

# Run executor
echo "🚀 Running executor..."
if [ -x "./executor" ]; then
    ./executor
else
    echo "❌ Error: Cannot find or run executor. Ensure the directory is correct."
fi
