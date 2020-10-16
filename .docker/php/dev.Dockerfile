FROM php:7.4-fpm

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
        libzip-dev \
        unzip \
    && docker-php-ext-install zip pdo pdo_mysql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer global require hirak/prestissimo

COPY ./.docker/xdebug/xdebug.conf /usr/local/etc/php/conf.d/100-php.ini

RUN groupadd --gid 1000 appuser \
    && useradd --uid 1000 -g appuser \
        -G www-data,root --shell /bin/bash \
        --create-home appuser

USER appuser
