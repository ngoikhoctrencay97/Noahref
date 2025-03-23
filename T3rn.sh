#!/bin/bash

log() {
    local level=$1
    local message=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
}

# Hàm nhập private key
get_private_key() {
    while true; do
        echo "Enter your Metamask Private Key (without 0x prefix):"
        read -r PRIVATE_KEY_LOCAL

        # Loại bỏ tiền tố '0x' nếu có
        PRIVATE_KEY_LOCAL=$(echo "$PRIVATE_KEY_LOCAL" | sed 's/^0x//')

        # Kiểm tra khóa riêng có đúng 64 ký tự và là chuỗi hexa hợp lệ
        if [[ ${#PRIVATE_KEY_LOCAL} -eq 64 && "$PRIVATE_KEY_LOCAL" =~ ^[a-fA-F0-9]+$ ]]; then
            export PRIVATE_KEY_LOCAL
            log "INFO" "Private key has been set successfully."
            break
        else
            log "ERROR" "Invalid private key. It must be 64 characters long and contain only hexadecimal characters (without 0x prefix)."
        fi
    done
}


# Các hàm khác (giữ nguyên)
remove_old_service() {
    log "INFO" "Stopping and removing the old service if it exists..."
    sudo systemctl stop executor.service 2>/dev/null
    sudo systemctl disable executor.service 2>/dev/null
    sudo rm -f /etc/systemd/system/executor.service
    sudo systemctl daemon-reload
    log "INFO" "Old service has been removed."
}

update_system() {
    log "INFO" "Updating and upgrading the system..."
    sudo apt update -q && sudo apt upgrade -qy
    if [ $? -ne 0 ]; then
        log "ERROR" "System update failed. Exiting."
        exit 1
    fi
}

download_and_extract_binary() {
    log "INFO" "Fetching the latest Executor binary version..."
    LATEST_VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep 'tag_name' | cut -d\" -f4)
    if [ -z "$LATEST_VERSION" ]; then
        log "ERROR" "Failed to fetch the latest version. Exiting."
        exit 1
    fi

    EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/${LATEST_VERSION}/executor-linux-${LATEST_VERSION}.tar.gz"
    EXECUTOR_FILE="executor-linux-${LATEST_VERSION}.tar.gz"

    log "INFO" "Latest version detected: $LATEST_VERSION"
    log "INFO" "Downloading Executor binary from $EXECUTOR_URL..."
    curl -L -o $EXECUTOR_FILE $EXECUTOR_URL
    if [ $? -ne 0 ]; then
        log "ERROR" "Failed to download Executor binary. Exiting."
        exit 1
    fi

    log "INFO" "Extracting binary..."
    tar -xzvf $EXECUTOR_FILE
    if [ $? -ne 0 ]; then
        log "ERROR" "Extraction failed. Exiting."
        exit 1
    fi

    rm -f $EXECUTOR_FILE
    cd executor/executor/bin || exit
    log "INFO" "Binary successfully downloaded and extracted."
}

set_environment_variables() {
    export NODE_ENV=testnet
    export LOG_LEVEL=info
    export LOG_PRETTY=false
    log "INFO" "Environment variables set: NODE_ENV=$NODE_ENV, LOG_LEVEL=$LOG_LEVEL, LOG_PRETTY=$LOG_PRETTY"
}

set_enabled_networks() {
    export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,l1rn'
    log "INFO" "Enabled networks: $ENABLED_NETWORKS"
}

create_systemd_service() {
    SERVICE_FILE="/etc/systemd/system/executor.service"
    log "INFO" "Creating systemd service file..."
    sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Executor Service
After=network.target

[Service]
User=root
WorkingDirectory=/root/executor/executor
Environment="NODE_ENV=testnet"
Environment="LOG_LEVEL=info"
Environment="LOG_PRETTY=false"
Environment="PRIVATE_KEY_LOCAL=0x$PRIVATE_KEY_LOCAL"
Environment="ENABLED_NETWORKS=$ENABLED_NETWORKS"
ExecStart=/root/executor/executor/bin/executor
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOL
    log "INFO" "Systemd service file created."
}

start_service() {
    log "INFO" "Starting the Executor service..."
    sudo systemctl daemon-reload
    sudo systemctl enable executor.service
    sudo systemctl start executor.service
    if [ $? -eq 0 ]; then
        log "INFO" "Executor service started successfully!"
    else
        log "ERROR" "Failed to start Executor service. Check logs for details."
        exit 1
    fi
}

display_log() {
    log "INFO" "Displaying logs from the Executor service:"
    sudo journalctl -u executor.service -f
}

# Thực thi các hàm
log "INFO" "Starting setup..."
get_private_key
remove_old_service
update_system
download_and_extract_binary
set_environment_variables
set_enabled_networks
create_systemd_service
start_service
display_log
