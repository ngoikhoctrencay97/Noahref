#!/bin/bash

# Cập nhật hệ thống và nâng cấp
sudo apt update && sudo apt upgrade -y

# Cài đặt Docker
sudo apt install docker.io -y

# Thêm người dùng vào nhóm Docker
sudo usermod -aG docker $USER

# Kích hoạt nhóm Docker cho người dùng hiện tại
newgrp docker

# Cài đặt Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Tải xuống và cài đặt Shardeum Validator Dashboard
curl -O https://raw.githubusercontent.com/shardeum/validator-dashboard/main/installer.sh
chmod +x installer.sh
./installer.sh
