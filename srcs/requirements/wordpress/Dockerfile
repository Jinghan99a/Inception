FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install -y curl php8.2-fpm php8.2-mysql \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# PHP-FPM runtime dir
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php
   
# 配置 pool
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/

# 工作目录
WORKDIR /var/www/wordpress

# 拷贝启动脚本
COPY ./tools/auto_config.sh .
RUN chmod +x auto_config.sh

# 暴露 FPM 端口
EXPOSE 9000

# 容器启动执行脚本
ENTRYPOINT ["/var/www/wordpress/auto_config.sh"]


# # --------------------------
# # WordPress Dockerfile
# # --------------------------
# FROM debian:bullseye

# ENV DEBIAN_FRONTEND=noninteractive

# # 更新系统并安装必要软件
# RUN apt-get update -y && \
#     apt-get upgrade -y && \
#     apt-get install -y \
#         wget curl \
#         php php-fpm php-mysql php-mbstring php-xml php-gd php-curl \
#         mariadb-client \
#         less procps \
#     && apt-get clean && rm -rf /var/lib/apt/lists/*

# # 下载 WordPress
# RUN wget https://wordpress.org/latest.tar.gz -P /var/www && \
#     cd /var/www && tar -xzf latest.tar.gz && rm latest.tar.gz

# # 设置权限
# RUN chown -R www-data:www-data /var/www/wordpress

# # 复制 PHP-FPM 配置
# COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# # 安装 WP-CLI
# RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#     chmod +x wp-cli.phar && \
#     mv wp-cli.phar /usr/local/bin/wp

# # 复制初始化脚本
# COPY tools/auto_config.sh /usr/local/bin/auto_config.sh
# RUN chmod +x /usr/local/bin/auto_config.sh

# # 设置工作目录
# WORKDIR /var/www/wordpress

# # 暴露端口
# EXPOSE 9000

# # 使用 auto_config.sh 作为 entrypoint，最后启动 PHP-FPM
# ENTRYPOINT ["/usr/local/bin/auto_config.sh"]

# CMD ["php-fpm7.4", "-F"]

