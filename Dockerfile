ARG PHP_VERSION=7.4-apache

FROM php:${PHP_VERSION} as php_laravel
# install dependencies for laravel 8
RUN apt-get update && apt-get install -y \
  curl \
  git \
  libicu-dev \
  libpq-dev \
  libmcrypt-dev \
  mariadb-client \
  openssl \
  unzip \
  vim \
  libonig-dev \
  libxml2-dev \
  zip \
  zlib1g-dev \
  libpng-dev \
  libzip-dev && \
rm -r /var/lib/apt/lists/*
# install extension for laravel 8
RUN docker-php-ext-install mbstring fileinfo exif pcntl bcmath gd mysqli pdo_mysql && \
    docker-php-ext-enable mbstring fileinfo exif pcntl bcmath gd mysqli pdo_mysql && \
    a2enmod rewrite

# install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV APP_SOURCE /var/www/php

# Set working directory
WORKDIR $APP_SOURCE

COPY .docker/000-default.apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY .docker/apache2-foreground .docker/apache2-foreground
COPY .docker/php-artisan-migrate-foreground .docker/php-artisan-migrate

CMD [".docker/apache2-foreground"]

FROM php_laravel as executeable
ENV APP_SOURCE /var/www/php
ENV APP_DEBUG=false
ENV APP_URL=""
ENV APP_ENV=production
ENV DB_CONNECTION=mysql
# ENV DB_HOST=localhost
ENV DB_PORT=3306

# copy source laravel
COPY . .
# COPY --from=laramix_build /var/www/php/public/css public/css
# COPY --from=laramix_build /var/www/php/public/fonts public/fonts
# COPY --from=laramix_build /var/www/php/public/js public/js

# give full access
RUN php -r "file_exists('.env') || copy('.env.example', '.env');" && \
    mkdir -p public/storage && \
    chmod -R 777 storage/* && \
    chmod -R 777 public/storage && \
    chmod -R 777 .docker/* && \
    composer install --no-interaction --optimize-autoloader --no-dev
    # install dependency laravel

VOLUME ${APP_SOURCE}/storage
# expose port default 80
EXPOSE 80/tcp