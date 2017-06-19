FROM debian:jessie

MAINTAINER Elie Charra <elie.charra [at] kibatic.com>

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    supervisor \
    ca-certificates \
    nginx \
    wget &&\
    echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && \
    wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
    apt-get update && \
    apt-get -qq -y --no-install-recommends install \
    php7.0 \
    php7.0-cli \
    php7.0-intl \
    php7.0-xml \
    php7.0-zip \
    php7.0-mbstring \
    php7.0-fpm &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    mkdir -p /run/php && \
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
             --install-dir=/usr/local/bin \
             --filename=composer &&\
    echo 'clear_env = no' >> /etc/php/7.0/fpm/pool.d/www.conf &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini &&\
    echo "daemon off;" >> /etc/nginx/nginx.conf

COPY config/vhost.conf /etc/nginx/sites-enabled/default
COPY config/logs.conf /etc/nginx/conf.d/docker/logs.conf
COPY config/supervisord/conf.d /etc/supervisor/conf.d

WORKDIR /var/www

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
