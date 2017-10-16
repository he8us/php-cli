FROM php:7.1-alpine

MAINTAINER Cedric Michaux <cedric@he8us.be>

ENV CONFD_VERSION 0.14.0
ENV IMAGICK_VERSION 3.4.3
ENV COMPOSER_ALLOW_SUPERUSER 1


COPY entrypoint.sh /app/entrypoint.sh
COPY confd/ /etc/confd


RUN \
    curl -L -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 \
    && chmod +x /usr/local/bin/confd

RUN \
    apk --no-cache add  \
        freetype-dev \
        icu-dev \
        imagemagick-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libtool \
        pcre-dev \
        wget \
        zip \
        git

RUN \
    apk --no-cache add \
        --virtual .phpize-deps \
        build-base \
        autoconf \
    && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && pecl install imagick-${IMAGICK_VERSION} \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        bcmath \
        gd \
        exif \
        intl \
        mbstring \
        mcrypt \
        pdo_mysql \
        zip \
    && apk del .phpize-deps

RUN \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer


ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["php-fpm"]
