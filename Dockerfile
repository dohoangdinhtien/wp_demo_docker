# WordPress Dockerfile: Create container from official WordPress image, basic customizations.
# docker build -t wordpress_local:wp_custom_1.0 .

FROM wordpress:latest
#FROM wordpress:php8.3-fpm

# APT Update/Upgrade, then install packages we need
RUN apt update && \
    apt upgrade -y && \
    apt autoremove && \
    apt install -y \
    nano \
    wget

RUN apt-get update \
    && pecl install redis \
    && docker-php-ext-enable redis

# Replace php.ini Test
# COPY php.ini /usr/local/etc/php

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info&& \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    # Remove old php.ini files (wihtout creating new image)
    rm /usr/local/etc/php/php.ini-development && \
    rm /usr/local/etc/php/php.ini-production

WORKDIR /usr/src/wordpress

# RUN mkdir /var/www/html/wp-content/plugins/demo
RUN mkdir /var/www/html/wp-content/mu-plugins
# COPY load.php /var/www/html/wp-content/mu-plugins
# COPY plugins/load.php /var/www/html/wp-content/mu-plugins/load.php
COPY plugins/ /var/www/html/wp-content/mu-plugins/
