#!/bin/bash

# 检查是否以 root 权限执行
if [ "$(id -u)" -ne 0 ]; then
   echo "该脚本必须以 root 权限运行" >&2
   exit 1
fi

# 定义变量
mariadb_version="10.6"
nginx_key_url="https://nginx.org/keys/nginx_signing.key"
mariadb_key_url="https://mariadb.org/mariadb_release_signing_key.pgp"
mariadb_repo_url="https://mirrors.gigenet.com/mariadb/repo/${mariadb_version}/ubuntu"
nginx_archive_keyring="/usr/share/keyrings/nginx-archive-keyring.gpg"
mariadb_keyring="/usr/share/keyrings/mariadb-keyring.gpg"

# 错误处理 - 遇到错误时结束脚本
set -e

# 更新 apt 包列表 - 确保我们的包列表是最新的
apt update

# 安装 ubuntu-keyring，如果未安装
apt install -y ubuntu-keyring

# 添加 Nginx 软件源密钥
curl -fsSL "$nginx_key_url" | gpg --dearmor -o "$nginx_archive_keyring"

# 添加 Nginx 软件源
echo "deb [signed-by=$nginx_archive_keyring] http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list

# 配置 Nginx 软件源优先级
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx

# 添加 Ondřej Surý 的 PHP PPA
add-apt-repository -y ppa:ondrej/php

# 添加 MariaDB 软件源密钥
curl -fsSL "$mariadb_key_url" | gpg --dearmor -o "$mariadb_keyring"

# 添加 MariaDB 软件源
echo "deb [signed-by=$mariadb_keyring] $mariadb_repo_url $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/mariadb.list

# 更新 apt 包列表以反映新添加的软件源
apt update
