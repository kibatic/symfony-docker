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

NGINX_CONFIG=symfony4
if [[ "$SYMFONY_VERSION" = "3" ]]
then
  NGINX_CONFIG=symfony3
fi

rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/$NGINX_CONFIG.conf /etc/nginx/sites-enabled/default

exec /usr/bin/supervisord -n
