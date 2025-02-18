#!/bin/bash

# Tên của phiên tmux
SESSION_NAME="setup_nexus"

# Tạo một phiên tmux mới
tmux new-session -d -s $SESSION_NAME

# Thực thi các lệnh bên trong phiên tmux
tmux send-keys -t $SESSION_NAME "yes | sudo apt update && yes | sudo apt upgrade -y" C-m
tmux send-keys -t $SESSION_NAME "yes | sudo apt install screen curl libssl-dev pkg-config build-essential git-all protobuf-compiler -y" C-m
tmux send-keys -t $SESSION_NAME "sudo apt update" C-m
tmux send-keys -t $SESSION_NAME "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" C-m
tmux send-keys -t $SESSION_NAME "source \$HOME/.cargo/env" C-m
tmux send-keys -t $SESSION_NAME "curl https://cli.nexus.xyz/ | sh" C-m C-m C-m

# Dừng script tại đây (tương đương nhấn Ctrl+C)
sleep 600
tmux send-keys -t $SESSION_NAME C-c

# Tiếp tục thực thi các lệnh còn lại
tmux send-keys -t $SESSION_NAME "curl -o /home/ubuntu/.nexus/prover-id https://raw.githubusercontent.com/ngoikhoctrencay97/Noahref/refs/heads/main/prover-id" C-m
tmux send-keys -t $SESSION_NAME "curl https://cli.nexus.xyz/ | sh" C-m C-m C-m

# Hiển thị phiên tmux để bạn theo dõi
tmux attach-session -t $SESSION_NAME
