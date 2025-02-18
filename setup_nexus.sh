#!/bin/bash

# Tạo một phiên tmux mới
tmux new-session -s setup -d

# Tạo thư mục và tệp prover-id
tmux send-keys -t setup "mkdir -p /home/ubuntu/.nexus/" C-m
tmux send-keys -t setup "echo -n 'dEfAuLT1' > /home/ubuntu/.nexus/prover-id" C-m

# Cập nhật và nâng cấp hệ thống
tmux send-keys -t setup "sudo apt update && sudo apt upgrade -y" C-m

# Cài đặt các gói cần thiết
tmux send-keys -t setup "sudo apt install -y screen curl libssl-dev pkg-config build-essential git-all protobuf-compiler" C-m

# Cài đặt Rust, thiết lập môi trường và cài đặt Nexus CLI
tmux send-keys -t setup "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && . /home/ubuntu/.cargo/env && curl https://cli.nexus.xyz/ | sh" C-m C-m

# Hiển thị phiên tmux để theo dõi
tmux attach-session -t setup
