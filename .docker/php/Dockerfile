ARG PHP_VERSION="8.1"
ARG COMPOSER_VERSION="2"

# ======================================================================================================================
#                                                   --- Composer ---
# ======================================================================================================================

FROM composer:${COMPOSER_VERSION} as composer

# ======================================================================================================================
#                                                   --- App Base ---
# ======================================================================================================================

FROM php:${PHP_VERSION}-apache as base

LABEL maintainer="reinerttomas@gmail.com"

ENV TZ=Europe/Prague
ENV APACHE_DOCUMENT_ROOT /app/public

# Dependencies
RUN apt update && apt dist-upgrade -y && \
    apt install -y curl \
        apt-transport-https \
        ca-certificates \
        unzip && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# PHP
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions intl \
      zip

# Apache
RUN a2enmod rewrite && \
    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Production config
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Custom config
COPY ./.docker/php/conf.d/custom.ini $PHP_INI_DIR/conf.d/custom.ini

WORKDIR /app

# ======================================================================================================================
#                                                  --- Vendor ---
# ======================================================================================================================

FROM composer as vendor

WORKDIR /app

# Copy Dependencies files
COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer config platform.php ${PHP_VERSION} && \
    composer install --ignore-platform-reqs --no-dev --no-scripts --no-autoloader

COPY . .

RUN mv .env.prod .env && \
    composer dumpautoload --optimize && \
    composer dump-env prod

# ======================================================================================================================
#                                                  --- Node ---
# ======================================================================================================================

FROM node:18-alpine as node

WORKDIR /app

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

COPY assets assets
COPY webpack.config.js webpack.config.js

RUN mkdir -p public/build && \
    npm run build

# ======================================================================================================================
#                                                   --- App Prod ---
# ======================================================================================================================

FROM base as app

ENV APP_ENV prod
ENV APP_DEBUG 0

# Dependencies
RUN apt update && apt dist-upgrade -y && \
#    apt install -y acl && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

RUN chown -R www-data:www-data /app

USER www-data

COPY --chown=www-data:www-data --from=vendor /app /app
COPY --chown=www-data:www-data --from=node /app/public/build /app/public/build

# ======================================================================================================================
#                                                   --- App Dev ---
# ======================================================================================================================

FROM base as app-dev

ENV APP_ENV dev
ENV APP_DEBUG 1

# Dependencies
RUN apt update && apt dist-upgrade -y && \
    apt install -y nodejs \
        npm

# Clean
RUN rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

# Development config
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer