#!/bin/bash

# 设置错误处理
set -e
trap 'echo "备份失败! 错误发生在第 $LINENO 行"; exit 1' ERR

# 配置信息
CONFIG_FILE="/etc/wordpress_backup.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    # WordPress 网站根目录路径
    wordpress_root="/var/www/wordpress"
    # 数据库配置
    db_user="root"
    db_password="7q:7JhNaeqWixDvH"
    db_name="wp_db"
    # 备份路径
    backup_dir="/var/backups/blog.walamoguleisi.com"
fi

# 获取当前系统时间戳
timestamp=$(date +"%Y%m%d%H%M%S")

# 日志函数
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# 检查必要工具
for cmd in mysqldump tar gzip; do
    if ! command -v $cmd &> /dev/null; then
        log "错误: 未找到命令 $cmd"
        exit 1
    fi
done

# 创建备份目录
if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
    log "创建备份目录：$backup_dir"
fi

# 备份文件夹列表
source_dirs=(
    "$wordpress_root/wp-content"
    "$wordpress_root/wp-config.php"
    "$wordpress_root/.htaccess"
)

# 检查源文件是否存在
for dir in "${source_dirs[@]}"; do
    if [ ! -e "$dir" ]; then
        log "错误: 源文件/目录不存在: $dir"
        exit 1
    fi
done

# 构建备份文件名
backup_filename="$backup_dir/wordpress_backup_${timestamp}.tar.gz"
db_backup_filename="$backup_dir/wordpress_db_backup_${timestamp}.sql.gz"

# 执行文件备份
log "开始备份 WordPress 文件..."
if tar -czf "$backup_filename" "${source_dirs[@]}"; then
    log "WordPress文件备份完成: $backup_filename"
else
    log "WordPress文件备份失败!"
    exit 1
fi

# 备份数据库
log "开始备份数据库..."
if mysqldump -u "$db_user" -p"$db_password" "$db_name" | gzip > "$db_backup_filename"; then
    log "数据库备份完成: $db_backup_filename"
else
    log "数据库备份失败!"
    exit 1
fi

# 清理旧备份（保留最近7天的备份）
find "$backup_dir" -name "wordpress_*" -type f -mtime +7 -delete

# 显示备份大小信息
backup_size=$(du -sh "$backup_filename" | cut -f1)
db_backup_size=$(du -sh "$db_backup_filename" | cut -f1)
log "备份完成!"
log "文件备份大小: $backup_size"
log "数据库备份大小: $db_backup_size"
