FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# 安装 nginx 和 openssl
RUN apt-get update -y && \
    apt-get install -y nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 创建 SSL 证书目录
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/localhost.key \
    -out /etc/nginx/ssl/localhost.crt \
    -subj "/CN=test.42.fr"

# 创建 nginx 日志目录
RUN mkdir -p /var/log/nginx && chown -R www-data:www-data /var/log/nginx

# 设置工作目录为 WordPress 根目录
RUN mkdir -p /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress
RUN chmod 755 /var/www/wordpress

# # 复制自定义 nginx 配置
# COPY conf/nginx.conf /etc/nginx/nginx.conf

# ❗ 修正：将自定义配置复制到 /etc/nginx/conf.d/
# 这样，Nginx 的主配置文件（/etc/nginx/nginx.conf，保持默认）
# 就会自动加载它（通过默认的 include /etc/nginx/conf.d/*.conf; 指令）
COPY conf/nginx.conf /etc/nginx/conf.d/site.conf 
# 确保使用 .conf 扩展名

# 暴露 443 端口 (HTTPS)
EXPOSE 443

# 启动 nginx 前台运行
CMD ["nginx", "-g", "daemon off;"]


# FROM debian:bullseye

# RUN apt update && apt install -y nginx openssl

# RUN mkdir -p /etc/nginx/ssl

# RUN openssl req -x509 -nodes -days 365 \
#     -newkey rsa:2048 \
#     -keyout /etc/nginx/ssl/localhost.key \
#     -out /etc/nginx/ssl/localhost.crt \
#     -subj "/CN=test.42.fr"
# COPY conf/nginx.conf /etc/nginx/nginx.conf

# #RUN chmod +x /var/www/nginx_start.sh

# RUN chmod 755 /var/www/html

# RUN chown -R www-data:www-data /var/www/html
# CMD ["nginx", "-g", "daemon off;"]

