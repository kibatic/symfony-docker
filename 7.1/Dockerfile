FROM debian:stretch

MAINTAINER Elie Charra <elie.charra [at] kibatic.com>

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get -qq update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    supervisor \
    ca-certificates \
    nginx \
    wget \
    apt-transport-https > /dev/null &&\
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&\
    echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list &&\
    apt-get update -qq > /dev/null &&\
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    unzip \
    php7.1 \
    php7.1-cli \
    php7.1-intl \
    php7.1-fpm \
    php7.1-xml \
    php7.1-mbstring \
    php7.1-zip > /dev/null &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
             --install-dir=/usr/local/bin \
             --filename=composer &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.1/fpm/php.ini &&\
    echo "daemon off;" >> /etc/nginx/nginx.conf &&\
    mkdir -p /run/php

COPY rootfs /

ENV LOG_STREAM="/var/stdout"
RUN mkfifo $LOG_STREAM && chmod 777 $LOG_STREAM

WORKDIR /var/www

EXPOSE 80

CMD ["/entrypoint.sh"]
