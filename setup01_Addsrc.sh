#!/bin/bash

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "该脚本必须以 root 权限运行" >&2
    exit 1
fi

# 定义变量
mariadb_version="10.11"  # 定义 MariaDB 版本
nginx_key_url="https://nginx.org/keys/nginx_signing.key"
nginx_keyring="/usr/share/keyrings/nginx-archive-keyring.gpg"
nginx_list="/etc/apt/sources.list.d/nginx.list"
nginx_pref="/etc/apt/preferences.d/99nginx"

php_key_url="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xB8DC7E53946656EFBCE4C1DD71DAEAAB4AD4CAB6"
php_keyring="/usr/share/keyrings/ondrej-ubuntu-php.gpg"
php_list="/etc/apt/sources.list.d/ondrej-ubuntu-php-noble.sources"

mariadb_key_url="https://mariadb.org/mariadb_release_signing_key.pgp"
mariadb_keyring="/usr/share/keyrings/mariadb-keyring.pgp"
mariadb_list="/etc/apt/sources.list.d/mariadb.list"

# 错误处理 - 遇到错误时结束脚本
set -e

# 更新 apt 包列表 - 确保包列表是最新的
echo "更新 apt 包列表..."
apt update

# 安装必要的依赖项
echo "安装必要的依赖项..."
apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring

# 添加 Nginx 软件源密钥
echo "添加 Nginx 软件源密钥..."
curl -fsSL "$nginx_key_url" | gpg --dearmor -o "$nginx_keyring"

# 添加 Nginx 软件源
echo "添加 Nginx 软件源..."
echo "deb [signed-by=$nginx_keyring] http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | tee "$nginx_list"

# 设置 Nginx 软件源优先级
echo "设置 Nginx 软件源优先级..."
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee "$nginx_pref"

# 添加 Ondřej Surý 的 PHP PPA 密钥
echo "添加 PHP PPA 密钥..."
curl -fsSL "$php_key_url" | gpg --dearmor -o "$php_keyring"

# 添加 PHP PPA 软件源
echo "添加 PHP PPA 软件源..."
cat <<EOF > "$php_list"
Types: deb
URIs: https://ppa.launchpadcontent.net/ondrej/php/ubuntu/
Suites: $(lsb_release -cs)
Components: main
Signed-By: $php_keyring
EOF

# 添加 MariaDB 软件源密钥
echo "添加 MariaDB 软件源密钥..."
curl -fsSL "$mariadb_key_url" -o "$mariadb_keyring"

# 添加 MariaDB 软件源，使用 mariadb_version 变量
echo "添加 MariaDB 软件源..."
echo "deb [signed-by=$mariadb_keyring] https://mirror1.hs-esslingen.de/pub/Mirrors/mariadb/repo/$mariadb_version/ubuntu $(lsb_release -cs) main" | tee "$mariadb_list"

# 更新 apt 包列表以反映新的软件源
echo "更新 apt 包列表..."
apt update

echo "脚本执行完毕，所有软件源已成功添加。"