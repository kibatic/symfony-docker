#!/usr/bin/env bash

# Following folders must be writables by www-data web user
RW_FOLDERS=(var/cache var/logs var/sessions app/cache app/logs)

for dir in $RW_FOLDERS; do
  if [ -d "/var/www/$dir" ]; then
    echo "Fix permission for /var/www/$dir"
    chown -R www-data /var/www/$dir
  fi
done

exec /usr/bin/supervisord -n
