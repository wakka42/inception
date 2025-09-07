#!/bin/sh

# Waiting for the database to be up
# https://dev.mysql.com/doc/refman/8.0/en/mysqladmin.html
sleep 10
until mysqladmin --host=${DB_HOST} --user=${DB_USER_NAME} --password=${DB_USER_PASSWORD} ping
do
	echo "Trying to reach the database..."
	sleep 2
done

echo "Database is up"

if [ -f /var/www/html/wp-config.php ]
then
	echo "The configuration is already complete because wp-config.php exists"
else
	echo "Configuration begins because wp-config.php doesn't exist"

# Setup the php file needed to launch wordpress
# https://developer.wordpress.org/cli/commands/config/create/

	wp core download --allow-root

	echo "setup the php file"
	wp config create --allow-root --dbname="${DB_NAME}" --dbuser="${DB_USER_NAME}" --dbpass="${DB_USER_PASSWORD}" --dbhost="${DB_HOST}"

# Setup the first page of our wordpress
# https://developer.wordpress.org/cli/commands/core/install/
	echo "setup the first page"
	wp core install --allow-root --url=${DOMAIN_NAME} --title="David ASLI' website" --admin_user=${WP_ADMIN_NAME} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_MAIL} --skip-email --path="/var/www/html"

# Create a second user that is no root
# https://developer.wordpress.org/cli/commands/user/create/
	echo "create a second user"
	wp user create --allow-root ${WP_USER_NAME} ${WP_USER_MAIL} --user_pass=${WP_USER_PASSWORD} --path="/var/www/html" --role=author

# Downloading the redis plugin and enable it
	wp config set WP_REDIS_HOST redis --allow-root 
  	wp config set WP_REDIS_PORT 6379 --raw --allow-root
 	wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
 	wp config set WP_CACHE true --allow-root
	wp plugin install redis-cache --allow-root --path="/var/www/html"  --activate --activate-network

	wp redis enable --allow-root --path="/var/www/html"
	
	echo "Configuration is over";
fi

#Launch the php interface in the foreground with -F to not exit the container and with -R to run as a root
/usr/sbin/php-fpm8.2 -F -R
