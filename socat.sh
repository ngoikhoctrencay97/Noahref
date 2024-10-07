#!/bin/bash

# Chuyển sang quyền root để thực thi các lệnh cần thiết
sudo -i <<'EOF'

# Bước 1: Cài đặt socat và mở cổng 8888 với ufw
sudo apt-get install socat -y
sudo ufw allow 8888

# Bước 2: Tạo folder và file check_node_status.sh
mkdir -p /home/user/scripts
touch /home/user/scripts/check_node_status.sh

# Bước 3: Tạo script kiểm tra trạng thái node Shardeum
cat <<'SCRIPT' > /home/user/scripts/check_node_status.sh
#!/bin/bash

# Kiểm tra trạng thái của node Shardeum
NODE_STATUS=$(docker exec shardeum-dashboard operator-cli status)

# Tạo HTTP header và response dưới dạng JSON
echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n"
echo -e "{ \"status\": \"Success\", \"node_status\": \"$(echo "$NODE_STATUS" | sed ':a;N;$!ba;s/\n/\\n/g')\" }"
SCRIPT

# Bước 4: Cấp quyền thực thi cho check_node_status.sh
chmod +x /home/user/scripts/check_node_status.sh

# Bước 5: Khởi động dịch vụ sử dụng socat trên cổng 8888
tmux new-session -d -s socat_session "socat TCP-LISTEN:8888,fork EXEC:/home/user/scripts/check_node_status.sh"

EOF

# Kết thúc script
