#!/bin/bash

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "该脚本必须以 root 权限运行" >&2
    exit 1
fi

# 获取系统中安装的 PHP 版本
installed_php_version=$(php -v | head -n 1 | cut -d " " -f 2 | cut -d "." -f 1,2)

# 提示用户输入 PHP 版本号
echo "检测到系统当前 PHP 版本为: $installed_php_version"
read -p "请输入要备份的 PHP 版本号（例如: 8.3 或 $installed_php_version）: " user_php_version

# 校验用户输入的 PHP 版本号是否为空
if [ -z "$user_php_version" ]; then
    echo "错误: 版本号不能为空" >&2
    exit 1
fi

# 检查用户输入的 PHP 版本是否存在
if ! [ -d "/etc/php/$user_php_version" ]; then
    echo "错误: PHP 版本 $user_php_version 未安装或目录不存在" >&2
    exit 1
fi

# 开始备份 PHP 配置文件
echo "正在备份 PHP 版本 $user_php_version 的配置文件..."

backup_files=(
    "/etc/php/$user_php_version/fpm/pool.d/www.conf"
    "/etc/php/$user_php_version/fpm/php-fpm.conf"
    "/etc/php/$user_php_version/cli/php.ini"
    "/etc/php/$user_php_version/fpm/php.ini"
    "/etc/php/$user_php_version/mods-available/apcu.ini"
    "/etc/php/$user_php_version/mods-available/opcache.ini"
    "/etc/ImageMagick-6/policy.xml"
)

# 遍历文件列表并创建备份
for file in "${backup_files[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$file.bak"
        echo "备份 $file 成功"
    else
        echo "警告: $file 不存在，跳过备份"
    fi
done

# 重启 PHP-FPM 服务
systemctl restart "php$user_php_version-fpm.service"
echo "PHP $user_php_version 的 PHP-FPM 服务已重启"

echo "备份完成并重启服务。"

