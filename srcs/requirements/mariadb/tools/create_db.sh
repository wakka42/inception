#!/bin/sh

if [ -d "/var/lib/mysql/${DB_NAME}" ]
then
	echo "The configuration is already complete"
else
	echo "Configuration begins"
	touch tmp_file
	chmod 755 tmp_file

# mysql_install_db initializes the MariaDB data directory and creates the system tables in the mysql database, if they do not exist.
	mysql_install_db
	#mysql_install_db 2> /dev/null

# https://www.tecmint.com/fix-error-1130-hy000-host-not-allowed-to-connect-mysql/

	cat << EOF > tmp_file
CREATE DATABASE $DB_NAME;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
CREATE USER '$DB_USER_NAME'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER_NAME'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

	mysqld --bootstrap < tmp_file 2> /dev/null
	echo "Configuration is over"
fi

mysqld
#mysqld 2> /dev/null
