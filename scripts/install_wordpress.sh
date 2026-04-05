#!/bin/bash
set -euo pipefail
exec > /var/log/wordpress-install.log 2>&1

echo "=== Starting WordPress installation: $(date) ==="

# System updates
dnf update -y

# Install Apache and PHP
dnf install -y httpd php php-mysqlnd php-fpm php-gd php-mbstring php-xml wget

# Start and enable services
systemctl start httpd
systemctl enable httpd
systemctl start php-fpm
systemctl enable php-fpm

# Configure PHP-FPM with Apache
cat >> /etc/httpd/conf.d/php-fpm.conf <<'PHPCONF'
<FilesMatch \.php$>
    SetHandler "proxy:unix:/run/php-fpm/www.sock|fcgi://localhost"
</FilesMatch>
PHPCONF

systemctl restart httpd php-fpm

# Download WordPress
cd /var/www/html
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

# Configure wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${db_name}/"      wp-config.php
sed -i "s/username_here/${db_username}/"        wp-config.php
sed -i "s/password_here/${db_password}/"        wp-config.php
sed -i "s/localhost/${db_host}/"                wp-config.php

# Fix permissions
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

systemctl restart httpd

echo "=== WordPress installation complete: $(date) ==="