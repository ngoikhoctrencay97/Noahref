#!/bin/bash

# Kiểm tra trạng thái node Shardeum
STATUS=$(docker exec shardeum-dashboard operator-cli status | grep -i 'state: active')

# Nếu trạng thái KHÔNG phải là "active", thực thi lệnh cài đặt
if [ -z "$STATUS" ]; then
    echo "State is not 'active'. Running installation script..."
    curl -O https://raw.githubusercontent.com/shardeum/validator-dashboard/main/installer.sh
    chmod +x installer.sh
    yes "" | ./installer.sh
else
    echo "State is 'active'. No action required."
fi
