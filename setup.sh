#!/bin/bash

# Cập nhật hệ thống và nâng cấp
sudo apt update && sudo apt upgrade -y

# Cài đặt Docker
sudo apt install docker.io -y

# Thêm người dùng vào nhóm Docker
sudo usermod -aG docker $USER

# Kích hoạt nhóm Docker cho người dùng hiện tại
newgrp docker
