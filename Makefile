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


CYAN        = \033[36m
MAGENTA     = \033[35m
RESET       = \033[0m

.PHONY: all clean fclean re cleanupdata down

# Default target: build and start the entire project
all:
	mkdir -p $(HOME)/data/mariadb $(HOME)/data/wordpress
	docker-compose -f srcs/docker-compose.yml up -d --build
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(MAGENTA)🌐 Access your site at: https://jinhuang.42.fr$(RESET)"
	@echo "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"

# Stop and remove containers (retaining volumes/data)
down:
	docker-compose -f srcs/docker-compose.yml down

# Stop and remove containers (alias for down)
clean: down

# Deep clean: stop containers, remove images, and wipe persistent host data
fclean: clean
	docker system prune -af
	sudo rm -rf $(HOME)/data/mariadb $(HOME)/data/wordpress
	# Optional: if you generate .env in srcs, uncomment the line below
	# rm -f srcs/.env

# Full rebuild: fclean + all
re: fclean all

# Clear persistent data directly inside running containers.
# NOTE: Containers must be running for this target to work.
cleanupdata:
	docker-compose -f srcs/docker-compose.yml exec -u 0 mariadb sh -c "rm -rf /var/lib/mysql/*"
	docker-compose -f srcs/docker-compose.yml exec -u 0 nginx sh -c "rm -rf /var/www/wordpress/*"