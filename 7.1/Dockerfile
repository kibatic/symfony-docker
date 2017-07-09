FROM debian:jessie

MAINTAINER Elie Charra <elie.charra [at] kibatic.com>

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    supervisor \
    ca-certificates \
    nginx \
    wget \
    git \
    apt-transport-https &&\
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&\
    echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list &&\
    apt-get update -qq &&\
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    php7.1 \
    php7.1-cli \
    php7.1-intl \
    php7.1-fpm \
    php7.1-xml \
    php7.1-zip &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
             --install-dir=/usr/local/bin \
             --filename=composer &&\
    echo 'clear_env = no' >> /etc/php/7.1/fpm/pool.d/www.conf &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.1/fpm/php.ini &&\
    echo "daemon off;" >> /etc/nginx/nginx.conf &&\
    mkdir -p /run/php

COPY rootfs /

WORKDIR /var/www

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
