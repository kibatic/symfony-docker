FROM debian:bullseye

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

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ bullseye main" > /etc/apt/sources.list.d/php.list && \
    apt-get update -qq > /dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    php8.1 \
    php8.1-cli \
    php8.1-intl \
    php8.1-fpm \
    php8.1-xml \
    php8.1-mbstring \
    php8.1-curl > /dev/null && \
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
