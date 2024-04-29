#!/bin/bash

# 检查是否为 root 用户
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# 检查是否提供了 PHP 版本号
if [ -z "$1" ]; then
    echo "Usage: $0 <php_version>"
    exit 1
fi

php_version="$1"

# 自定义变量
pm_max_children=59
pm_start_servers=29
pm_min_spare_servers=19
pm_max_spare_servers=39

# 替换配置文件中的值并执行相应命令
sed -i "s/;env\[HOSTNAME\] = /env[HOSTNAME] = /" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/;env\[TMP\] = /env[TMP] = /" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/;env\[TMPDIR\] = /env[TMPDIR] = /" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/;env\[TEMP\] = /env[TEMP] = /" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/;env\[PATH\] = /env[PATH] = /" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i 's/pm = dynamic/pm = ondemand/' /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/pm.max_children =.*/pm.max_children = $pm_max_children/" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/pm.start_servers =.*/pm.start_servers = $pm_start_servers/" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/pm.min_spare_servers =.*/pm.min_spare_servers = $pm_min_spare_servers/" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/pm.max_spare_servers =.*/pm.max_spare_servers = $pm_max_spare_servers/" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/;pm.max_requests =.*/pm.max_requests = 1000/" /etc/php/"$php_version"/fpm/pool.d/www.conf
sed -i "s/allow_url_fopen =.*/allow_url_fopen = 1/" /etc/php/"$php_version"/fpm/php.ini

sed -i "s/output_buffering =.*/output_buffering = Off/" /etc/php/"$php_version"/cli/php.ini
sed -i "s/max_execution_time =.*/max_execution_time = 3600/" /etc/php/"$php_version"/cli/php.ini
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/"$php_version"/cli/php.ini
sed -i "s/post_max_size =.*/post_max_size = 10240M/" /etc/php/"$php_version"/cli/php.ini
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10240M/" /etc/php/"$php_version"/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = Asia\/\Shanghai/" /etc/php/"$php_version"/cli/php.ini
sed -i "s/;cgi.fix_pathinfo.*/cgi.fix_pathinfo=0/" /etc/php/"$php_version"/cli/php.ini

sed -i "s/memory_limit = 128M/memory_limit = 1G/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/output_buffering =.*/output_buffering = Off/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/max_execution_time =.*/max_execution_time = 3600/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/max_input_time =.*/max_input_time = 3600/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/post_max_size =.*/post_max_size = 10G/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/upload_max_filesize =.*/upload_max_filesize = 10G/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = Asia\/\Shanghai/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo.*/cgi.fix_pathinfo=0/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;session.cookie_secure.*/session.cookie_secure = True/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.enable=.*/opcache.enable=1/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.validate_timestamps=.*/opcache.validate_timestamps=1/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.enable_cli=.*/opcache.enable_cli=1/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.memory_consumption=.*/opcache.memory_consumption=256/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.interned_strings_buffer=.*/opcache.interned_strings_buffer=64/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.max_accelerated_files=.*/opcache.max_accelerated_files=100000/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.revalidate_freq=.*/opcache.revalidate_freq=0/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.save_comments=.*/opcache.save_comments=1/" /etc/php/"$php_version"/fpm/php.ini
sed -i "s/;opcache.huge_code_pages=.*/opcache.huge_code_pages=0/" /etc/php/"$php_version"/fpm/php.ini

sed -i "s|;emergency_restart_threshold.*|emergency_restart_threshold = 10|g" /etc/php/"$php_version"/fpm/php-fpm.conf
sed -i "s|;emergency_restart_interval.*|emergency_restart_interval = 1m|g" /etc/php/"$php_version"/fpm/php-fpm.conf
sed -i "s|;process_control_timeout.*|process_control_timeout = 10|g" /etc/php/"$php_version"/fpm/php-fpm.conf

sed -i "\$aapc.enable_cli=1" /etc/php/"$php_version"/mods-available/apcu.ini

sed -i "\$aopcache.jit=1255" /etc/php/"$php_version"/mods-available/opcache.ini
sed -i "\$aopcache.jit_buffer_size=256M" /etc/php/"$php_version"/mods-available/opcache.ini

sed -i "\$a[mysql]" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.allow_local_infile=On" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.allow_persistent=On" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.cache_size=2000" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.max_persistent=-1" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.max_links=-1" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.default_port=3306" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.connect_timeout=60" /etc/php/"$php_version"/mods-available/mysqli.ini
sed -i "\$amysql.trace_mode=Off" /etc/php/"$php_version"/mods-available/mysqli.ini

systemctl restart php"$php_version"-fpm.service nginx.service