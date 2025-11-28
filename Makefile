# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jinhuang <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/11/22 21:56:19 by jinhuang          #+#    #+#              #
#    Updated: 2025/11/22 21:56:33 by jinhuang         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


DATA_PATH		= /home/jinhuang/data
COMPOSE_FILE	= srcs/docker-compose.yml
ENV_FILE		= srcs/.env

# 颜色定义
RESET		= \033[0m
BOLD		= \033[1m
RED			= \033[31m
GREEN		= \033[32m
YELLOW		= \033[33m
BLUE		= \033[34m
MAGENTA		= \033[35m
CYAN		= \033[36m

# **************************************************************************** #
#                                   RULES                                      #
# **************************************************************************** #

.PHONY: all up down start stop restart clean fclean re logs status help

# 默认目标：启动所有服务
all: up

# 创建数据目录并启动所有容器
up:
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(BLUE)$(BOLD)  Starting Inception...$(RESET)"
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(YELLOW)📁 Creating data directories...$(RESET)"
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@echo "$(GREEN)✓ Data directories created$(RESET)"
	@echo "$(YELLOW)🔨 Building and starting containers...$(RESET)"
	@cd srcs && docker compose up -d --build
	@echo "$(GREEN)$(BOLD)✓ Inception is running!$(RESET)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(MAGENTA)🌐 Access your site at: https://jinhuang.42.fr$(RESET)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"

# 停止并删除所有容器（保留 volumes）
down:
	@echo "$(YELLOW)⏹  Stopping containers...$(RESET)"
	@cd srcs && docker compose down
	@echo "$(GREEN)✓ Containers stopped$(RESET)"

# 启动已存在的容器（不重新构建）
start:
	@echo "$(YELLOW)▶️  Starting containers...$(RESET)"
	@cd srcs && docker compose start
	@echo "$(GREEN)✓ Containers started$(RESET)"

# 停止容器但不删除
stop:
	@echo "$(YELLOW)⏸  Stopping containers...$(RESET)"
	@cd srcs && docker compose stop
	@echo "$(GREEN)✓ Containers stopped$(RESET)"

# 重启所有容器
restart: stop start

# 清理：停止容器并删除 volumes
clean: down
	@echo "$(YELLOW)🧹 Cleaning up volumes...$(RESET)"
	@cd srcs && docker compose down -v
	@echo "$(GREEN)✓ Volumes removed$(RESET)"

# 完全清理：删除容器、volumes、镜像、数据文件
fclean: clean
	@echo "$(RED)$(BOLD)🗑️  Deep cleaning...$(RESET)"
	@echo "$(YELLOW)  → Removing Docker images...$(RESET)"
	@docker system prune -af --volumes 2>/dev/null || true
	@echo "$(YELLOW)  → Removing data directories...$(RESET)"
    # 💥 修改点：删除目录本身，而不是只删除内容 💥
	@sudo rm -rf $(DATA_PATH)/wordpress 2>/dev/null || true
	@sudo rm -rf $(DATA_PATH)/mariadb 2>/dev/null || true
	@echo "$(GREEN)✓ Deep clean completed$(RESET)"
# ...

# 完全重建
re: fclean all

# 查看实时日志
logs:
	@cd srcs && docker compose logs -f

# 查看特定服务的日志
logs-nginx:
	@cd srcs && docker compose logs -f nginx

logs-wordpress:
	@cd srcs && docker compose logs -f wordpress

logs-mariadb:
	@cd srcs && docker compose logs -f mariadb

# 查看容器状态
status:
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(BLUE)$(BOLD)  Container Status$(RESET)"
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@cd srcs && docker compose ps
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"

# 进入容器的 shell
shell-nginx:
	@docker exec -it nginx sh

shell-wordpress:
	@docker exec -it wordpress sh

shell-mariadb:
	@docker exec -it mariadb sh

# 检查配置文件
check:
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(BLUE)$(BOLD)  Configuration Check$(RESET)"
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(YELLOW)Checking docker-compose.yml...$(RESET)"
	@cd srcs && docker compose config -q && echo "$(GREEN)✓ docker-compose.yml is valid$(RESET)" || echo "$(RED)✗ docker-compose.yml has errors$(RESET)"
	@echo "$(YELLOW)Checking .env file...$(RESET)"
	@test -f $(ENV_FILE) && echo "$(GREEN)✓ .env file exists$(RESET)" || echo "$(RED)✗ .env file not found$(RESET)"
	@echo "$(YELLOW)Checking data directories...$(RESET)"
	@test -d $(DATA_PATH)/wordpress && echo "$(GREEN)✓ WordPress data directory exists$(RESET)" || echo "$(RED)✗ WordPress data directory not found$(RESET)"
	@test -d $(DATA_PATH)/mariadb && echo "$(GREEN)✓ MariaDB data directory exists$(RESET)" || echo "$(RED)✗ MariaDB data directory not found$(RESET)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"

# 显示帮助信息
help:
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(BLUE)$(BOLD)  Inception Makefile - Available Commands$(RESET)"
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo ""
	@echo "$(GREEN)$(BOLD)Main Commands:$(RESET)"
	@echo "  $(YELLOW)make$(RESET) or $(YELLOW)make all$(RESET)    - Create directories and start all containers"
	@echo "  $(YELLOW)make up$(RESET)              - Same as 'make all'"
	@echo "  $(YELLOW)make down$(RESET)            - Stop and remove containers (keep volumes)"
	@echo "  $(YELLOW)make start$(RESET)           - Start existing containers"
	@echo "  $(YELLOW)make stop$(RESET)            - Stop containers (don't remove)"
	@echo "  $(YELLOW)make restart$(RESET)         - Restart all containers"
	@echo ""
	@echo "$(GREEN)$(BOLD)Cleaning Commands:$(RESET)"
	@echo "  $(YELLOW)make clean$(RESET)           - Stop containers and remove volumes"
	@echo "  $(YELLOW)make fclean$(RESET)          - Deep clean (remove everything)"
	@echo "  $(YELLOW)make re$(RESET)              - Full rebuild (fclean + all)"
	@echo ""
	@echo "$(GREEN)$(BOLD)Monitoring Commands:$(RESET)"
	@echo "  $(YELLOW)make logs$(RESET)            - Show live logs from all containers"
	@echo "  $(YELLOW)make logs-nginx$(RESET)      - Show nginx logs"
	@echo "  $(YELLOW)make logs-wordpress$(RESET)  - Show wordpress logs"
	@echo "  $(YELLOW)make logs-mariadb$(RESET)    - Show mariadb logs"
	@echo "  $(YELLOW)make status$(RESET)          - Show container status"
	@echo ""
	@echo "$(GREEN)$(BOLD)Debug Commands:$(RESET)"
	@echo "  $(YELLOW)make shell-nginx$(RESET)     - Enter nginx container shell"
	@echo "  $(YELLOW)make shell-wordpress$(RESET) - Enter wordpress container shell"
	@echo "  $(YELLOW)make shell-mariadb$(RESET)   - Enter mariadb container shell"
	@echo "  $(YELLOW)make check$(RESET)           - Validate configuration files"
	@echo ""
	@echo "$(GREEN)$(BOLD)Help:$(RESET)"
	@echo "  $(YELLOW)make help$(RESET)            - Show this help message"
	@echo ""
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(MAGENTA)🌐 Site URL: https://jinhuang.42.fr$(RESET)"
	@echo "$(CYAN)$(BOLD)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"

