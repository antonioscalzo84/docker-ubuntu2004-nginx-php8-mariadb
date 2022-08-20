#! /bin/bash
publicPort="8001"
version="1.1"
image="ubuntu-nginx-php8-mariadb"
imageName="$image-local"
docker run -d --restart always -p $publicPort:80 \
--name "$imageName" "frecciadelsud836/ubuntu-nginx-php8-mariadb:$version"
#--platform linux/arm64/v8 \