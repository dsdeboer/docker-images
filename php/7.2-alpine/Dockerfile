ARG APP_ENV=${APP_ENV:-dev}
ARG APP_DEBUG=1
ARG PHP_TYPE=${PHP_TYPE:-cli}
FROM php:7.2-${PHP_TYPE}-alpine as charpand-php

WORKDIR /var/www

ENV APP_ENV $APP_ENV
ENV APP_DEBUG $APP_DEBUG

RUN set -ex \
    && apk add --update icu-dev oniguruma-dev libzip-dev libxml2-dev bzip2-dev curl-dev \
    && docker-php-ext-install -j4 intl mbstring zip xml bz2 curl json \
    && if [[ "${APP_ENV}" == "prod" ]]; then docker-php-ext-install opcache; fi \
    && if [[ "${APP_ENV}" == "prod" ]]; then docker-php-ext-enable opcache; fi \
    && apk add tzdata \
    && cp "/usr/share/zoneinfo/Europe/Amsterdam" /etc/localtime \
    && rm -rf /tmp/* /var/cache/apk/*

RUN set -ex && if [[ "${APP_ENV}" == "prod" ]]; then mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; fi
RUN set -ex && if [[ "${APP_ENV}" != "prod" ]]; then  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; fi
RUN echo "date.timezone=Europe/Amsterdam" >> "$PHP_INI_DIR/php.ini"

RUN set -ex \
    && echo "date.timezone = Europe/Amsterdam" >> "$PHP_INI_DIR/php.ini" \
    && echo "short_open_tag = Off" >> "$PHP_INI_DIR/php.ini" \
    && echo "log_errors = On" >> "$PHP_INI_DIR/php.ini" \
    && echo "error_reporting = E_ALL" >> "$PHP_INI_DIR/php.ini" \
    && echo "display_errors = Off" >> "$PHP_INI_DIR/php.ini" \
    && echo "error_log = /proc/self/fd/2" >> "$PHP_INI_DIR/php.ini" \
    && echo "memory_limit = 256M" >> "$PHP_INI_DIR/php.ini" \
    && if [[ "${APP_ENV}" == "prod" ]]; then echo "opcache.max_accelerated_files = 20000" >> "$PHP_INI_DIR/php.ini"; fi \
    && if [[ "${APP_ENV}" == "prod" ]]; then echo "opcache.memory_consumption=256" >> "$PHP_INI_DIR/php.ini"; fi \
    && if [[ "${APP_ENV}" == "prod" ]]; then echo "opcache.validate_timestamps=0" >> "$PHP_INI_DIR/php.ini"; fi \
    && if [[ "${APP_ENV}" == "prod" ]]; then echo "realpath_cache_size = 4096K" >> "$PHP_INI_DIR/php.ini"; fi \
    && if [[ "${APP_ENV}" == "prod" ]]; then echo "realpath_cache_ttl = 600" >> "$PHP_INI_DIR/php.ini"; fi 

RUN set -ex && rm -rf /tmp/* /var/cache/apk/*

CMD ["php-fpm"]
