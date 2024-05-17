PROJECT_NAME := inception
COMPOSE_FILE := ./srcs/docker-compose.yml

#### COLORS ####

GREEN := \033[0;32m
RED := \033[0;31m
BLUE := \033[0;34m
RESET := \033[0m

#### DIRECTORIES ####

DIR_DATA_WORDPRESS = $$HOME/data/wordpress
DIR_DATA_MARIADB = $$HOME/data/mariadb
DIR_SECRETS := ./secrets
DIR_TOOLS := ./tools
DIR_BACKUP := ./backup

#### BACKUP ####

BACKUP_WORDPRESS := $(DIR_BACKUP)/wordpress.tar.gz
BACKUP_MARIADB := $(DIR_BACKUP)/mariadb.tar.gz
BACKUP_SECRETS := $(DIR_BACKUP)/secrets.tar.gz

.SILENT:

#### HELP ####

.PHONY:
help: # Print help on Makefile
	@grep '^[^.#]\+:\s\+.*#' Makefile | \
	sed "s/\(.\+\):\s*\(.*\) #\s*\(.*\)/`printf "\033[93m"`\1`printf "\033[0m"`	\3 [\2]/" | \
	expand -t20

#### CONTAINER ####

.PHONY: up
up: .init_check # Start containers
	echo "$(GREEN)Starting containers$(RESET)"
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up -d

.PHONY: log
log: # Prints logs of running containers
	docker compose -p $(PROJECT_NAME) logs -f

.PHONY: stop
stop: # Stops running containers
	echo "$(RED)Stopping containers$(RESET)"
	docker compose -p $(PROJECT_NAME) stop

.PHONY: down
down: # Stops and removes containers
	echo "$(RED)Stopping and removing containers$(RESET)"
	docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down

.PHONY: .data
.data:
	echo "$(BLUE)Creating data directories$(RESET)"
	mkdir -p $(DIR_DATA_WORDPRESS)
	mkdir -p $(DIR_DATA_MARIADB)

.PHONY: .secret
.secret:
	echo "$(BLUE)Creating secrets$(RESET)"
	mkdir -p $(DIR_SECRETS)
	cd ./secrets && \
	../$(DIR_TOOLS)/create_certificate.sh && \
	../$(DIR_TOOLS)/create_passwords.sh

.PHONY: init_check
.init_check:
	if [ ! -d $(DIR_DATA_WORDPRESS) ] || [ ! -d $(DIR_DATA_MARIADB) ] ; then \
		$(MAKE) .data; \
	fi
	if [ ! -d $(DIR_SECRETS) ] || [ -z "$$(ls -A $(DIR_SECRETS))" ] ; then \
		$(MAKE) .secret; \
	fi

#### CLEANUP ####

.PHONY: clean_sec
clean_sec: # Cleans Secret directory
	echo "$(RED)Removing $(DIR_SECRETS)$(RESET)"
	rm -fr $(DIR_SECRETS)

.PHONY: clean_data
clean_data: # Cleans data directories
	echo "$(RED)Removing $(DIR_DATA_WORDPRESS) and $(DIR_DATA_MARIADB)$(RESET)"
	rm -fr $(DIR_DATA_WORDPRESS) $(DIR_DATA_MARIADB)

.PHONY: clean_doc
clean_doc: # Removes docker images and build cache
	echo "$(RED)Prune docker system$(RESET)"
	docker system prune -af
	
.PHONY: fclean
fclean: down clean_sec clean_data clean_doc # Runs all Clean targets
	echo "$(RED)FULL CLEAN DONE$(RESET)"

#### BACKUP ####

.PHONY: backup
backup: # Backs up the current Secret and Data directories
	echo "$(BLUE)Creating backup$(RESET)"
	mkdir -p $(DIR_BACKUP)
	tar -czf $(BACKUP_WORDPRESS) -C / $(DIR_DATA_WORDPRESS)
	tar -czf $(BACKUP_MARIADB) -C / $(DIR_DATA_MARIADB)
	tar -czf $(BACKUP_SECRETS) $(DIR_SECRETS)

.PHONY: restore
restore: .backup_check # Restores existing backup
	echo "$(BLUE)Restoring backup$(RESET)"
	tar -xzvf $(BACKUP_WORDPRESS) -C /
	tar -xzvf $(BACKUP_MARIADB) -C /
	tar -xzvf $(BACKUP_SECRETS)

.PHONEY: .backup_check
.backup_check:
	if [ ! -d $(DIR_BACKUP) ] || \
		[ ! -e $(BACKUP_WORDPRESS) ] || [ ! -e $(BACKUP_MARIADB) ] || [ ! -e $(BACKUP_SECRETS) ] ; then \
			echo "$(RED)Backup does not exist! To create run make backup$(RESET)"; \
			exit 1; \
	fi

