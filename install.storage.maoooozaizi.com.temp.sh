mysql -uroot -p -e "CREATE DATABASE nc_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; CREATE USER nc_db_user@localhost identified by 'WDj@_PP20xNZ2Nfy'; GRANT ALL PRIVILEGES on nc_db.* to nc_db_user@localhost; FLUSH privileges;"

mysql -h localhost -uroot -p -e "SELECT @@TX_ISOLATION; SELECT SCHEMA_NAME 'database', default_character_set_name 'charset', DEFAULT_COLLATION_NAME 'collation' FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='nc_db'"


sed -i 's/# requirepass foobared/requirepass 37bd3.2p*MGDW6B1/' /etc/redis/redis.conf


upstream php-handler {
server unix:/run/php/php8.3-fpm.sock;
}
map $arg_v $asset_immutable {
"" "";
default "immutable";
}
server {
listen 80 default_server;
listen [::]:80 default_server;
server_name storage.maoooozaizi.com;
root /var/www;
location ^~ /.well-known/acme-challenge {
default_type text/plain;
root /var/www/letsencrypt;
}
location / {
return 301 https://$host$request_uri;
}
}



limit_req_zone $binary_remote_addr zone=NextcloudRateLimit:10m rate=2r/s;
server {
listen 443      ssl default_server;
listen [::]:443 ssl default_server;
http2 on;
server_name storage.maoooozaizi.com;
ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
ssl_trusted_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
#ssl_certificate /etc/letsencrypt/rsa-certs/fullchain.pem;
#ssl_certificate_key /etc/letsencrypt/rsa-certs/privkey.pem;
#ssl_certificate /etc/letsencrypt/ecc-certs/fullchain.pem;
#ssl_certificate_key /etc/letsencrypt/ecc-certs/privkey.pem;
#ssl_trusted_certificate /etc/letsencrypt/ecc-certs/chain.pem;
ssl_dhparam /etc/ssl/certs/dhparam.pem;
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;
ssl_protocols TLSv1.3 TLSv1.2;
ssl_ciphers 'TLS-CHACHA20-POLY1305-SHA256:TLS-AES-256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384';
ssl_ecdh_curve X448:secp521r1:secp384r1;
ssl_prefer_server_ciphers on;
ssl_stapling on;
ssl_stapling_verify on;
client_max_body_size 10G;
client_body_timeout 3600s;
client_body_buffer_size 512k;
fastcgi_buffers 64 4K;
gzip on;
gzip_vary on;
gzip_comp_level 4;
gzip_min_length 256;
gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
gzip_types application/atom+xml text/javascript application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/wasm application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
add_header Strict-Transport-Security            "max-age=15768000; includeSubDomains; preload;" always;
add_header Permissions-Policy                   "interest-cohort=()";
add_header Referrer-Policy                      "no-referrer"   always;
add_header X-Content-Type-Options               "nosniff"       always;
add_header X-Download-Options                   "noopen"        always;
add_header X-Frame-Options                      "SAMEORIGIN"    always;
add_header X-Permitted-Cross-Domain-Policies    "none"          always;
add_header X-Robots-Tag                         "noindex, nofollow" always;
add_header X-XSS-Protection                     "1; mode=block" always;
fastcgi_hide_header X-Powered-By;
include mime.types;
types {
text/javascript mjs;
}
root /var/www/nextcloud;
index index.php index.html /index.php$request_uri;
location = / {
if ( $http_user_agent ~ ^DavClnt ) {
return 302 /remote.php/webdav/$is_args$args;
}
}
location = /robots.txt {
allow all;
log_not_found off;
access_log off;
}
location ^~ /.well-known {
location = /.well-known/carddav { return 301 /remote.php/dav/; }
location = /.well-known/caldav  { return 301 /remote.php/dav/; }
location /.well-known/acme-challenge { try_files $uri $uri/ =404; }
location /.well-known/pki-validation { try_files $uri $uri/ =404; }
return 301 /index.php$request_uri;
}
location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)  { return 404; }
location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }
location ~ \.php(?:$|/) {
rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|ocs-provider\/.+|.+\/richdocumentscode\/proxy) /index.php$request_uri;
fastcgi_split_path_info ^(.+?\.php)(/.*)$;
set $path_info $fastcgi_path_info;
try_files $fastcgi_script_name =404;
include fastcgi_params;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
fastcgi_param PATH_INFO $path_info;
fastcgi_param HTTPS on;
fastcgi_param modHeadersAvailable true;
fastcgi_param front_controller_active true;
fastcgi_pass php-handler;
fastcgi_intercept_errors on;
fastcgi_request_buffering off;
fastcgi_read_timeout 3600;
fastcgi_send_timeout 3600;
fastcgi_connect_timeout 3600;
fastcgi_max_temp_file_size 0;
}
location ~ \.(?:css|js|mjs|svg|gif|png|jpg|ico|wasm|tflite|map|ogg|flac)$ {
try_files $uri /index.php$request_uri;
add_header Cache-Control "public, max-age=15778463, $asset_immutable";
expires 6M;
access_log off;
location ~ \.wasm$ {
default_type application/wasm;
}
}
location ~ \.woff2?$ {
try_files $uri /index.php$request_uri;
expires 7d;
access_log off;
}
location /remote {
return 301 /remote.php$request_uri;
}
location /login {
limit_req zone=NextcloudRateLimit burst=5 nodelay;
limit_req_status 429;
try_files $uri $uri/ /index.php$request_uri;
}
location / {
try_files $uri $uri/ /index.php$request_uri;
}
}


acme.sh --issue -d storage.maoooozaizi.com --server letsencrypt --keylength 4096 -w /var/www/letsencrypt --key-file /etc/letsencrypt/rsa-certs/privkey.pem --ca-file /etc/letsencrypt/rsa-certs/chain.pem --cert-file /etc/letsencrypt/rsa-certs/cert.pem --fullchain-file /etc/letsencrypt/rsa-certs/fullchain.pem --reloadcmd "sudo /bin/systemctl reload nginx.service"

acme.sh --issue -d storage.maoooozaizi.com --server letsencrypt --keylength ec-384 -w /var/www/letsencrypt --key-file /etc/letsencrypt/ecc-certs/privkey.pem --ca-file /etc/letsencrypt/ecc-certs/chain.pem --cert-file /etc/letsencrypt/ecc-certs/cert.pem --fullchain-file /etc/letsencrypt/ecc-certs/fullchain.pem --reloadcmd "sudo /bin/systemctl reload nginx.service"


sudo -u www-data php /var/www/nextcloud/occ maintenance:install --database "mysql" --database-name "nc_db" --database-user "nc_db_user" --database-pass "WDj@_PP20xNZ2Nfy" --admin-user "wangfy_admin" --admin-pass "B=t3iMqKL2Xx1o" --data-dir "/var/nc_data"


sudo -u www-data php /var/www/nextcloud/occ config:system:set trusted_domains 0 --value=64.69.36.58

sudo -u www-data php /var/www/nextcloud/occ config:system:set trusted_domains 1 --value=storage.maoooozaizi.com

sudo -u www-data php /var/www/nextcloud/occ config:system:set overwrite.cli.url --value=https://storage.maoooozaizi.com

sudo -u www-data php /var/www/nextcloud/occ config:system:set overwritehost --value=storage.maoooozaizi.com



cat <<EOF >>/var/www/nextcloud/config/config.php
  'activity_expire_days' => 14,
  'allow_local_remote_servers' => true,
  'auth.bruteforce.protection.enabled' => true,
  'forbidden_filenames' =>
  array (
    0 => '.htaccess',
    1 => 'Thumbs.db',
    2 => 'thumbs.db',
    ),
    'cron_log' => true,
    'default_phone_region' => 'CN',
    'enable_previews' => true,
    'enabledPreviewProviders' =>
        array (
      0 => 'OC\\Preview\\PNG',
      1 => 'OC\\Preview\\JPEG',
      2 => 'OC\\Preview\\GIF',
      3 => 'OC\\Preview\\BMP',
      4 => 'OC\\Preview\\XBitmap',
      5 => 'OC\\Preview\\Movie',
      6 => 'OC\\Preview\\PDF',
      7 => 'OC\\Preview\\MP3',
      8 => 'OC\\Preview\\TXT',
      9 => 'OC\\Preview\\MarkDown',
      10 => 'OC\\Preview\\HEIC',
      11 => 'OC\\Preview\\Movie',
      12 => 'OC\\Preview\\MKV',
      13 => 'OC\\Preview\\MP4',
      14 => 'OC\\Preview\\AVI',
      ),
      'filesystem_check_changes' => 0,
      'filelocking.enabled' => 'true',
      'htaccess.RewriteBase' => '/',
      'integrity.check.disabled' => false,
      'knowledgebaseenabled' => false,
      'log_rotate_size' => '104857600',
      'logfile' => '/var/log/nextcloud/nextcloud.log',
      'loglevel' => 2,
      'logtimezone' => 'Asia/Shanghai',
      'memcache.local' => '\\\\OC\\\\Memcache\\\\APCu',
      'memcache.locking' => '\\\\OC\\\\Memcache\\\\Redis',
      'overwriteprotocol' => 'https',
      'preview_max_x' => 1024,
      'preview_max_y' => 768,
      'preview_max_scale_factor' => 1,
      'profile.enabled' => false,
      'redis' =>
      array (
        'host' => '/var/run/redis/redis-server.sock',
        'port' => 0,
        'password' => '37bd3.2p*MGDW6B1',
        'timeout' => 0.5,
        'dbindex' => 1,
        ),
        'quota_include_external_storage' => false,
        'share_folder' => '/Freigaben',
        'skeletondirectory' => '',
        'trashbin_retention_obligation' => 'auto, 7',
        'maintenance_window_start' => 1,
        );
EOF