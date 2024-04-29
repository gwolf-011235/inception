FROM debian:bookworm
RUN apt-get update 
RUN apt-get install -y php-fpm
RUN apt-get install -y php-mysqli
RUN apt-get install -y curl

CMD ["/tools/wordpress_run.sh"]
