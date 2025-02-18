#!/bin/bash

# Tạo một phiên tmux mới
tmux new-session -s setup -d
# Tạo thư mục và tải tệp prover-id
tmux send-keys -t setup "mkdir -p /home/ubuntu/.nexus/" C-m
tmux send-keys -t setup "curl -o /home/ubuntu/.nexus/prover-id https://raw.githubusercontent.com/ngoikhoctrencay97/Noahref/refs/heads/main/prover-id" C-m

# Thực thi các lệnh bên trong phiên tmux
tmux send-keys -t setup "yes | sudo apt update && yes | sudo apt upgrade -y" C-m
tmux send-keys -t setup "yes | sudo apt install screen curl libssl-dev pkg-config build-essential git-all protobuf-compiler -y" C-m
tmux send-keys -t setup "sudo apt update" C-m
tmux send-keys -t setup "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" C-m
tmux send-keys -t setup "source /home/ubuntu/.cargo/env" C-m
tmux send-keys -t setup "curl https://cli.nexus.xyz/ | sh" C-m C-m C-m

# Hiển thị phiên tmux để bạn theo dõi
tmux attach-session -t setup
