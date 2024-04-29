# syntax=docker/dockerfile:1
FROM debian:bookworm
RUN apt update && apt install nginx ssl-cert -y

CMD ["nginx", "-g", "daemon off;"]
