ARG APP_ENV=${APP_ENV:-dev}
ARG APP_DEBUG=${APP_DEBUG:-1}
ARG PHP_TYPE=${PHP_TYPE:-cli}
ARG WITH_DATABASE=${WITH_DATABASE:-no}
ARG PHP_VERSION=${PHP_VERSION:-7.3}
ARG TIMEZONE=${TIMEZONE:-"Europe/Amsterdam"}
FROM php:${PHP_VERSION}-${PHP_TYPE}-alpine

WORKDIR /var/www

ENV APP_ENV $APP_ENV
ENV APP_DEBUG $APP_DEBUG

RUN set -ex \
    && apk add --update icu-dev oniguruma-dev libzip-dev libxml2-dev bzip2-dev curl-dev \
    && if [[ "${WITH_DATABASE}" == "yes" ]]; then apk add --update postgresql-dev git; fi \
    && docker-php-ext-install -j4 intl mbstring zip xml bz2 curl json \
    && if [[ "${APP_ENV}" == "prod" ]]; then docker-php-ext-install opcache; fi \
    && if [[ "${APP_ENV}" == "prod" ]]; then docker-php-ext-enable opcache; fi \
    && if [[ "${WITH_DATABASE}" == "yes" ]]; then docker-php-ext-install pdo pgsql pdo_pgsql; fi \
    && if [[ "${WITH_DATABASE}" == "yes" ]]; then docker-php-ext-enable pdo pgsql pdo_pgsql; fi \
    && apk add tzdata \
    && cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime \
    && rm -rf /tmp/* /var/cache/apk/*

RUN set -ex && if [[ "${APP_ENV}" == "prod" ]]; then mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; fi
RUN set -ex && if [[ "${APP_ENV}" != "prod" ]]; then  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; fi
RUN echo "date.timezone=${TIMEZONE" >> "$PHP_INI_DIR/php.ini"

RUN set -ex \
    && echo "date.timezone = ${TIMEZONE}" >> "$PHP_INI_DIR/php.ini" \
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

WORKDIR /root
RUN set -ex; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "\$lines=file('https://composer.github.io/installer.sig',FILE_IGNORE_NEW_LINES); if (  hash_file('SHA384', 'composer-setup.php') ===  \$lines[0] ) { echo 'In    staller verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    php -r "unlink('composer-setup.php');";

