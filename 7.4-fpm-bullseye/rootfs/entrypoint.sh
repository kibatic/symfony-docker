#!/usr/bin/env bash

BASE_DIR=/var/www/
# Following folders must be writables by www-data web user
RW_FOLDERS=(var)

for dir in "${RW_FOLDERS[@]}"; do
  if [ -d "$BASE_DIR$dir" ]; then
    echo "Fix permission for $BASE_DIR$dir"
    chown -R www-data $BASE_DIR$dir
  fi
done

SYMFONY_VERSION=${SYMFONY_VERSION:-5}
NGINX_CONFIG=symfony$SYMFONY_VERSION

# Avoid to remove a bind mounted nginx config
NGINX_DEFAULT=/etc/nginx/sites-enabled/default
if ! mountpoint -q $NGINX_DEFAULT; then
  echo "Using default nginx config : $NGINX_CONFIG"
  rm $NGINX_DEFAULT
  ln -s /etc/nginx/sites-available/$NGINX_CONFIG.conf $NGINX_DEFAULT
fi

# Disable opcache optimisation for developpement
# Allow files to be reloaded when update without restarting fpm process
if [[ "$PERFORMANCE_OPTIM" = "false" ]]
then
  echo "Disable performance optimisation"
  echo > /usr/local/etc/php/conf.d/99-symfony.ini
fi

exec /usr/bin/supervisord -n
