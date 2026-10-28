FROM debian:trixie-slim

LABEL maintainer="Kibatic system@kibatic.com"

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PERFORMANCE_OPTIM false

RUN apt-get -qq update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    apt-utils \
    supervisor \
    ca-certificates \
    nginx \
    wget \
    vim \
    git \
    curl \
    openssl \
    make \
    unzip \
    apt-transport-https > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP 7.4 fourni par sury (toujours maintenu pour trixie, avec les correctifs de sécurité)
# Debian 13 (apt sqv) : clé dans un keyring dédié référencé par signed-by
RUN curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && \
    echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ trixie main" > /etc/apt/sources.list.d/php.list && \
    apt-get update -qq > /dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    php7.4 \
    php7.4-cli \
    php7.4-intl \
    php7.4-fpm \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-curl > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir -p /run/php

COPY rootfs /

WORKDIR /var/www

EXPOSE 80

CMD ["/entrypoint.sh"]
