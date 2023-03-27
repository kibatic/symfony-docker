#!/usr/bin/env bash

BASE_DIR=/var/www/
# Following folders must be writables by www-data web user
# Handle Symfony 3.x directory layout (var/...) and legacy layout (app/...)
RW_FOLDERS=(var app/cache app/logs)

for dir in "${RW_FOLDERS[@]}"; do
  if [ -d "$BASE_DIR$dir" ]; then
    echo "Fix permission for $BASE_DIR$dir"
    chown -R www-data $BASE_DIR$dir
  fi
done

NGINX_CONFIG=symfony3
if [[ "$SYMFONY_VERSION" = "4" ]]
then
  NGINX_CONFIG=symfony4
fi

# Avoid to remove a bind mounted nginx config
NGINX_DEFAULT=/etc/nginx/sites-enabled/default
if ! mountpoint -q $NGINX_DEFAULT; then
  echo "Using default nginx config : $NGINX_CONFIG"
  ln -s /etc/nginx/sites-available/$NGINX_CONFIG.conf $NGINX_DEFAULT
fi

# Disable opcache optimisation for developpement
# Allow files to be reloaded when update without restarting fpm process
if [[ "$PERFORMANCE_OPTIM" = "false" ]]
then
  echo "Disable performance optimisation"
  echo > /etc/php7/conf.d/99-symfony.ini
fi

exec /usr/bin/supervisord -n
