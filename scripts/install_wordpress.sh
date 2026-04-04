#!/bin/bash
set -euo pipefail
exec > /var/log/wordpress-install.log 2>&1

echo "=== Starting WordPress installation: $(date) ==="

# System updates
dnf update -y

# Install Apache, PHP, and MariaDB
dnf install -y httpd mariadb105-server php php-mysqlnd php-fpm php-gd php-mbstring php-xml wget

# Start and enable services
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb

# Configure database
mysql -u root <<'EOF'
CREATE DATABASE IF NOT EXISTS ${db_name};
CREATE USER IF NOT EXISTS '${db_user}'@'localhost' IDENTIFIED BY '${db_password}';
GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download WordPress
cd /tmp
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

# Configure wp-config.php
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i "s/database_name_here/${db_name}/" /var/www/html/wp-config.php
sed -i "s/username_here/${db_user}/"      /var/www/html/wp-config.php
sed -i "s/password_here/${db_password}/"  /var/www/html/wp-config.php

# Fix permissions
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

systemctl restart httpd

echo "=== WordPress installation complete: $(date) ==="