#!/bin/bash
set -e

WP_PATH="/var/www/wordpress"
WP_CLI="/usr/local/bin/wp"

echo "=========================================="
echo "  WordPress Auto-Configuration Script"
echo "=========================================="

# ==========================================
# 1. 下载 WP-CLI（用于自动安装）
# ==========================================
if [ ! -f "$WP_CLI" ]; then
    echo "📥 Downloading WP-CLI..."
    curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar "$WP_CLI"
    echo "✅ WP-CLI installed"
else
    echo "✅ WP-CLI already installed"
fi

# ==========================================
# 2. 下载 WordPress（官方源）
# ==========================================
if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "📥 Downloading WordPress from official source..."
    cd /tmp
    curl -sO https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* "$WP_PATH/"
    rm -rf wordpress latest.tar.gz
    echo "✅ WordPress downloaded"
else
    echo "✅ WordPress already downloaded"
fi

# ==========================================
# 3. 等待 MariaDB 就绪
# ==========================================
echo "⏳ Waiting for MariaDB..."
until mysql -h mariadb -u"$DB_NAME_USER" -p"$DB_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done
echo "✅ MariaDB is ready"

# ==========================================
# 4. 生成 wp-config.php
# ==========================================
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "📝 Creating wp-config.php..."
    
    "$WP_CLI" config create \
        --path="$WP_PATH" \
        --dbname="$DB_NAME" \
        --dbuser="$DB_NAME_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost=mariadb \
        --allow-root \
        --skip-check
        
    
    echo "✅ wp-config.php created"
else
    echo "✅ wp-config.php already exists"
fi

# ==========================================
# 5. 自动安装 WordPress（核心部分）
# ==========================================
echo "🔍 Checking WordPress installation status..."

if ! "$WP_CLI" core is-installed --path="$WP_PATH" --allow-root 2>/dev/null; then
    echo "📦 Installing WordPress..."
    
    "$WP_CLI" core install \
        --path="$WP_PATH" \
        --url="https://${DOMAIN_NAME}" \
        #--url="https://localhost:8443" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_LOGIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_MAIL" \
        --skip-email \
        --allow-root
    
    echo "✅ WordPress installed successfully!"
else
    echo "✅ WordPress already installed"
fi

# ==========================================
# 6. 创建第二个用户（评估要求）
# ==========================================
echo "👤 Checking second user..."

if ! "$WP_CLI" user get "$WP_USER" --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    echo "👤 Creating second user: $WP_USER..."
    
    "$WP_CLI" user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --path="$WP_PATH" \
        --allow-root
    
    echo "✅ Second user created"
else
    echo "✅ Second user already exists"
fi

# ==========================================
# 7. 设置权限
# ==========================================
echo "🔒 Setting permissions..."
chown -R www-data:www-data "$WP_PATH" /run/php
echo "✅ Permissions set"

# ==========================================
# 8. 启动 PHP-FPM
# ==========================================
echo "=========================================="
echo "  Starting PHP-FPM..."
echo "=========================================="

exec /usr/sbin/php-fpm8.2 -F




