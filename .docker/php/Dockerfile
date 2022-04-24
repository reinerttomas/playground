ARG PHP_VERSION="8.1"

FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="reinerttomas@gmail.com"

ENV TZ=Europe/Prague

# Dependencies
RUN set -eux \
    && apk update \
    && apk add --no-cache \
        unzip \
        nodejs \
        npm

# PHP extensions
# https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync \
    && install-php-extensions @composer \
    gd \
    pdo_mysql \
    intl

# PHP config
COPY .docker/php/conf.d/config.dev.ini /usr/local/etc/php/conf.d/config.dev.ini

WORKDIR /var/www/html/