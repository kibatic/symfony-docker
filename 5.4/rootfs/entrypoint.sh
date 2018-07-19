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

exec /usr/bin/supervisord -n
