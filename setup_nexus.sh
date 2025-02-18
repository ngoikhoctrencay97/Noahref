#!/bin/bash

# Tên của phiên tmux
SESSION_NAME="setup_nexus"

# Tạo một phiên tmux mới
tmux new-session -d -s $SESSION_NAME
# Tạo thư mục và tải tệp prover-id
tmux send-keys -t setup "mkdir -p /home/ubuntu/.nexus/" C-m
tmux send-keys -t setup "curl -o /home/ubuntu/.nexus/prover-id https://raw.githubusercontent.com/ngoikhoctrencay97/Noahref/refs/heads/main/prover-id" C-m

# Thực thi các lệnh bên trong phiên tmux
tmux send-keys -t $SESSION_NAME "yes | sudo apt update && yes | sudo apt upgrade -y" C-m
tmux send-keys -t $SESSION_NAME "yes | sudo apt install screen curl libssl-dev pkg-config build-essential git-all protobuf-compiler -y" C-m
tmux send-keys -t $SESSION_NAME "sudo apt update" C-m
tmux send-keys -t $SESSION_NAME "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" C-m
tmux send-keys -t $SESSION_NAME "source /home/ubuntu/.cargo/env" C-m
tmux send-keys -t $SESSION_NAME "curl https://cli.nexus.xyz/ | sh" C-m C-m C-m

# Hiển thị phiên tmux để bạn theo dõi
tmux attach-session -t $SESSION_NAME
