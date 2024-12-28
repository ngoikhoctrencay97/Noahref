#!/bin/bash

# Kiểm tra trạng thái node Shardeum
STATUS=$(docker exec shardeum-dashboard operator-cli status | grep -i 'state: stopped')

# Nếu trạng thái là "stopped", thực thi lệnh cài đặt
if [ ! -z "$STATUS" ]; then
    echo "State is 'stopped'. Running installation script..."
    curl -O https://raw.githubusercontent.com/shardeum/validator-dashboard/main/installer.sh
    chmod +x installer.sh
    yes | ./installer.sh
else
    echo "State is not 'stopped'. No action required."
fi
