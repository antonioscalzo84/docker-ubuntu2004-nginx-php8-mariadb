#! /bin/bash
repository="ubuntu-nginx-php8-mariadb"
version="1.3-img"
docker build --platform linux/amd64 . -t "$repository:$version"
docker tag "$repository:$version" "frecciadelsud836/ubuntu-nginx-php8-mariadb:$version"
docker push "frecciadelsud836/ubuntu-nginx-php8-mariadb:$version"
