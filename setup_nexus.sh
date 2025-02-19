#!/bin/bash

# Cập nhật hệ thống và cài đặt các gói cần thiết
sudo apt update && sudo apt upgrade -y
sudo apt install -y screen curl libssl-dev pkg-config build-essential git-all protobuf-compiler
sudo apt update
# Cài đặt Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source /home/ubuntu/.cargo/env
# Hiển thị thông báo hoàn tất
echo "Setup complete. To monitor the Nexus installation"
