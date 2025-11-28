FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install -y curl php8.2-fpm php8.2-mysql \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# PHP-FPM runtime directory
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php
   
# Configure pool
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/

# Working directory
WORKDIR /var/www/wordpress

# Copy startup script
COPY ./tools/auto_config.sh .
RUN chmod +x auto_config.sh

# Expose FPM port
EXPOSE 9000

# Execute script on container start
ENTRYPOINT ["/var/www/wordpress/auto_config.sh"]


