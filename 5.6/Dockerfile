FROM debian:jessie

MAINTAINER Elie Charra <elie.charra [at] kibatic.com>

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get -qq update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    supervisor \
    ca-certificates \
    nginx \
    git \
    php5 \
    php5-cli \
    php5-intl \
    php5-fpm > /dev/null &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
             --install-dir=/usr/local/bin \
             --filename=composer &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini &&\
    echo "daemon off;" >> /etc/nginx/nginx.conf

COPY rootfs /

ENV LOG_STREAM="/tmp/stdout"
RUN mkfifo $LOG_STREAM && chmod 777 $LOG_STREAM

WORKDIR /var/www

EXPOSE 80

CMD ["/entrypoint.sh"]
