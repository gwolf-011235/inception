PROJECT_NAME := inception

#### COLORS ####

GREEN := \033[0;32m
RED := \033[0;31m
BLUE := \033[0;34m
RESET := \033[0m

#### USER CONFIG ####

USER_NAME := $(shell whoami)
USER_UID := $(shell id -u)
USER_GID := $(shell id -g)

#### DIRECTORIES ####

DIR_ROOT := $(shell pwd)
DIR_SRCS := $(DIR_ROOT)/srcs
DIR_REQUIREMENTS := $(DIR_SRCS)/requirements
DIR_SECRETS := $(DIR_ROOT)/secrets
DIR_TOOLS := $(DIR_REQUIREMENTS)/tools
DIR_BACKUP := $(DIR_ROOT)/backup
DIR_HOME := /home/$(USER)
DIR_DATA := $(DIR_HOME)/data
DIR_DATA_WORDPRESS = $(DIR_DATA)/wordpress
DIR_DATA_MARIADB = $(DIR_DATA)/mariadb
DIR_DATA_REDIS = $(DIR_DATA)/redis

#### FILES ####

COMPOSE_FILE := $(DIR_SRCS)/docker-compose.yml
ENV_FILE := $(DIR_SRCS)/.env
ENV_FILE_BAK := $(ENV_FILE).bak

#### BACKUP ####

BACKUP_WORDPRESS := $(DIR_BACKUP)/wordpress.tar.gz
BACKUP_MARIADB := $(DIR_BACKUP)/mariadb.tar.gz
BACKUP_REDIS := $(DIR_BACKUP)/redis.tar.gz
BACKUP_SECRETS := $(DIR_BACKUP)/secrets.tar.gz

.SILENT:

#### HELP ####

.PHONY:
help: # Print help on Makefile
	grep '^[^.#]\+:\s\+.*#' Makefile | \
	sed "s/\(.\+\):\s*\(.*\) #\s*\(.*\)/`printf "\033[93m"`\1`printf "\033[0m"`	\3 [\2]/" | \
	expand -t20

#### CONTAINER ####

.PHONY: up
up: .init_check # Start containers
	echo "$(GREEN)Starting containers$(RESET)"
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up -d

.PHONY: log
log: # Prints logs of running containers. Use SERVICE=service_name to specify a service
	docker compose -p $(PROJECT_NAME) logs -f $(SERVICE)

.PHONY: stop
stop: # Stops running containers
	echo "$(RED)Stopping containers$(RESET)"
	docker compose -p $(PROJECT_NAME) stop

.PHONY: down
down: # Stops and removes containers
	echo "$(RED)Stopping and removing containers$(RESET)"
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down

.PHONY: ps
ps: # Lists running containers from the project
	$(SILENT)docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) ps

.PHONY: config
config: # Prints the configuration of the project
	$(SILENT)docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) config

.PHONY: .data
.data:
	echo "$(BLUE)Creating data directories$(RESET)"
	mkdir -p $(DIR_DATA_WORDPRESS)
	mkdir -p $(DIR_DATA_MARIADB)
	mkdir -p $(DIR_DATA_REDIS)

.PHONY: .secret
.secret:
	echo "$(BLUE)Creating secrets$(RESET)"
	mkdir -p $(DIR_SECRETS)
	cd ./secrets && \
	$(DIR_TOOLS)/create_certificate.sh && \
	$(DIR_TOOLS)/create_passwords.sh

.PHONY: .env
.env:
	echo "$(BLUE)Updating .env file$(RESET)"
	cp $(ENV_FILE) $(ENV_FILE_BAK)
	sed -i 's/USER_NAME=#/USER_NAME=$(USER_NAME)/g' $(ENV_FILE)
	sed -i 's/USER_UID=#/USER_UID=$(USER_UID)/g' $(ENV_FILE)
	sed -i 's/USER_GID=#/USER_GID=$(USER_GID)/g' $(ENV_FILE)
# Using '+' as separator to avoid conflicts with '/' in paths
	sed -i 's+DIR_SECRET=#+DIR_SECRET=$(DIR_SECRETS)+g' $(ENV_FILE)
	sed -i 's+DIR_DATA_WORDPRESS=#+DIR_DATA_WORDPRESS=$(DIR_DATA_WORDPRESS)+g' $(ENV_FILE)
	sed -i 's+DIR_DATA_MARIADB=#+DIR_DATA_MARIADB=$(DIR_DATA_MARIADB)+g' $(ENV_FILE)
	sed -i 's+DIR_DATA_REDIS=#+DIR_DATA_REDIS=$(DIR_DATA_REDIS)+g' $(ENV_FILE)
	sed -i 's+DIR_REQUIREMENTS=#+DIR_REQUIREMENTS=$(DIR_REQUIREMENTS)+g' $(ENV_FILE)

.PHONY: .init_check
.init_check:
	if [ ! -e $(ENV_FILE) ] ; then \
		echo "$(RED)Missing $(ENV_FILE) file$(RESET)"; \
		exit 1; \
	fi
	if [ ! -e $(COMPOSE_FILE) ] ; then \
		echo "$(RED)Missing $(COMPOSE_FILE) file$(RESET)"; \
		exit 1; \
	fi
	if [ ! -e $(ENV_FILE).bak ] ; then \
		$(MAKE) --no-print-directory .env; \
	fi
	if [ ! -d $(DIR_DATA_WORDPRESS) ] || [ ! -d $(DIR_DATA_MARIADB) ] || [ ! -d $(DIR_DATA_REDIS) ]; then \
		$(MAKE) --no-print-directory .data; \
	fi
	if [ ! -d $(DIR_SECRETS) ] || [ -z "$$(ls -A $(DIR_SECRETS))" ] ; then \
		$(MAKE) --no-print-directory .secret; \
	fi

#### CLEANUP ####

.PHONY: clean_sec
clean_sec: # Cleans Secret directory
	echo "$(RED)Removing $(DIR_SECRETS)$(RESET)"
	rm -fr $(DIR_SECRETS)

.PHONY: clean_data
clean_data: # Cleans data directories and docker volumes
	echo "$(RED)Removing $(DIR_DATA)$(RESET)"
	rm -fr $(DIR_DATA)
	echo "$(RED)Removing docker volumes$(RESET)"
	docker volume rm -f $(PROJECT_NAME)_wordpress_data $(PROJECT_NAME)_mariadb_data $(PROJECT_NAME)_redis_data

.PHONY: clean_images
clean_images: # Removes created docker images
	echo "$(RED)Removing project images$(RESET)"
	IMAGE_LIST=$$(docker images --filter reference=$(PROJECT_NAME)* -q) && \
	if [ -n "$$IMAGE_LIST" ]; then \
		docker rmi $$IMAGE_LIST; \
	else \
		echo "No images to remove"; \
	fi

.PHONY: clean_env
clean_env: # Restores placeholder values in .env file
	echo "$(BLUE)Resetting .env file to placeholder values$(RESET)"
	sed -i 's/^USER_NAME=.*/USER_NAME=#/' $(ENV_FILE)
	sed -i 's/^USER_UID=.*/USER_UID=#/' $(ENV_FILE)
	sed -i 's/^USER_GID=.*/USER_GID=#/' $(ENV_FILE)
	sed -i 's/^DIR_SECRET=.*/DIR_SECRET=#/g' $(ENV_FILE)
	sed -i 's/^DIR_DATA_WORDPRESS=.*/DIR_DATA_WORDPRESS=#/g' $(ENV_FILE)
	sed -i 's/^DIR_DATA_MARIADB=.*/DIR_DATA_MARIADB=#/g' $(ENV_FILE)
	sed -i 's/^DIR_DATA_REDIS=.*/DIR_DATA_REDIS=#/g' $(ENV_FILE)
	sed -i 's/^DIR_REQUIREMENTS=.*/DIR_REQUIREMENTS=#/g' $(ENV_FILE)
	rm -f $(ENV_FILE_BAK)

.PHONY: fclean
fclean: down clean_sec clean_data clean_env clean_images # Runs all Clean targets
	echo "$(RED)FULL CLEAN DONE$(RESET)"

#### REBUILD ####

.PHONY: re
re: down clean_images # Rebuilds the project
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) build --no-cache
	$(MAKE) --no-print-directory up


#### BACKUP ####

.PHONY: backup
backup: # Backs up the current Secret and Data directories
	echo "$(BLUE)Creating backup$(RESET)"
	mkdir -p $(DIR_BACKUP)
	tar -czf $(BACKUP_WORDPRESS) -C / $(DIR_DATA_WORDPRESS)
	tar -czf $(BACKUP_MARIADB) -C / $(DIR_DATA_MARIADB)
	tar -czf $(BACKUP_REDIS) -C / $(DIR_DATA_REDIS)
	tar -czf $(BACKUP_SECRETS) $(DIR_SECRETS)

.PHONY: restore
restore: .backup_check # Restores existing backup
	echo "$(BLUE)Restoring backup$(RESET)"
	tar -xzvf $(BACKUP_WORDPRESS) -C /
	tar -xzvf $(BACKUP_MARIADB) -C /
	tar -xzvf $(BACKUP_REDIS) -C /
	tar -xzvf $(BACKUP_SECRETS)

.PHONEY: .backup_check
.backup_check:
	if [ ! -d $(DIR_BACKUP) ] || \
		[ ! -e $(BACKUP_WORDPRESS) ] || [ ! -e $(BACKUP_MARIADB) ] || [ ! -e $(BACKUP_REDIS) ] || [ ! -e $(BACKUP_SECRETS) ] ; then \
			echo "$(RED)Backup does not exist! To create run make backup$(RESET)"; \
			exit 1; \
	fi

