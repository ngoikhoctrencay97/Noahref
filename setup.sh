#!/bin/bash

# Phần 1: Cài đặt Docker và thêm nhóm
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y
sudo usermod -aG docker $USER

# Phần 2: Tiếp tục mà không cần đăng xuất
newgrp docker <<EONG
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
curl -O https://raw.githubusercontent.com/shardeum/validator-dashboard/main/installer.sh
chmod +x installer.sh
./installer.sh
EONG
