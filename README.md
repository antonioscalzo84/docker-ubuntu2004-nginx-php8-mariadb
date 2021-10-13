# docker-ubuntu2004-nginx-php8-mariadb
Docker Image based on Ubuntu 20.04, Ngninx, Php8.0 and MariaDB

# NGINX
A default virtualhost is copied from support/nginx/default-vhosts.conf, with root folder /var/www/html

# PHP 8.0
Php installed in fpm mode, socket bind on /var/run/php/php8.0-fpm.sock

# MARIADB
Default username is "root", password is "password", can be set by editing

ENV MYSQL_ROOT_PASSWORD password

on Dockerfile

# Image Usage
Clone repository on a folder, then build and execute.

# Volumes
If you want to mount local folder as volumes, you can use these parameters when running image:

-v $localfolder/mysql-data:/var/lib/mysql \
-v $localfolder/www-data:/var/www/html \
-v $localfolder/nginx-logs:/var/log/nginx 

to mount local mysql, www and nginx logs folder
