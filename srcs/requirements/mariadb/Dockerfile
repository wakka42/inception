#How to install mysql
#https://doc.ubuntu-fr.org/mysql

FROM debian:bookworm

RUN apt update -y && apt upgrade -y
RUN apt install mariadb-server mariadb-client -y
RUN apt install vim -y

#COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/my.cnf	/etc/mysql/my.cnf
COPY ./tools/create_db.sh	/etc/create_db.sh
RUN chmod +x /etc/create_db.sh

# Need this directory to run mysql and add the owner to it
RUN mkdir -p /run/mysqld/
RUN chown mysql /run/mysqld

#RUN chmod -R 755 /var/lib/mysql

EXPOSE 3306

ENTRYPOINT ["bash", "./etc/create_db.sh"]
