#!/bin/bash

################################################################################
#                               Cloudflare IP Sync                             #
#                                                                              #
# Author: maooooozaizi                                                         #
# GitHub: https://github.com/yourusername/your-repository                      #
# Version: 1.0                                                                 #
#                                                                              #
# Description:                                                                 #
# This script syncs Cloudflare IP addresses and updates the Nginx configuration.#
################################################################################

# Configuration
CLOUDFLARE_FILE_PATH="/etc/nginx/cloudflare"
NGINX_CONFIG_TEST_COMMAND="nginx -t"
NGINX_RELOAD_COMMAND="systemctl reload nginx"

# Function to fetch and write IP addresses to the Cloudflare config file
fetch_and_write_ips() {
    local url="$1"
    local comment="$2"

    echo "$comment" >> "$CLOUDFLARE_FILE_PATH"
    
    # Use curl to fetch IP addresses, loop through them, and append to the config file
    curl -s -L "$url" | while read -r ip; do
        echo "set_real_ip_from $ip;" >> "$CLOUDFLARE_FILE_PATH"
    done

    echo "" >> "$CLOUDFLARE_FILE_PATH"
}

# Check if the file exists
if [ ! -f "$CLOUDFLARE_FILE_PATH" ]; then
    read -r -p "File $CLOUDFLARE_FILE_PATH does not exist. Do you want to create it? (yes/no): " create_file

    if [ "$create_file" != "yes" ]; then
        echo "Operation aborted."
        exit 1
    fi

    # Create the file
    touch "$CLOUDFLARE_FILE_PATH"
fi

# Clear existing content and add initial comment
echo "# Cloudflare" > "$CLOUDFLARE_FILE_PATH"

# Fetch and write IP addresses
fetch_and_write_ips "https://www.cloudflare.com/ips-v4" "# - IPv4"
fetch_and_write_ips "https://www.cloudflare.com/ips-v6" "# - IPv6"

# Add real_ip_header configuration
echo "real_ip_header CF-Connecting-IP;" >> "$CLOUDFLARE_FILE_PATH"

# Test Nginx configuration and reload
$NGINX_CONFIG_TEST_COMMAND && $NGINX_RELOAD_COMMAND
