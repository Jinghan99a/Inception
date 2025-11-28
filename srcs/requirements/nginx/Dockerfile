FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install nginx and openssl
RUN apt-get update -y && \
    apt-get install -y nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create SSL certificate directory
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/localhost.key \
    -out /etc/nginx/ssl/localhost.crt \
    -subj "/CN=test.42.fr"

# Create nginx log directory
RUN mkdir -p /var/log/nginx && chown -R www-data:www-data /var/log/nginx

# Set working directory to WordPress root
RUN mkdir -p /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress
RUN chmod 755 /var/www/wordpress

# Copy nginx configuration file to the site configuration directory
COPY conf/nginx.conf /etc/nginx/conf.d/site.conf 

# Expose port 443 (HTTPS)
EXPOSE 443

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

