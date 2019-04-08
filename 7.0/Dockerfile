FROM debian:stretch

MAINTAINER Elie Charra <elie.charra [at] kibatic.com>

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get -qq update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    supervisor \
    ca-certificates \
    nginx \
    git \
    unzip \
    php7.0 \
    php7.0-cli \
    php7.0-intl \
    php7.0-xml \
    php7.0-zip \
    php7.0-mbstring \
    php7.0-fpm > /dev/null &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    mkdir -p /run/php && \
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
             --install-dir=/usr/local/bin \
             --filename=composer &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini &&\
    echo "daemon off;" >> /etc/nginx/nginx.conf

COPY rootfs /

ENV LOG_STREAM="/var/stdout"
RUN mkfifo $LOG_STREAM && chmod 777 $LOG_STREAM

WORKDIR /var/www

EXPOSE 80

CMD ["/entrypoint.sh"]
