FROM debian:wheezy

MAINTAINER Elie Charra <elie.charra [at] kibatic.com>

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    supervisor \
    ca-certificates \
    nginx \
    git \
    php5 \
    php5-cli \
    php5-intl \
    php5-fpm &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    php -r "readfile('https://getcomposer.org/installer');" | php -- \
             --install-dir=/usr/local/bin \
             --filename=composer &&\
    echo '[www]' > /etc/php/5.4/fpm/pool.d/www_kibatic.conf &&\
    echo 'clear_env = no' >> /etc/php/5.4/fpm/pool.d/www_kibatic.conf &&\
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini &&\
    echo "daemon off;" >> /etc/nginx/nginx.conf

COPY config/vhost.conf /etc/nginx/sites-enabled/default
COPY config/logs.conf /etc/nginx/conf.d/docker/logs.conf
COPY config/supervisord/conf.d /etc/supervisor/conf.d

WORKDIR /var/www

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n"]
