#!/bin/bash

# Cài đặt Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Tải xuống và cài đặt Shardeum Validator Dashboard
curl -O https://raw.githubusercontent.com/shardeum/validator-dashboard/main/installer.sh
chmod +x installer.sh
./installer.sh
