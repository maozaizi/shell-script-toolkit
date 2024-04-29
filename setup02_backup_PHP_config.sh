#!/bin/bash

# 函数：检查是否为 root 用户
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# 函数：备份文件
backup_files() {
    local source_dir="/etc/php/$php_version"
    local backup_dir="$source_dir.bak"

    # 确保备份目录存在
    mkdir -p "$backup_dir" || { echo "Failed to create backup directory"; exit 1; }

    # 定义需要备份的文件列表
    local files=(
        "fpm/pool.d/www.conf"
        "fpm/php-fpm.conf"
        "cli/php.ini"
        "fpm/php.ini"
        "mods-available/apcu.ini"
        "mods-available/opcache.ini"
    )

    # 备份文件并打印文件名和路径
    for file in "${files[@]}"; do
        if [ -f "$source_dir/$file" ]; then
            cp "$source_dir/$file" "$backup_dir/${file##*/}.bak" || { echo "Failed to backup $file"; exit 1; }
            echo "Backup: $backup_dir/${file##*/}.bak"
        else
            echo "File not found: $source_dir/$file"
        fi
    done
}

# 函数：重启 php-fpm 服务
restart_php_fpm() {
    systemctl restart "php$php_version-fpm.service"
}

# 主函数
main() {
    # 检查是否为 root 用户
    check_root

    # 检查是否提供了 PHP 版本号
    if [ -z "$1" ]; then
        echo "Usage: $0 <php_version>"
        exit 1
    fi

    php_version="$1"

    # 备份 ImageMagick 的 policy.xml 文件
    cp /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.bak
    echo "Backup: /etc/ImageMagick-6/policy.xml.bak"

    # 执行备份和重启服务
    backup_files
    restart_php_fpm

    echo "Backup and PHP version $php_version configuration completed."

}

# 执行主函数
main "$@"
