FROM debian:bookworm

RUN apt-get update
RUN apt-get install -y mariadb-server
RUN mkdir /run/mysqld

CMD ["/tools/install.sh"]
