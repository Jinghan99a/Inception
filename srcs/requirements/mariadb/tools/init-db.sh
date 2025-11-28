#!/bin/bash
set -e

# create  mysqld folder
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Make sure environment variables exist (these variables are usually set in docker-compose.yml)
: "${DB_NAME:?Environment variable DB_NAME not set}"
: "${DB_NAME_USER:?Environment variable DB_NAME_USER not set}"
: "${DB_PASSWORD:?Environment variable DB_PASSWORD not set}"

# 1. Use envsubst to replace variables and create the final SQL file
# Note: envsubst must be installed in the container (usually included in official images)
echo "Replacing environment variables in SQL template..."
/usr/bin/envsubst < /docker-entrypoint-initdb.d/init.sql.template > /tmp/init.sql

# 2. Initialize the database directory for the first time (keeps your original logic)
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB system tables..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# 3. Start the MariaDB server and use the substituted SQL file as --init-file
echo "Starting MariaDB with init-file..."
# Start mysqld, which will execute /tmp/init.sql (variables have already been replaced with actual values)
exec mysqld --console --init-file=/tmp/init.sql






