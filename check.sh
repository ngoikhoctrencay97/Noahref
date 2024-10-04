#!/bin/bash

# Chuyển sang quyền root để thực thi các lệnh cần thiết
sudo -i <<EOF
# Bước 1: Tạo cronjob để chạy shardeum_check.sh mỗi 5 phút
cd
echo '*/5 * * * * root cd && /usr/bin/sh /root/shardeum_check.sh' >> /etc/crontab
/etc/init.d/cron restart

# Bước 2: Tạo file shardeum_check.sh
cat <<SCRIPT > /root/shardeum_check.sh
docker exec shardeum-dashboard operator-cli status | grep stopped
if docker exec shardeum-dashboard operator-cli status | grep -q stopped; then
    echo "START SHARDEUM"
    docker exec shardeum-dashboard operator-cli start
fi
SCRIPT

# Bước 3: Cấp quyền thực thi cho script shardeum_check.sh
chmod +x /root/shardeum_check.sh
EOF
