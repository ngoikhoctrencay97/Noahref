#!/bin/bash

# Tạo thư mục và tệp prover-id
mkdir -p /home/ubuntu/.nexus/
echo -n 'dEfAuLT1' > /home/ubuntu/.nexus/prover-id

# Cập nhật hệ thống và cài đặt các gói cần thiết
sudo apt update && sudo apt upgrade -y
sudo apt install -y screen curl libssl-dev pkg-config build-essential git-all protobuf-compiler

# Cài đặt Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source /home/ubuntu/.cargo/env

# Khởi chạy tmux để thực hiện lệnh cuối cùng
tmux new-session -d -s nexus_setup "curl https://cli.nexus.xyz/ | sh"
tmux send-keys -t nexus_setup Enter Enter Enter
# Hiển thị thông báo hoàn tất
echo "Setup complete. To monitor the Nexus installation, attach to the tmux session:"
echo "tmux attach -t nexus_setup"
