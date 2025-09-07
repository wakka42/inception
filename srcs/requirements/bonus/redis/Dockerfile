#https://gaelbillon.com/installer-et-configurer-redis-pour-wordpress-en-5-minutes/
FROM debian:bookworm

RUN apt-get -y update && apt-get -y upgrade
RUN apt install -y vim

RUN apt install -y redis

EXPOSE 6379

COPY ./conf/redis.conf /etc/redis/redis.conf

ENTRYPOINT redis-server --protected-mode no
