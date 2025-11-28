FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB and dos2unix, create required directories
# RUN apt-get update && apt-get install -y mariadb-server dos2unix \
#     && mkdir -p /docker-entrypoint-initdb.d /run/mysqld \
#     && chown -R mysql:mysql /run/mysqld /var/lib/mysql \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt update -y && apt upgrade -y \
    && apt install -y mariadb-server mariadb-client gettext-base

# Optional: copy MariaDB config file
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization scripts and SQL
COPY tools/init.sql.template /docker-entrypoint-initdb.d/init.sql.template
COPY tools/init-db.sh /docker-entrypoint-initdb.d/init-db.sh


# Ensure Unix line endings and executable permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Expose MariaDB port
EXPOSE 3306

# Persist data
VOLUME ["/var/lib/mysql"]

# Run the ENTRYPOINT script as root, and switch to the mysql user inside the script.
ENTRYPOINT ["/docker-entrypoint-initdb.d/init-db.sh"]




