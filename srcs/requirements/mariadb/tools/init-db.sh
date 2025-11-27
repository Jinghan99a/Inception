#!/bin/bash
set -e

# 创建 socket 目录
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# 确保环境变量存在（这些变量通常在 docker-compose.yml 中设置）
: "${DB_NAME:?Environment variable DB_NAME not set}"
: "${DB_NAME_USER:?Environment variable DB_NAME_USER not set}"
: "${DB_PASSWORD:?Environment variable DB_PASSWORD not set}"

# 1. 使用 envsubst 替换变量并创建最终的 SQL 文件
# 注意：envsubst 需要安装在容器内 (通常官方镜像已包含)
echo "Replacing environment variables in SQL template..."
/usr/bin/envsubst < /docker-entrypoint-initdb.d/init.sql.template > /tmp/init.sql

# 2. 第一次初始化数据库目录 (保留您的原始逻辑)
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB system tables..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# 3. 启动 MariaDB 服务器，并将替换后的 SQL 文件作为 --init-file
echo "Starting MariaDB with init-file..."
# 启动 mysqld，它将执行 /tmp/init.sql (其中的变量已经被替换成实际值)
exec mysqld --console --init-file=/tmp/init.sql

# #!/bin/bash
# set -e

# # 创建 socket 目录
# mkdir -p /run/mysqld
# chown mysql:mysql /run/mysqld

# # 第一次初始化数据库目录
# if [ ! -d /var/lib/mysql/mysql ]; then
#     echo "Initializing MariaDB system tables..."
#     mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# fi

# # 使用 init-file，每次启动都会执行 init.sql
# echo "Starting MariaDB with init-file..."
# exec mysqld --console --init-file=/docker-entrypoint-initdb.d/init.sql






#!/bin/bash
# set -e

# # 创建 socket 目录
# mkdir -p /run/mysqld
# chown mysql:mysql /run/mysqld

# # 如果数据库目录不存在，初始化系统表
# if [ ! -d /var/lib/mysql/mysql ]; then
#     echo "Initializing MariaDB system tables..."
#     mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# fi

# # 启动 MariaDB（后台）
# mysqld_safe --datadir=/var/lib/mysql &
# echo "Waiting for MariaDB to be ready..."
# until mysqladmin ping >/dev/null 2>&1; do
#     sleep 1
# done

# # 每次执行 init.sql，不管数据目录是否存在
# echo "Running init.sql..."
# mysql -u root -p"$MYSQL_ROOT_PASSWORD" < /docker-entrypoint-initdb.d/init.sql

# # 停掉临时 MariaDB
# mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# # 前台启动 MariaDB
# exec mysqld --console

# #!/bin/bash
# set -e

# # 创建 socket 目录
# mkdir -p /run/mysqld
# chown mysql:mysql /run/mysqld

# # 初始化数据库目录（第一次运行）
# if [ ! -d /var/lib/mysql/mysql ]; then
#     echo "Initializing MariaDB system tables..."
#     mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# fi

# echo "Starting MariaDB in foreground..."
# exec mysqld --console




