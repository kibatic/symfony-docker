FROM php:8.3-fpm-bookworm

LABEL org.opencontainers.image.authors="Philippe Le Van (https://framapiaf.org/@plv)"

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PERFORMANCE_OPTIM false

RUN apt-get -qq update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    apt-utils \
    supervisor \
    ca-certificates \
    wget \
    vim \
    git \
    curl \
    openssl \
    make \
    unzip \
    libzip-dev \
    libicu-dev \
    apt-transport-https > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# nginx stable depuis le dépôt officiel nginx.org (plus récent que le paquet Debian)
# Le paquet nginx.org n'a ni sites-enabled ni user www-data : on reprend la disposition Debian.
RUN . /etc/os-release && \
    curl -fsSL https://nginx.org/keys/nginx_signing.key -o /usr/share/keyrings/nginx-archive-keyring.asc && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.asc] https://nginx.org/packages/debian ${VERSION_CODENAME} nginx" > /etc/apt/sources.list.d/nginx.list && \
    printf "Package: *\nPin: origin nginx.org\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx && \
    apt-get -qq update > /dev/null && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install nginx > /dev/null && \
    rm -f /etc/nginx/conf.d/default.conf && \
    mkdir -p /etc/nginx/sites-enabled /etc/nginx/sites-available && \
    sed -i -e 's/^user .*/user www-data;/' \
        -e 's#^\(\s*\)include /etc/nginx/conf.d/\*.conf;#&\n\1include /etc/nginx/sites-enabled/*;#' /etc/nginx/nginx.conf && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-install \
    intl \
    bcmath \
    zip \
    opcache

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" &&\
    php composer-setup.php &&\
    php -r "unlink('composer-setup.php');" &&\
    mv composer.phar /usr/local/bin/composer

# config php
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" "$PHP_INI_DIR/php.ini" && \
    mkdir -p /run/php

# config nginx
#RUN sed -i -e "s#include /etc/nginx/conf.d/\*.conf;#include /etc/nginx/conf.d/*.conf;\ninclude /etc/nginx/sites-enabled/\*;#g" /etc/nginx/nginx.conf &&\
#	echo "daemon off;" >> /etc/nginx/nginx.conf &&\
#    rm /etc/nginx/http.d/default.conf &&\
#    mkdir -p /run/nginx &&\
#    mkdir -p /etc/nginx/sites-enabled \
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
    mkdir -p /run/php

COPY rootfs /

ENV LOG_STREAM="/var/stdout"
RUN mkfifo $LOG_STREAM && chmod 777 $LOG_STREAM

WORKDIR /var/www

EXPOSE 80

CMD ["/entrypoint.sh"]
