# Download base image ubuntu 20.04
FROM ubuntu:22.04

# LABEL about the custom image
LABEL maintainer="antonio.scalzo84@gmail.com"
LABEL version="0.1"
LABEL description="Custom Docker image with Nginx, Php8.0 and MariaDB"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# set user
ENV MYSQL_USER mysql
# define database directory for start-script
ENV DATADIR /var/lib/mysql
ENV MYSQL_ROOT_PASSWORD password

# Update Ubuntu Software repository

RUN apt-get update && apt -y upgrade

# install essential packages
RUN apt-get -y install \
  curl \
  zip \
  unzip \
  wget \
  telnet \
  iputils-ping \
  nano lsb-release ca-certificates apt-transport-https software-properties-common
# add PHP repos
RUN LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php && apt-get update
RUN mkdir /var/run/mysqld && chmod 777 /var/run/mysqld -R

RUN apt-get -y install mariadb-server
# install Node.js, Yarn and PHP
RUN apt-get -y install nginx php8.1-fpm \
                           php8.1-mbstring \
                           php8.1-dom \
                           php8.1-curl \
                           php8.1-simplexml \
                           php8.1-gd \
                           php8.1-zip \
                           php8.1-sqlite3 \
                           php8.1-bcmath \
                           php8.1-intl \
                           php8.1-mysql \
                           supervisor && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean


# Define the ENV variable
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/8.1/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf

# Enable PHP-fpm on nginx virtualhost configuration
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && echo "\ndaemon off;" >> ${nginx_conf}

#SET PHP max upload filesize to 32MB
RUN sed -i -e 's/2M/32M/g' ${php_conf}

ADD /support/nginx/nginx.conf /etc/nginx/nginx.conf
ADD /support/nginx/default-vhost.conf /etc/nginx/sites-available/default
ADD /support/index.php /var/www/html/index.php

# Copy supervisor configuration
COPY /support/supervisord.conf ${supervisor_conf}

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php
RUN usermod -u 1000 www-data



ADD /support/mariadb/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Volume configuration
VOLUME ["/var/lib/mysql","/var/www/html"]

# Copy start.sh script and define default command for the container
COPY /support/start.sh /start.sh
RUN ["chmod", "+x", "./start.sh"]

CMD ["./start.sh"]

# Expose Port for the Application
EXPOSE 80 443
