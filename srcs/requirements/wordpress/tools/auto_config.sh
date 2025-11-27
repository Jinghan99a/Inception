#!/bin/bash
set -e
WP_PATH="/var/www/wordpress"

echo "11111111111111111111111111111111!!"

# 🔥 下载 WordPress（如果不存在）
if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "📥 Downloading WordPress..."
    cd /tmp
    curl -sO https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    # 复制文件到目标目录（保留可能已存在的文件）
    cp -rn wordpress/* "$WP_PATH/" 2>/dev/null || true
    rm -rf wordpress latest.tar.gz
    echo "✅ WordPress downloaded!"
fi

echo "⏳ Waiting for MariaDB to be ready at host: mariadb..."
until mysql -h mariadb -u"$DB_NAME_USER" -p"$DB_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    echo "   MariaDB is unavailable - sleeping..."
    sleep 3
done
echo "✅ MariaDB is ready!"

echo "33333333333333333333333333333333333!!"
# 配置 wp-config.php（如果不存在）
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "📝 Creating wp-config.php..."
    
    cp "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"
    
    # 替换数据库配置
    sed -i "s/database_name_here/$DB_NAME/" "$WP_PATH/wp-config.php"
    sed -i "s/username_here/$DB_NAME_USER/" "$WP_PATH/wp-config.php"
    sed -i "s/password_here/$DB_PASSWORD/" "$WP_PATH/wp-config.php"
    sed -i "s/localhost/mariadb/" "$WP_PATH/wp-config.php"

    echo "✅ wp-config.php created!"
fi

echo "4444444444444444444444444444444444444!!"
# 确保权限正确
chown -R www-data:www-data "$WP_PATH" /run/php
echo "✅ Permissions set!"

echo "555555555555555555555555555555555555555555555555555555!!"
echo "🚀 Starting PHP-FPM..."

# 启动 PHP-FPM（前台运行）
exec /usr/sbin/php-fpm8.2 -F



