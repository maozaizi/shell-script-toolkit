#!/bin/bash
set -e  # 遇到错误停止脚本执行

# 函数定义：清理不再需要的包
cleanup_packages() {
    echo ">> 自动删除不再需要的包..."
    apt-get autoremove -y
}

# 函数定义：清理 apt 缓存
cleanup_cache() {
    echo ">> 清理 apt 下载缓存..."
    apt-get clean
    echo ">> 清理旧的 .deb 文件..."
    apt-get autoclean
}

# 执行清理操作
echo ">> 开始系统清理..."
cleanup_packages
cleanup_cache
echo ">> 清理完成！"