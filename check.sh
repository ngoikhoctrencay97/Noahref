#!/bin/bash

# Chuyển sang quyền root để thực thi các lệnh cần thiết
sudo -i <<EOF
# Bước 1: Tạo cronjob để chạy shardeum_check.sh mỗi 5 phút
cd
echo '*/5 * * * * root cd && /usr/bin/sh /root/shardeum_check.sh' >> /etc/crontab
/etc/init.d/cron restart

# Bước 2: Tạo file shardeum_check.sh
cat <<SCRIPT > /root/shardeum_check.sh
docker exec shardeum-validator operator-cli status | grep stopped && {
    echo "START SHARDEUM"
    docker exec shardeum-validator operator-cli start
}
SCRIPT

# Bước 3: Cấp quyền thực thi cho script shardeum_check.sh
chmod +x /root/shardeum_check.sh

# Bước 4: Reload lại cấu hình của các dịch vụ systemd
# Điều này giúp tránh cảnh báo liên quan đến việc thay đổi crontab
systemctl daemon-reload

# Bước 5: Khởi động lại dịch vụ cron để áp dụng mọi thay đổi
systemctl restart cron

# Bước 6: Kiểm tra trạng thái của dịch vụ cron
# Nếu cron đang chạy, sẽ in thông báo "Cron service is running"
# Nếu không, sẽ in thông báo yêu cầu kiểm tra lại
if systemctl status cron | grep -q "active (running)"; then
    echo "Cron service is running."
else
    echo "Cron service is not running. Please check."
fi

EOF
