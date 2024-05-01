up:
	cd srcs && \
	docker compose up -d

log:
	cd srcs && \
	docker compose logs -f
stop:
	cd srcs && \
	docker compose stop

down:
	cd srcs && \
	docker compose down

secret:
	cd secrets && \
	./create_certificate.sh
