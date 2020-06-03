ARG base_image=php
ARG version=7.4

FROM ${base_image}:${version}-fpm-alpine as base
LABEL MAINTAINER="Duncan de Boer <duncan@charpand.nl>"

RUN set -ex \
    && apk add --update icu-dev oniguruma-dev libzip-dev libxml2-dev bzip2-dev curl-dev \
    && docker-php-ext-install -j4 intl mbstring zip xml bz2 curl json \
    && apk add tzdata \
    && pecl install pcov
    && cp "/usr/share/zoneinfo/Europe/Amsterdam" /etc/localtime \
    && rm -rf /tmp/* /var/cache/apk/*

RUN echo "date.timezone=Europe/Amsterdam" >> "$PHP_INI_DIR/conf.d/custom.ini"; \
    echo "short_open_tag = Off" >> "$PHP_INI_DIR/conf.d/custom.ini"; \
    echo "log_errors = On" >> "$PHP_INI_DIR/conf.d/custom.ini"; \
    echo "error_reporting = E_ALL" >> "$PHP_INI_DIR/conf.d/custom.ini"; \
    echo "error_log = /proc/self/fd/2" >> "$PHP_INI_DIR/conf.d/custom.ini"; \
    echo "memory_limit = 256M" >> "$PHP_INI_DIR/conf.d/custom.ini"; \
    set -ex && rm -rf /tmp/* /var/cache/apk/*

RUN set -ex; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    php -r "\$lines=file('https://composer.github.io/installer.sig',FILE_IGNORE_NEW_LINES); if (  hash_file('SHA384', 'composer-setup.php') ===  \$lines[0] ) { echo 'In    staller verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    php -r "unlink('composer-setup.php');";

RUN mkdir /var/app
WORKDIR /var/app

CMD ["php-fpm"]

FROM base as dev

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN echo "display_errors = On" >> "$PHP_INI_DIR/conf.d/custom.ini"
ENV APP_ENV dev
ENV APP_DEBUG 1
WORKDIR /var/app
CMD ["php-fpm"]


FROM base as prod

RUN set -ex 
RUN apk add --update
RUN docker-php-ext-install opcache
RUN docker-php-ext-enable opcache
RUN set -ex && rm -rf /tmp/* /var/cache/apk/*
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN echo "display_errors = Off" >> "$PHP_INI_DIR/conf.d/custom.ini"
RUN echo "opcache.max_accelerated_files = 20000" >> "$PHP_INI_DIR/conf.d/custom.ini"
RUN echo "opcache.memory_consumption=256" >> "$PHP_INI_DIR/conf.d/custom.ini"
RUN echo "opcache.validate_timestamps=0" >> "$PHP_INI_DIR/conf.d/custom.ini"
RUN echo "realpath_cache_size = 4096K" >> "$PHP_INI_DIR/conf.d/custom.ini"
RUN echo "realpath_cache_ttl = 600" >> "$PHP_INI_DIR/conf.d/custom.ini"
ENV APP_ENV prod
ENV APP_DEBUG 1
WORKDIR /var/app
CMD ["php-fpm"]
