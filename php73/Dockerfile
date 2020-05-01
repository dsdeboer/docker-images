ARG APP_ENV=dev
ARG APP_DEBUG=1
ARG PHP_TYPE=cli
FROM php:7.3-${PHP_TYPE}-alpine

ENV APP_ENV $APP_ENV
ENV APP_DEBUG $APP_DEBUG

RUN set -ex 
RUN apk add --update icu-dev oniguruma-dev libzip-dev libxml2-dev bzip2-dev curl-dev 
RUN docker-php-ext-install -j4 intl mbstring zip xml bz2 curl json 
RUN if [[ "${APP_ENV}" == "prod" ]]; then docker-php-ext-install opcache; fi 
RUN if [[ "${APP_ENV}" == "prod" ]]; then docker-php-ext-enable opcache; fi 
RUN apk add tzdata 
RUN cp "/usr/share/zoneinfo/Europe/Amsterdam" /etc/localtime 
RUN rm -rf /tmp/* /var/cache/apk/*

RUN set -ex && if [[ "${APP_ENV}" == "prod" ]]; then mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; fi
RUN set -ex && if [[ "${APP_ENV}" != "prod" ]]; then  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; fi
RUN echo "date.timezone=Europe/Amsterdam" >> "$PHP_INI_DIR/php.ini" 
RUN echo "short_open_tag = Off" >> "$PHP_INI_DIR/php.ini" 
RUN echo "log_errors = On" >> "$PHP_INI_DIR/php.ini" 
RUN echo "error_reporting = E_ALL" >> "$PHP_INI_DIR/php.ini" 
RUN echo "display_errors = On" >> "$PHP_INI_DIR/php.ini" 
RUN echo "error_log = /proc/self/fd/2" >> "$PHP_INI_DIR/php.ini" 
RUN echo "memory_limit = 256M" >> "$PHP_INI_DIR/php.ini" 
RUN if [[ "${APP_ENV}" == "prod" ]]; then echo "display_errors = Off" >> "$PHP_INI_DIR/php.ini"; fi 
RUN if [[ "${APP_ENV}" == "prod" ]]; then echo "opcache.max_accelerated_files = 20000" >> "$PHP_INI_DIR/php.ini"; fi 
RUN if [[ "${APP_ENV}" == "prod" ]]; then echo "opcache.memory_consumption=256" >> "$PHP_INI_DIR/php.ini"; fi 
RUN if [[ "${APP_ENV}" == "prod" ]]; then echo "opcache.validate_timestamps=0" >> "$PHP_INI_DIR/php.ini"; fi 
RUN if [[ "${APP_ENV}" == "prod" ]]; then echo "realpath_cache_size = 4096K" >> "$PHP_INI_DIR/php.ini"; fi 
RUN if [[ "${APP_ENV}" == "prod" ]]; then echo "realpath_cache_ttl = 600" >> "$PHP_INI_DIR/php.ini"; fi 

RUN set -ex && rm -rf /tmp/* /var/cache/apk/*

CMD ["php-fpm"]

WORKDIR /root
RUN set -ex; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "\$lines=file('https://composer.github.io/installer.sig',FILE_IGNORE_NEW_LINES); if (  hash_file('SHA384', 'composer-setup.php') ===  \$lines[0] ) { echo 'In    staller verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    php -r "unlink('composer-setup.php');";

RUN mkdir /var/app
WORKDIR /var/app
