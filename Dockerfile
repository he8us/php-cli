FROM php:7.0-cli

MAINTAINER Cedric Michaux <cedric@he8us.be>

COPY entrypoint.sh /app/entrypoint.sh
COPY confd/ /etc/confd

ENV CONFD_VERSION 0.11.0

RUN \
    curl -L -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 && \
    chmod +x /usr/local/bin/confd


RUN \
    apt-get update -qq && \
    apt-get install -yqq \
        --no-install-recommends \
        icu-devtools \
        libicu-dev \
        libmcrypt-dev \
        libmagickwand-dev \
        mysql-client \
    && docker-php-ext-install \
        pdo_mysql \
        exif \
        intl \
        mbstring \
        mcrypt \
        bcmath


RUN pecl install imagick \
    && docker-php-ext-enable imagick


RUN \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

COPY . /app/
WORKDIR /app/

ENTRYPOINT ["/app/entrypoint.sh"]
