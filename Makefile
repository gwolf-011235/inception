# Colors
GREEN := \033[0;32m
RED := \033[0;31m
BLUE := \033[0;34m
RESET := \033[0m

INIT_FILE := .init
DIR_DATA_WORDPRESS = /home/$$USER/data/wordpress
DIR_DATA_MARIADB = /home/$$USER/data/mariadb
DIR_SECRETS := ./secrets
DIR_TOOLS := ./tools

.SILENT:

# Configuration
.PHONY: init
init:
	$(MAKE) .dir
	$(MAKE) .secret
	touch $(INIT_FILE)
	echo "$(GREEN)Init was success!$(RESET)"

.PHONY: .dir
.dir:
	echo "$(BLUE)Creating directories$(RESET)"
	mkdir -p $(DIR_DATA_WORDPRESS)
	mkdir -p $(DIR_DATA_MARIADB)
	mkdir -p $(DIR_SECRETS)

.PHONY: .secret
.secret:
	echo "$(BLUE)Creating secrets$(RESET)"
	cd ./secrets && \
	../$(DIR_TOOLS)/create_certificate.sh && \
	../$(DIR_TOOLS)/create_passwords.sh

.init_check:
	if ! test -e ".init" ; then \
		echo "$(INIT_FILE) not found. Please run 'make init'"; \
		exit 1; \
	fi

.PHONY: up
up: .init_check
	echo "$(GREEN)Starting up$(RESET)"
	cd srcs && \
	docker compose up -d

.PHONY: log
log:
	cd srcs && \
	docker compose logs -f

.PHONY: stop
stop:
	echo "$(RED)Stopping containers$(RESET)"
	cd srcs && \
	docker compose stop

.PHONY: down
down:
	echo "$(RED)Stopping and removing containers$(RESET)"
	cd srcs && \
	docker compose down

.PHONY: clean
clean:
	echo "$(RED)Cleaning up!$(RESET)"
	$(MAKE) down
	echo "$(RED)Removing $(DIR_SECRETS) and $(INIT_FILE)$(RESET)"
	rm -fr $(DIR_SECRETS)
	rm -fr $(INIT_FILE)

.PHONY: fclean
fclean:
	echo "$(RED)FULL CLEAN$(RESET)"
	$(MAKE) clean
	echo "$(RED)Prune docker system$(RESET)"
	docker system prune -af

