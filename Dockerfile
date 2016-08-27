FROM php:7.0-cli

MAINTAINER Cedric Michaux <cedric@he8us.be>

COPY entrypoint.sh /app/entrypoint.sh
COPY confd/ /etc/confd

ENV CONFD_VERSION 0.11.0


RUN \
    apt-get update -qq && \
    apt-get install -yqq \
        icu-devtools \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libmcrypt-dev \
        mysql-client \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install \
        pdo_mysql \
        gd \
        intl \
        mbstring \
        mcrypt \
        bcmath



RUN \
    curl -L -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 && \
    chmod +x /usr/local/bin/confd


RUN \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

COPY . /app/
WORKDIR /app/

ENTRYPOINT ["/app/entrypoint.sh"]
