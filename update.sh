#!/bin/bash

# Kiểm tra trạng thái node Shardeum
STATUS=$(docker exec shardeum-validator operator-cli status | grep -i 'state: active')

# Nếu trạng thái KHÔNG phải là "active", thực thi lệnh cài đặt
if [ -z "$STATUS" ]; then
    echo "State is not 'active'. Running installation script..."
    curl -O https://raw.githubusercontent.com/shardeum/shardeum-validator/refs/heads/itn4/install.sh
    chmod +x install.sh
    yes "" | ./install.sh
else
    echo "State is 'active'. No action required."
fi
