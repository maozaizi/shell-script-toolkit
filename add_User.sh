#!/bin/bash

# 检查是否具有管理员权限
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Aborting."
    exit 1
fi

# 函数：创建用户并添加到 sudo 组
create_user() {
    local username="$1"
    
    # 创建用户并设置密码
    sudo useradd -m -s /bin/bash "$username"
    if [ $? -ne 0 ]; then
        echo "Failed to create user $username. Aborting."
        exit 1
    fi

    # 将用户添加到 sudo 组
    sudo usermod -aG sudo "$username"
    if [ $? -ne 0 ]; then
        echo "Failed to add $username to sudo group. Aborting."
        exit 1
    fi

    # 创建 sudo 免密码配置文件
    SUDOERS_FILE="/etc/sudoers.d/$username"
    if [ ! -f "$SUDOERS_FILE" ]; then
        echo "$username ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "$SUDOERS_FILE" >/dev/null
        # 重新加载 sudo 配置以使其生效
        sudo systemctl reload sudo
    fi

    echo "User $username created successfully and added to sudo group with NOPASSWD permission."
}

# 主程序
main() {
    # 提示用户输入新用户名
    read -p "Enter the username for the new user: " new_username

    # 检查输入是否为空
    if [ -z "$new_username" ]; then
        echo "Username cannot be empty. Aborting."
        exit 1
    fi

    # 检查新用户名是否已存在
    if id "$new_username" &>/dev/null; then
        echo "User $new_username already exists. Aborting."
        exit 1
    fi

    create_user "$new_username"
}

# 执行主程序
main
