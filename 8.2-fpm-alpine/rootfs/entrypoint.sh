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

# Disable opcache optimisation for developpement
# Allow files to be reloaded when update without restarting fpm process
if [[ "$PERFORMANCE_OPTIM" = "false" ]]
then
  echo "Disable performance optimisation"
  echo > /etc/php8/conf.d/99-symfony.ini
fi

exec /usr/bin/supervisord -n
