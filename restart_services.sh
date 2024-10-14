#!/bin/bash

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "该脚本必须以 root 权限运行" >&2
    exit 1
fi

# 检查并获取系统安装的 PHP 版本
get_php_version() {
    php_version=$(php -v 2>/dev/null | grep -oP '^PHP \K[\d]+\.[\d]+' | head -n1)
    if [ -z "$php_version" ]; then
        echo "未找到安装的 PHP 版本！" >&2
        exit 1
    fi
    echo "$php_version"
}

php_version=$(get_php_version)

# 服务操作函数
restart_services() {
    echo "停止 Nginx 服务..."
    systemctl stop nginx.service

    echo "停止 PHP $php_version-fpm 服务..."
    systemctl stop php$php_version-fpm.service

    echo "重启 MariaDB 服务..."
    systemctl restart mariadb.service

    echo "启动 PHP $php_version-fpm 服务..."
    systemctl start php$php_version-fpm.service

    echo "启动 Redis 服务..."
    systemctl start redis-server.service

    echo "启动 Nginx 服务..."
    systemctl start nginx.service

    echo "所有服务已重启完毕！"
}

# 单个服务操作函数
restart_single_service() {
    case $1 in
        1)
            echo "重启 Nginx 服务..."
            systemctl restart nginx.service
            ;;
        2)
            echo "重启 PHP $php_version-fpm 服务..."
            systemctl restart php$php_version-fpm.service
            ;;
        3)
            echo "重启 MariaDB 服务..."
            systemctl restart mariadb.service
            ;;
        4)
            echo "重启 Redis 服务..."
            systemctl restart redis-server.service
            ;;
        5)
            echo "重启所有服务..."
            restart_services
            ;;
        *)
            echo "无效选项，请重试！"
            ;;
    esac
}

# 显示菜单并获取用户选择
show_menu() {
    echo "请选择要重启的服务："
    echo "1) Nginx"
    echo "2) PHP $php_version-fpm"
    echo "3) MariaDB"
    echo "4) Redis"
    echo "5) 全部重启"
    echo "6) 退出"
    read -p "请输入您的选择: " choice

    if [ "$choice" == "6" ]; then
        echo "已退出！"
        exit 0
    fi

    restart_single_service "$choice"
}

# 主函数
main() {
    while true; do
        show_menu
    done
}

# 执行主函数
main
