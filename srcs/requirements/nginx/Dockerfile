# How to install nginx on debian

# Source:	https://www.it-connect.fr/debian-comment-installer-nginx-en-tant-que-serveur-web/

FROM debian:bookworm

# Basic running configuration
RUN apt update -y && apt upgrade -y
RUN apt install nginx -y
RUN apt install vim -y
RUN apt install openssl -y

# Source to generate a certificate: https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html
# Example of self signed certificate: https://opensource.com/article/19/6/cryptography-basics-openssl-part-2
RUN mkdir -p /etc/nginx/ssl

# Create a certificate: openssl req
# -x509:	Ask for self signed certificate instead of a certificate request
# -sha256:	Hashing algorithm
# -nodes:	Disable the need of a passphrase
# -newkey rsa:4096: Create a RSA public key
# -subj:	Supply all the needed information in order to prevent the generation of the CSR to stop asking for input

RUN openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=aasli.42.fr/UID=aasli"

# Configuration
#COPY conf/nginx.conf /etc/nginx/conf.d
COPY conf/my.conf /etc/nginx/conf.d

# Ports
EXPOSE 443

# Give the right to access the folder to the default user 'www-data' as named in conf file
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data  /var/www/html

#This command tells Nginx to stay in the foreground
#Source : https://itecnote.com/tecnote/docker-the-difference-between-nginx-daemon-on-off-option/

ENTRYPOINT ["nginx", "-g", "daemon off;"]
