# Source: https://www.digitalocean.com/community/tutorials/php-fpm-nginx

FROM debian:bookworm

RUN apt-get -y update && apt-get -y upgrade
RUN apt install -y mariadb-client
RUN apt install -y vim

# Package to download wordpress later on
RUN apt -y install wget

# php-mysql package provides a MySQL module for php
# php-fpm package provides an interface to communicate between php and a web server
RUN apt install -y php php-fpm php-mysql


# Donwload and untar the wordpress directory
#RUN	wget http://wordpress.org/latest.tar.gz -P /var/www/html
#RUN	cd /var/www/html && tar xfz latest.tar.gz && rm latest.tar.gz
#RUN	chown -R root:root /var/www/wordpress

# Download the wp-cli to setup our wordpress
# https://wp-cli.org/fr/
RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN	php wp-cli.phar --info
RUN	chmod +x wp-cli.phar
RUN	mv wp-cli.phar /usr/local/bin/wp

# Copy the www.conf configuration file with the directive
# Listen 127.0.0.1:9000 to the php-fpm default ressource pool
# Source:	https://serversforhackers.com/c/php-fpm-configuration-the-listen-directive
# COPY ./conf/www.conf /etc/php/7.3/pool.d/www.conf
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/

EXPOSE 9000

# Force to create this dir in order to access a file socket, don't run without
RUN mkdir -p /run/php /var/www/html
RUN mkdir -p /var/run/mysqld

RUN chmod -R 777 /var/www/html
WORKDIR /var/www/html

# Need to setup the wordpress with the wp-cli
COPY ./tools/config_wp.sh /config_wp.sh
ENTRYPOINT	bash /config_wp.sh
