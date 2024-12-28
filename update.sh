#!/usr/bin/env expect

# Kiểm tra trạng thái node Shardeum
set status [exec docker exec shardeum-dashboard operator-cli status | grep -i "state: active"]

# Nếu trạng thái không phải "active", thực hiện lệnh cài đặt
if {$status eq ""} {
    puts "State is not 'active'. Running installation script..."
    
    # Tải xuống script cài đặt
    curl -O https://raw.githubusercontent.com/shardeum/shardeum-validator/refs/heads/itn4/install.sh
    chmod +x install.sh

    # Chạy script cài đặt
    spawn ./install.sh

    # Xử lý tự động các yêu cầu trong quá trình cài đặt
    expect {
        "By running this installer, you agree to allow the Shardeum team to collect this data. (Y/n)?:" {
            send "\r"
            exp_continue
        }
        "What base directory should the node use (default ~/shardeum):" {
            send "\r"
            exp_continue
        }
        "Do you want to run the web based Dashboard? (Y/n)" {
            send "\r"
            exp_continue
        }
        "Enter the port (1025-65536) to access the web based Dashboard (default 8080)" {
            send "\r"
            exp_continue
        }
        "If you wish to set an explicit external IP, enter an IPv4 address (default=auto)" {
            send "\r"
            exp_continue
        }
        "If you wish to set an explicit internal IP, enter an IPv4 address (default=auto)" {
            send "\r"
            exp_continue
        }
        "This allows p2p communication between nodes. Enter the first port (1025-65536) for p2p communication (default 9001)" {
            send "\r"
            exp_continue
        }
        "Enter the second port (1025-65536) for p2p communication (default 10001)" {
            send "\r"
            exp_continue
        }
        # Nhập mật khẩu khi được yêu cầu
        "Enter the password for accessing the Dashboard:" {
            send "1Chutdamme*\r"
            exp_continue
        }

        # Gửi "yes" cho câu hỏi xác nhận
        "Do you want to continue? (yes/no)" {
            send "yes\r"
            exp_continue
        }

        # Gửi Enter mặc định cho bất kỳ yêu cầu nào khác
        default {
            send "\r"
            exp_continue
        }
    }
} else {
    puts "State is 'active'. No action required."
}
