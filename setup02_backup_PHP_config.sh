#!/bin/bash

# 检查是否为 root 用户
if [ "$(id -u)" -ne 0 ]; then
    echo "该脚本必须以 root 用户身份运行"
    exit 1
fi

# 检查是否提供了 PHP 版本号
if [ -z "$1" ]; then
    echo "用法: $0 <php_version>"
    exit 1
fi

php_version="$1"

# 备份文件
cp "/etc/php/$php_version/fpm/pool.d/www.conf" "/etc/php/$php_version/fpm/pool.d/www.conf.bak"
cp "/etc/php/$php_version/fpm/php-fpm.conf" "/etc/php/$php_version/fpm/php-fpm.conf.bak"
cp "/etc/php/$php_version/cli/php.ini" "/etc/php/$php_version/cli/php.ini.bak"
cp "/etc/php/$php_version/fpm/php.ini" "/etc/php/$php_version/fpm/php.ini.bak"
cp "/etc/php/$php_version/mods-available/apcu.ini" "/etc/php/$php_version/mods-available/apcu.ini.bak"
cp "/etc/php/$php_version/mods-available/opcache.ini" "/etc/php/$php_version/mods-available/opcache.ini.bak"
cp "/etc/ImageMagick-6/policy.xml" "/etc/ImageMagick-6/policy.xml.bak"

# 重启 php-fpm 服务
systemctl restart "php$php_version-fpm.service"

echo "备份和 PHP 版本 $php_version 配置已完成"

# 检查备份文件是否存在
check_backup_files() {
    local files=(
        "/etc/php/$php_version/fpm/pool.d/www.conf.bak"
        "/etc/php/$php_version/fpm/php-fpm.conf.bak"
        "/etc/php/$php_version/cli/php.ini.bak"
        "/etc/php/$php_version/fpm/php.ini.bak"
        "/etc/php/$php_version/mods-available/apcu.ini.bak"
        "/etc/php/$php_version/mods-available/opcache.ini.bak"
        "/etc/ImageMagick-6/policy.xml.bak"
    )

    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "$file 已经创建"
        else
            echo "$file 未找到"
        fi
    done
}

# 执行函数
check_backup_files
